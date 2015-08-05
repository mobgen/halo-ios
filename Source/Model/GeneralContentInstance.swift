//
//  GeneralContentInstance.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public class GeneralContentInstance: NSObject {

    /// Unique identifier of this General Content instance
    public var id: String?

    /// Id of the module to which this instance belongs
    public var moduleId: String?

    /// Name of the instance
    public var name: String?

    /// Collection of key-value pairs which make up the information of this instance
    public var values: Dictionary<String, AnyObject>?

    /// Name of the creator of the content
    public var createdBy: String?

    /// Date in which the content was created
    public var createdAt: NSDate?

    /// Most recent date in which the content was updated
    public var updatedAt: NSDate?

    init(_ dict: Dictionary<String, AnyObject>) {
        id = dict["id"] as? String
        moduleId = dict["module"] as? String
        name = dict["name"] as? String
        values = dict["values"] as? Dictionary<String, AnyObject>
        createdBy = dict["createdBy"] as? String

        if let created = dict["createdAt"] as? Double {
            createdAt = NSDate(timeIntervalSince1970: created/1000)
        }

        if let updated = dict["updatedAt"] as? Double {
            updatedAt = NSDate(timeIntervalSince1970: updated/1000)
        }

    }

}