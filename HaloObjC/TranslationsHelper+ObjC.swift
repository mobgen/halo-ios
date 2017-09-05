//
//  TranslationsHelper+ObjC.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 16/08/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Halo

extension TranslationsHelper {
    
    @objc(getAllTexts:)
    open func getAllTextsObjC(_ handler: @escaping ([String: Any]) -> Void) -> Void {
        
        self.getAllTexts { result in
            self.processResult(result: result, handler: handler)
        }
    }
    
    @objc(getTextsWithKeys:completionHandler:)
    open func getTextsObjC(keys: [String], completionHandler handler: @escaping ([String: Any]) -> Void) -> Void {
    
        self.getTexts(keys: keys) { result in
            self.processResult(result: result, handler: handler)
        }
        
    }
    
    fileprivate func processResult(result: [String: String?], handler: @escaping ([String: Any]) -> Void) -> Void {
        var newResult = [String: Any]()
        
        newResult = result.reduce(newResult, { (partialResult, item) -> [String: Any] in
            var result = partialResult
            result[item.key] = item.value ?? NSNull()
            return result
        })
        
        handler(newResult)
    }

}
