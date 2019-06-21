//
//  APIManager.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import Alamofire
import UIKit

let baseURL = "http://gojek-contacts-app.herokuapp.com"
let downloadContacts = baseURL + "/contacts.json"
let deleteContact  = baseURL + "/contacts/%d.json"
let addContact  = baseURL + "/contacts.json"
let updateContact  = baseURL + "/contacts/%d.json"


class APIManager {
    
    class func getData(fromURLObject urlObject:URLObject, completionBlock:@escaping (_ data:Data?, _ error:Error?) -> Void) {
        var req = URLRequest(url: URL(string: urlObject.urlPath)!)
        URLCache.shared.removeCachedResponse(for: req)
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = . reloadIgnoringLocalAndRemoteCacheData
        
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.httpMethod = HTTPMethod.get.rawValue
        req.allHTTPHeaderFields = urlObject.headerParams
        
        URLCache.shared.removeAllCachedResponses()

        let request = Alamofire.request(req)
        
        request.responseData { response in

            switch response.result {
            case .success(let data) : completionBlock(data, nil)
            case .failure(let error): completionBlock(nil, error)
            }
        }
    }
    
    class func postData(fromURLObject urlObject:URLObject, completionBlock:@escaping (_ data:Data?, _ error:Error?) -> Void) {

        let request = Alamofire.request(urlObject.urlPath, method: HTTPMethod.post, parameters: urlObject.params, encoding: urlObject.encoding ?? URLEncoding.default, headers: urlObject.headerParams)
        request.responseData { response in
            
            switch response.result {
            case .success(let data) : completionBlock(data, nil)
            case .failure(let error): completionBlock(nil, error)
            }
        }
    }
    
    class func deleteData(fromURLObject urlObject:URLObject, completionBlock:@escaping (_ data:Data?, _ error:Error?) -> Void) {
       
        let request = Alamofire.request(urlObject.urlPath, method: HTTPMethod.delete, parameters: urlObject.params, encoding: urlObject.encoding ?? URLEncoding.default, headers: urlObject.headerParams)
        request.responseData { response in
            
            switch response.result {
            case .success(let data) :
                if let response = response.response {
                    if response.statusCode == 204 {
                        completionBlock(data, nil)
                    } else {
                        completionBlock(nil, NSError(100, "Something went wrong!"))
                    }
                }
            case .failure(let error):
                if let response = response.response {
                    completionBlock(nil, NSError(response.statusCode,""))
                } else {
                    completionBlock(nil, error)
                }
            }
        }
    }
    
    class func putData(fromURLObject urlObject:URLObject, completionBlock:@escaping (_ data:Data?, _ error:Error?) -> Void) {
        
        let request = Alamofire.request(urlObject.urlPath, method: HTTPMethod.put, parameters: urlObject.params, encoding: urlObject.encoding ?? URLEncoding.default, headers: urlObject.headerParams)
        request.responseData { response in
            
            switch response.result {
            case .success(let data) : completionBlock(data, nil)
            case .failure(let error): completionBlock(nil, error)
            }
        }
    }
    

    class func cancelAllRequest() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
}

public struct DictionaryEncoding: ParameterEncoding {
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    
    /// Creates a new instance of the encoding using the given options
    ///
    /// - parameter options: The options used to encode the json. Default is `[]`
    ///
    /// - returns: The new instance
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else {
            return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
    
}
