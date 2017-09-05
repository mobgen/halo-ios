//
//  SearchFilter+ObjC.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 03/08/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Halo

extension SearchFilter {
    
    @objc(eq:value:)
    public class func eq(property: String, value: Any?) -> SearchFilter {
        return eq(property: property, value: value)
    }
    
    @objc(neq:value:)
    public class func neq(property: String, value: Any?) -> SearchFilter {
        return neq(property: property, value: value)
    }
    
    @objc(gt:value:)
    public class func gt(property: String, value: Any?) -> SearchFilter {
        return gt(property: property, value: value)
    }
    
    @objc(lt:value:)
    public class func lt(property: String, value: Any?) -> SearchFilter {
        return lt(property: property, value: value)
    }
    
    @objc(gte:value:)
    public class func gte(property: String, value: Any?) -> SearchFilter {
        return gte(property: property, value: value)
    }
    
    @objc(lte:value:)
    public class func lte(property: String, value: Any?) -> SearchFilter {
        return lte(property: property, value: value)
    }
    
    @objc(valueIn:value:)
    public class func valueIn(property: String, value: Any?) -> SearchFilter {
        return valueIn(property: property, value: value)
    }
    
    @objc(valueNotIn:value:)
    public class func valueNotIn(property: String, value: Any?) -> SearchFilter {
        return valueNotIn(property: property, value: value)
    }
    
    @objc(likeWithProperty:value:)
    public class func like(property: String, value: String) -> SearchFilter {
        return like(property: property, value: value)
    }
    
    @objc(and:)
    public class func and(_ elements: [SearchFilter]) -> SearchFilter {
        return and(elements)
    }
    
    @objc(or:)
    public class func or(_ elements: [SearchFilter]) -> SearchFilter {
        return or(elements)
    }
    
}
