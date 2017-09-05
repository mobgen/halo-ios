//
//  SearchQuerySpec.swift
//  Halo
//
//  Created by Miguel López on 23/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class SearchQuerySpec : BaseSpec {
    
    static let TestFields = ["testField1", "testField2"]
    static let TestTags = [
        Tag(name: "\(DeviceSpec.TestNameTag)1", value: "\(DeviceSpec.TestValueTag)1", type: "testTypeTag1"),
        Tag(name: "\(DeviceSpec.TestNameTag)2", value: "\(DeviceSpec.TestValueTag)2", type: "testTypeTag2")
    ]
    static let TestModuleIds = ["testModuleId1", "testModuleId2"]
    static let TestModuleName = "testModuleName"
    static let TestInstanceIds = ["testInstanceId1", "testInstanceId2"]
    static let RelatedToFieldName = "relatedToField"
    static let RelatedToInstanceIds = ["instanceId1", "instanceId2"]
    static let TestPopulateFields = ["testPopulateField1", "testPopulateField2"]
    static let TestSegmentWithDevice = true
    static let TestSegmentMode: SegmentMode = .total
    static let TestLocale: Halo.Locale = .englishUnitedKingdom
    static let TestPage = 1
    static let TestLimit = 20
    
    override func spec() {
        var searchQuery: SearchQuery!
        var searchQueryReturned: SearchQuery? = nil

        beforeEach {
            searchQuery = SearchQuery()
        }
        
        describe("A SearchQuery") {
            describe("its searchFilter method") {
                let searchFilter = MockSearchFilter.createSearchFilter()
                
                beforeEach {
                    searchQueryReturned = searchQuery.searchFilter(searchFilter)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    let conditions = searchQuery.conditions
                    expect(conditions).toNot(beNil())
                    expect(conditions!["condition"]).to(beNil())
                    expect(conditions!["operands"]).to(beNil())
                    expect(conditions!["operation"] as? String).to(equal(MockSearchFilter.TestOperation.description))
                    expect(conditions!["property"] as? String).to(equal(MockSearchFilter.TestProperty))
                    expect(conditions!["value"] as? String).to(equal(MockSearchFilter.TestValueString))
                    expect(conditions!["type"] as? String).to(equal(MockSearchFilter.TestType))
                }
            }
            
            describe("its metaFilter method") {
                let searchFilter = MockSearchFilter.createSearchFilter()
                
                beforeEach {
                    searchQueryReturned = searchQuery.metaFilter(searchFilter)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    let metaConditions = searchQuery.metaConditions
                    expect(metaConditions).toNot(beNil())
                    expect(metaConditions!["condition"]).to(beNil())
                    expect(metaConditions!["operands"]).to(beNil())
                    expect(metaConditions!["operation"] as? String).to(equal(MockSearchFilter.TestOperation.description))
                    expect(metaConditions!["property"] as? String).to(equal(MockSearchFilter.TestProperty))
                    expect(metaConditions!["value"] as? String).to(equal(MockSearchFilter.TestValueString))
                    expect(metaConditions!["type"] as? String).to(equal(MockSearchFilter.TestType))
                }
            }
            
            describe("its fields method") {
                beforeEach {
                    searchQueryReturned = searchQuery.fields(SearchQuerySpec.TestFields)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.fields).toNot(beNil())
                    expect(searchQuery.fields?.count).to(equal(SearchQuerySpec.TestFields.count))
                }
            }
            
            describe("its tags method") {
                beforeEach {
                    searchQueryReturned = searchQuery.tags(SearchQuerySpec.TestTags)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.tags).toNot(beNil())
                    expect(searchQuery.tags?.count).to(equal(SearchQuerySpec.TestTags.count))
                }
            }
            
            describe("its moduleIds method") {
                beforeEach {
                    searchQueryReturned = searchQuery.moduleIds(SearchQuerySpec.TestModuleIds)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.moduleIds).toNot(beNil())
                    expect(searchQuery.moduleIds?.count).to(equal(SearchQuerySpec.TestModuleIds.count))
                }
            }
            
            describe("its moduleName method") {
                beforeEach {
                    searchQueryReturned = searchQuery.moduleName(SearchQuerySpec.TestModuleName)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.moduleName).to(equal(SearchQuerySpec.TestModuleName))
                }
            }
            
            describe("its instanceIds method") {
                beforeEach {
                    searchQueryReturned = searchQuery.instanceIds(SearchQuerySpec.TestInstanceIds)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.instanceIds).toNot(beNil())
                    expect(searchQuery.instanceIds?.count).to(equal(SearchQuerySpec.TestInstanceIds.count))
                }
            }
            
            describe("its relatedTo method") {
                beforeEach {
                    searchQueryReturned = searchQuery.addRelatedInstances(fieldName: SearchQuerySpec.RelatedToFieldName, instanceIds: SearchQuerySpec.RelatedToInstanceIds)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQueryReturned?.relatedTo).toNot(beNil())
                    expect(searchQueryReturned?.relatedTo.count).to(equal(SearchQuerySpec.RelatedToInstanceIds.count))
                }
            }
            
            describe("its populateFields method") {
                beforeEach {
                    searchQueryReturned = searchQuery.populateFields(SearchQuerySpec.TestPopulateFields)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.populateFields).toNot(beNil())
                    expect(searchQuery.populateFields?.count).to(equal(SearchQuerySpec.TestPopulateFields.count))
                }
            }
            
            describe("its populateAll method") {
                beforeEach {
                    searchQueryReturned = searchQuery.populateAll()
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.populateFields).toNot(beNil())
                    expect(searchQuery.populateFields?.count).to(equal(1))
                    expect(searchQuery.populateFields?.first).to(equal("all"))
                }
            }
            
            describe("its segmentWithDevice method") {
                beforeEach {
                    searchQueryReturned = searchQuery.segmentWithDevice(SearchQuerySpec.TestSegmentWithDevice)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.segmentWithDevice).toNot(beNil())
                    expect(searchQuery.segmentWithDevice).to(equal(SearchQuerySpec.TestSegmentWithDevice))
                }
            }
            
            describe("its segmentWithDevice method") {
                beforeEach {
                    searchQueryReturned = searchQuery.segmentMode(SearchQuerySpec.TestSegmentMode)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.segmentMode.rawValue).to(equal(SearchQuerySpec.TestSegmentMode.rawValue))
                }
            }
            
            describe("its locale method") {
                beforeEach {
                    searchQueryReturned = searchQuery.locale(SearchQuerySpec.TestLocale)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.locale).toNot(beNil())
                    expect(searchQuery.locale?.rawValue).to(equal(SearchQuerySpec.TestLocale.rawValue))
                }
            }
            
            describe("its skipPagination method") {
                beforeEach {
                    searchQueryReturned = searchQuery.skipPagination()
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.pagination).toNot(beNil())
                    expect(searchQuery.pagination?["skip"]).toNot(beNil())
                    expect(searchQuery.pagination?["skip"] as? String).to(equal("true"))
                }
            }
            
            describe("its paginationWithPage method") {
                beforeEach {
                    searchQueryReturned = searchQuery.pagination(page: SearchQuerySpec.TestPage, limit: SearchQuerySpec.TestLimit)
                }
                
                it("works") {
                    expect(searchQueryReturned).toNot(beNil())
                    expect(searchQuery.pagination).toNot(beNil())
                    expect(searchQuery.pagination?["page"] as? Int).to(equal(SearchQuerySpec.TestPage))
                    expect(searchQuery.pagination?["limit"] as? Int).to(equal(SearchQuerySpec.TestLimit))
                    expect(searchQuery.pagination?["skip"] as? String).to(equal("false"))
                }
            }
            
            describe("its body property") {
                var dictReturnedByBody: [String: Any]!
                let searchFilter = MockSearchFilter.createSearchFilter()
                let device = Device()
                device.setTag(name: "testDeviceNameTag", value: "testDeviceValueTag")
                
                beforeEach {
                    Manager.core.device = device
                    
                    searchQueryReturned = searchQuery.moduleIds(SearchQuerySpec.TestModuleIds)
                    .moduleName(SearchQuerySpec.TestModuleName)
                    .instanceIds(SearchQuerySpec.TestModuleIds)
                    .searchFilter(searchFilter)
                    .metaFilter(searchFilter)
                    .fields(SearchQuerySpec.TestFields)
                    .tags(SearchQuerySpec.TestTags)
                    .populateFields(SearchQuerySpec.TestPopulateFields)
                    .pagination(page: SearchQuerySpec.TestPage, limit: SearchQuerySpec.TestLimit)
                    .segmentWithDevice(SearchQuerySpec.TestSegmentWithDevice)
                    .segmentMode(SearchQuerySpec.TestSegmentMode)
                    .locale(SearchQuerySpec.TestLocale)
                    dictReturnedByBody = searchQueryReturned?.body
                }
                
                it("works") {
                    expect(dictReturnedByBody).toNot(beNil())
                    
                    expect((dictReturnedByBody[SearchQuery.Keys.ModuleIds] as? [String])?.count).to(equal(SearchQuerySpec.TestModuleIds.count))
                    
                    expect((dictReturnedByBody[SearchQuery.Keys.ModuleName] as? String)).to(equal(SearchQuerySpec.TestModuleName))
                    
                    expect((dictReturnedByBody[SearchQuery.Keys.InstanceIds] as? [String])?.count).to(equal(SearchQuerySpec.TestInstanceIds.count))
                    
                    let searchValues = dictReturnedByBody[SearchQuery.Keys.SearchValues] as? [String: Any]
                    expect(searchValues).toNot(beNil())
                    expect(searchValues!["condition"]).to(beNil())
                    expect(searchValues!["operands"]).to(beNil())
                    expect(searchValues!["operation"] as? String).to(equal(MockSearchFilter.TestOperation.description))
                    expect(searchValues!["property"] as? String).to(equal(MockSearchFilter.TestProperty))
                    expect(searchValues!["value"] as? String).to(equal(MockSearchFilter.TestValueString))
                    expect(searchValues!["type"] as? String).to(equal(MockSearchFilter.TestType))
                    
                    let metaSearch = dictReturnedByBody[SearchQuery.Keys.MetaSearch] as? [String: Any]
                    expect(metaSearch).toNot(beNil())
                    expect(metaSearch!["condition"]).to(beNil())
                    expect(metaSearch!["operands"]).to(beNil())
                    expect(metaSearch!["operation"] as? String).to(equal(MockSearchFilter.TestOperation.description))
                    expect(metaSearch!["property"] as? String).to(equal(MockSearchFilter.TestProperty))
                    expect(metaSearch!["value"] as? String).to(equal(MockSearchFilter.TestValueString))
                    expect(metaSearch!["type"] as? String).to(equal(MockSearchFilter.TestType))
                    
                    expect((dictReturnedByBody[SearchQuery.Keys.Fields] as? [String])?.count).to(equal(SearchQuerySpec.TestFields.count))
                    
                    let tags = dictReturnedByBody[SearchQuery.Keys.Tags] as? [[String: Any]]
                    expect(tags?.count).to(equal(SearchQuerySpec.TestTags.count))
                    
                    let fields = dictReturnedByBody[SearchQuery.Keys.Fields] as? [String]
                    expect(fields?.count).to(equal(SearchQuerySpec.TestFields.count))
                    
                    let pagination = dictReturnedByBody[SearchQuery.Keys.Pagination] as? [String: Any]
                    expect(pagination?["page"] as? Int).to(equal(SearchQuerySpec.TestPage))
                    expect(pagination?["limit"] as? Int).to(equal(SearchQuerySpec.TestLimit))
                    expect(pagination?["skip"] as? String).to(equal("false"))
                    
                    let segmentTags = dictReturnedByBody[SearchQuery.Keys.SegmentTags] as? [[String: Any]]
                    expect(segmentTags?.count).to(equal(device.tags?.count))
                    
                    expect((dictReturnedByBody[SearchQuery.Keys.SegmentMode] as? String)).to(equal(SearchQuerySpec.TestSegmentMode.description))
                    
                    expect(dictReturnedByBody[SearchQuery.Keys.Locale] as? String).to(equal(SearchQuerySpec.TestLocale.description))
                }
            }
            
            describe("its hash property") {
                var IntReturnedByHash: Int!
                let searchFilter = MockSearchFilter.createSearchFilter()
                let device = Device()
                device.setTag(name: "testDeviceNameTag", value: "testDeviceValueTag")
                
                beforeEach {
                    Manager.core.device = device
                    
                    searchQueryReturned = searchQuery.moduleIds(SearchQuerySpec.TestModuleIds)
                        .moduleName(SearchQuerySpec.TestModuleName)
                        .instanceIds(SearchQuerySpec.TestModuleIds)
                        .searchFilter(searchFilter)
                        .metaFilter(searchFilter)
                        .fields(SearchQuerySpec.TestFields)
                        .tags(SearchQuerySpec.TestTags)
                        .populateFields(SearchQuerySpec.TestPopulateFields)
                        .pagination(page: SearchQuerySpec.TestPage, limit: SearchQuerySpec.TestLimit)
                        .segmentWithDevice(SearchQuerySpec.TestSegmentWithDevice)
                        .segmentMode(SearchQuerySpec.TestSegmentMode)
                        .locale(SearchQuerySpec.TestLocale)
                    IntReturnedByHash = searchQueryReturned?.hash
                }
                
                it("works") {
                    let values: [String] = (searchQueryReturned?.body.map { key, value in
                        switch value {
                        case let v as AnyObject:
                            return "\(key)-\(v.description)"
                        default:
                            return ""
                        }
                        })!
                    let intCalculated = values.joined(separator: "+").hash
                    expect(IntReturnedByHash).to(equal(intCalculated))
                }
            }
        }
    }
}
