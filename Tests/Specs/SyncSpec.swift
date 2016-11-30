//
//  SyncSpec.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 27/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class SyncSpec: BaseSpec {
 
    override func spec() {
        
        super.spec()
        
        let content = Halo.Manager.content
        
        describe("The sync process") {
            
            let moduleId = "571f38b9bb7f372900a14cbc"
            let query = SyncQuery(moduleId: moduleId)
            let syncDate = Date(timeIntervalSince1970: 1475046170088 / 1000)
            
            context("requesting everything") {
                
                beforeEach {
                    stub(isPath("/api/generalcontent/instance/sync")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("full_sync.json", type(of: self))
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Sync stub"
                    
                    content.removeSyncedInstances(moduleId)
                    content.clearSyncLog(moduleId)
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("works") {
                    
                    var instances = content.getSyncedInstances(moduleId)
                    
                    expect(instances).to(beEmpty())
                    
                    waitUntil(timeout: 5) { done in
                        content.sync(query: query) { moduleId, error in
                            done()
                        }
                    }
                    
                    instances = content.getSyncedInstances(moduleId)
                    
                    expect(instances.count).to(equal(949))
                    
                    // Check the log
                    let syncLog = content.getSyncLog(moduleId)
                    let entry = syncLog.last
                    
                    expect(entry?.creations).to(equal(949))
                    expect(entry?.updates).to(equal(0))
                    expect(entry?.deletions).to(equal(0))
                    expect(entry?.syncDate).to(equal(syncDate))
                }
                
            }
            
            context("with updates and deletions") {
                
                let date = Date(timeIntervalSince1970: 1473686540)
                
                beforeEach {
                    stub(isPath("/api/generalcontent/instance/sync")) { (request) -> OHHTTPStubsResponse in
                        
                        let params = try! JSONSerialization.jsonObject(with: (request as NSURLRequest).ohhttpStubs_HTTPBody(), options: .mutableContainers)
                        
                        var fixture = OHPathForFile("to_sync.json", type(of: self))
                        
                        if params["fromSync"] != nil && params["toSync"] == nil {
                            fixture = OHPathForFile("from_sync.json", type(of: self))
                        }
                        
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Sync stub"
                    
                    content.removeSyncedInstances(moduleId)
                    content.clearSyncLog(moduleId)
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("works") {
                    
                    let firstSyncQuery = SyncQuery(moduleId: moduleId).toSync(date: date)
                    let secondSyncQuery = SyncQuery(moduleId: moduleId).fromSync(date: date)
                    
                    waitUntil(timeout: 10) { done in
                        content.sync(query: firstSyncQuery) { _ in
                            done()
                        }
                    }
                    
                    // Check intermediate state
                    var instances = content.getSyncedInstances(moduleId)
                    
                    expect(instances.count).to(equal(924))
                    
                    var logEntry = content.getSyncLog(moduleId).maxElement( { $0.0.syncDate < $0.1.syncDate } )!
                    
                    expect(logEntry.creations).to(equal(924))
                    expect(logEntry.updates).to(equal(0))
                    expect(logEntry.deletions).to(equal(0))
                    
                    waitUntil(timeout: 10) { done in
                        content.sync(query: secondSyncQuery) { _ in
                            done()
                        }
                    }
                    
                    instances = content.getSyncedInstances(moduleId)
                    
                    // Check final state
                    expect(instances.count).to(equal(949))
                    
                    // Check the log
                    logEntry = content.getSyncLog(moduleId).maxElement( { $0.0.syncDate < $0.1.syncDate } )!
                    
                    expect(logEntry.creations).to(equal(25))
                    // TODO: Pending fixes in the backend
                    //expect(logEntry.updates).to(equal(0))
                    //expect(logEntry.deletions).to(equal(0))
                }
                
            }
        }
        
    }
    
}