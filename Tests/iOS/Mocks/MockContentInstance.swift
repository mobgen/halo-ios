//
//  MockContentInstance.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import OHHTTPStubs
@testable import Halo

class MockContentInstance : ContentInstance {
    
    static let TestValueName = "CXJP2HJ Boolean"
    
    class func createFromJson(_ filePath: String? = OHPathForFileInBundle("content_instance.json", Bundle.init(for: MockContentInstance.classForCoder()))) -> ContentInstance? {
        guard
            let filePath = filePath,
            let jsonData = NSData(contentsOfFile: filePath) as? Data,
            let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]),
            let dict = jsonResult as? [String: AnyObject]
        else {
            XCTFail("The creation of fake contentInstance fails.")
            return nil
        }
        return ContentInstance.fromDictionary(dict: dict)
    }
}
