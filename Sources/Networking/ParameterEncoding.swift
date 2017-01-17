//
//  ParameterEncoding.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 14/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
 HTTP method definitions.

 See https://tools.ietf.org/html/rfc7231#section-4.3
 */
public enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

// MARK: ParameterEncoding

/**
Used to specify the way in which a set of parameters are applied to a URL request.

- `URL`:             Creates a query string to be set as or appended to any existing URL query for `GET`, `HEAD`,
and `DELETE` requests, or set as the body for requests with any other HTTP method. The
`Content-Type` HTTP header field of an encoded request with HTTP body is set to
`application/x-www-form-urlencoded; charset=utf-8`. Since there is no published specification
for how to encode collection types, the convention of appending `[]` to the key for array
values (`foo[]=1&foo[]=2`), and appending the key surrounded by square brackets for nested
dictionary values (`foo[bar]=baz`).

- `URLEncodedInURL`: Creates query string to be set as or appended to any existing URL query. Uses the same
implementation as the `.URL` case, but always applies the encoded result to the URL.

- `JSON`:            Uses `NSJSONSerialization` to create a JSON representation of the parameters object, which is
set as the body of the request. The `Content-Type` HTTP header field of an encoded request is
set to `application/json`.

- `PropertyList`:    Uses `NSPropertyListSerialization` to create a plist representation of the parameters object,
according to the associated format and write options values, which is set as the body of the
request. The `Content-Type` HTTP header field of an encoded request is set to
`application/x-plist`.

- `Custom`:          Uses the associated closure value to construct a new request given an existing request and
parameters.
*/
public enum ParameterEncoding {
    case url
    case urlEncodedInURL
    case json
    case propertyList(PropertyListSerialization.PropertyListFormat, PropertyListSerialization.WriteOptions)
    case custom((URLRequest, [String: Any]?) -> (URLRequest, HaloError?))

    /**
     Creates a URL request by encoding parameters and applying them onto an existing request.

     - parameter URLRequest: The request to have parameters applied.
     - parameter parameters: The parameters to apply.

     - returns: A tuple containing the constructed request and the error that occurred during parameter encoding,
     if any.
     */
    public func encode(request: URLRequest, parameters: [String: Any]?) -> (URLRequest, HaloError?) {
        var mutableURLRequest = request

        guard let parameters = parameters else { return (mutableURLRequest, nil) }

        var encodingError: HaloError? = nil

        switch self {
        case .url, .urlEncodedInURL:
            func query(_ parameters: [String: Any]) -> String {
                var components: [(String, String)] = []

                for key in parameters.keys.sorted(by: <) {
                    let value = parameters[key]!
                    components += queryComponents(key: key, value)
                }

                return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
            }

            func encodesParametersInURL(_ method: Method) -> Bool {
                switch self {
                case .urlEncodedInURL:
                    return true
                default:
                    break
                }

                switch method {
                case .GET, .HEAD, .DELETE:
                    return true
                default:
                    return false
                }
            }

            if let method = Method(rawValue: mutableURLRequest.httpMethod!) , encodesParametersInURL(method) {
                if var URLComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false)
                    , !parameters.isEmpty {
                    let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                    URLComponents.percentEncodedQuery = percentEncodedQuery
                    mutableURLRequest.url = URLComponents.url
                }
            } else {
                if mutableURLRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    mutableURLRequest.setValue(
                        "application/x-www-form-urlencoded; charset=utf-8",
                        forHTTPHeaderField: "Content-Type"
                    )
                }

                mutableURLRequest.httpBody = query(parameters).data(
                    using: String.Encoding.utf8, allowLossyConversion: false
                )
            }
        case .json:
            do {
                let options = JSONSerialization.WritingOptions()
                let data = try JSONSerialization.data(withJSONObject: parameters, options: options)

                if mutableURLRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }

                mutableURLRequest.httpBody = data
            } catch {
                encodingError = .encodingError(error.localizedDescription)
            }
        case .propertyList(let format, let options):
            do {
                let data = try PropertyListSerialization.data(
                    fromPropertyList: parameters, format: format,
                    options: options
                )

                if mutableURLRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                }

                mutableURLRequest.httpBody = data
            } catch {
                encodingError = .encodingError(error.localizedDescription)
            }
        case .custom(let closure):
            (mutableURLRequest, encodingError) = closure(mutableURLRequest, parameters)
        }

        return (mutableURLRequest, encodingError)
    }

    /**
     Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.

     - parameter key:   The key of the query component.
     - parameter value: The value of the query component.

     - returns: The percent-escaped, URL encoded query string components.
     */
    public func queryComponents(key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(key: "\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(key: "\(key)[]", value)
            }
        } else {
            components.append((escape(string: key), escape(string: "\(value)")))
        }

        return components
    }

    /**
     Returns a percent-escaped string following RFC 3986 for a query string key or value.

     RFC 3986 states that the following characters are "reserved" characters.

     - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
     - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="

     In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
     query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
     should be percent-escaped in the query string.

     - parameter string: The string to be percent-escaped.

     - returns: The percent-escaped string.
     */
    public func escape(string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+, ;="

        let allowedCharacterSet = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharacters(in: generalDelimitersToEncode + subDelimitersToEncode)

        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet) ?? string
    }
}