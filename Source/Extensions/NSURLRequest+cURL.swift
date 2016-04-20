//
//  NSURLRequest+cURL.swift
//  HaloSDK
//
//  Created by Borja on 02/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

extension NSURLRequest {

    public var curlRequest: String {

        let curlString = NSMutableString(string: "curl -k -X \(self.HTTPMethod!) --dump-header -")

        self.allHTTPHeaderFields?.forEach({ (key, value) -> () in
            let headerKey = self.escapeQuotesInString(key)
            let headerValue = self.escapeQuotesInString(value)
            curlString.appendString(" -H \"\(headerKey): \(headerValue)\"")
        })

        if let bodyData = self.HTTPBody {
            if let bodyDataString = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                curlString.appendString(" -d \"\(self.escapeQuotesInString(bodyDataString))\"")
            }
        }

        if let url = self.URL {
            curlString.appendString(" \"\(url.absoluteString)\"")
        }

        return curlString as String
    }


    private func escapeQuotesInString(str: String) -> String {
        return str.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
    }
}
