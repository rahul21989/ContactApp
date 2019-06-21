//
//  DataManager.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit
import ObjectMapper

class DataManager {
    
    class func getData<T>(fromURLObject urlObject:URLObject, ofType type: T.Type, completionBlock:@escaping (_ data:T?, _ infoDictionary:[String:Any]?, _ error:Error?) -> Void) where T : Mappable {
        urlObject.requestType = .get
        guard UIApplication.shared.applicationState != .background else {
            print("Data fetch failed for : \(urlObject.urlPath)")
            completionBlock(nil, urlObject.infoDictionary, NSError.AppInBackground)
            return
        }
        if let error = urlObject.checkSanity() {
            completionBlock(nil, nil, error)
        } else {
            APIManager.getData(fromURLObject: urlObject) { (data, error) in
                if let response = data {
                    var parsableJson:[String : Any]?
                    let jsonObject = try? JSONSerialization.jsonObject(with: response, options: .mutableContainers)
                    if let jsonDict = jsonObject as? [String : Any] {
                        parsableJson = jsonDict
                    } else if let jsonArray = jsonObject as? [Any] {
                        if urlObject.isResponseInArray {
                            parsableJson = jsonArray.first as? [String : Any]
                        } else {
                            parsableJson = ["array": jsonArray]
                        }
                    }
                    if let finalData = parsableJson {
                        let model = T(JSON: finalData)
                        completionBlock(model, nil, nil)
                    }
                        
                    else {
                        completionBlock(nil, urlObject.infoDictionary, NSError.NoResponseFromServer)
                    }
                } else {
                    completionBlock(nil, urlObject.infoDictionary, NSError.NoResponseFromServer)
                }
            }
        }
    }
    
    
    class func postData<T>(fromURLObject urlObject:URLObject, ofType type: T.Type, completionBlock:@escaping (_ data:T?, _ infoDictionary:[String:Any]?, _ error:Error?) -> Void) where T : Mappable {
        urlObject.requestType = .post
        guard UIApplication.shared.applicationState != .background else {
            print("Data fetch failed for : \(urlObject.urlPath)")
            completionBlock(nil, urlObject.infoDictionary, NSError.AppInBackground)
            return
        }
        if let error = urlObject.checkSanity() {
            completionBlock(nil, nil, error)
        } else  {
            
            APIManager.postData(fromURLObject: urlObject) { (data, error) in
                if let response = data {
                    var parsableJson:[String : Any]?
                    let jsonObject = try? JSONSerialization.jsonObject(with: response, options: .mutableContainers)
                    if let jsonDict = jsonObject as? [String : Any] {
                        parsableJson = jsonDict
                    } else if let jsonArray = jsonObject as? [Any] {
                        if urlObject.isResponseInArray {
                            parsableJson = jsonArray.first as? [String : Any]
                        } else {
                            parsableJson = ["array": jsonArray]
                        }
                    }
                    if let finalData = parsableJson {
                        let model = T(JSON: finalData)
                        completionBlock(model, nil, nil)
                    }
                        
                    else {
                        completionBlock(nil, urlObject.infoDictionary, NSError.NoResponseFromServer)
                    }
                } else  {
                    completionBlock(nil, urlObject.infoDictionary, NSError.NoResponseFromServer)
                }
            }
        }
    }
    
    
    class func putData<T>(fromURLObject urlObject:URLObject, ofType type: T.Type, completionBlock:@escaping (_ data:T?, _ infoDictionary:[String:Any]?, _ error:Error?) -> Void) where T : Mappable {
        urlObject.requestType = .put
        guard UIApplication.shared.applicationState != .background else {
            print("Data fetch failed for : \(urlObject.urlPath)")
            completionBlock(nil, urlObject.infoDictionary, NSError.AppInBackground)
            return
        }
        if let error = urlObject.checkSanity() {
            completionBlock(nil, nil, error)
        } else  {
            
            APIManager.putData(fromURLObject: urlObject) { (data, error) in
                if let response = data {
                    var parsableJson:[String : Any]?
                    let jsonObject = try? JSONSerialization.jsonObject(with: response, options: .mutableContainers)
                    if let jsonDict = jsonObject as? [String : Any] {
                        parsableJson = jsonDict
                    } else if let jsonArray = jsonObject as? [Any] {
                        if urlObject.isResponseInArray {
                            parsableJson = jsonArray.first as? [String : Any]
                        } else {
                            parsableJson = ["array": jsonArray]
                        }
                    }
                    if let finalData = parsableJson {
                        let model = T(JSON: finalData)
                        completionBlock(model, nil, nil)
                    }
                        
                    else {
                        completionBlock(nil, urlObject.infoDictionary, NSError.NoResponseFromServer)
                    }
                } else  {
                    completionBlock(nil, urlObject.infoDictionary, NSError.NoResponseFromServer)
                }
            }
        }
    }
    
    class func deleteData (fromURLObject urlObject:URLObject, completionBlock:@escaping (_ data:[String : Any]?, _ infoDictionary:[String:Any]?, _ error:Error?) -> Void){
        urlObject.requestType = .delete
        guard UIApplication.shared.applicationState != .background else {
            print("Data fetch failed for : \(urlObject.urlPath)")
            completionBlock(nil, urlObject.infoDictionary, NSError.AppInBackground)
            return
        }
        if let error = urlObject.checkSanity() {
            completionBlock(nil, nil, error)
        } else {
            APIManager.deleteData(fromURLObject: urlObject) { (data, error) in
                if let response = data {
                    var parsableJson:[String : Any]?
                    let jsonObject = try? JSONSerialization.jsonObject(with: response, options: .mutableContainers)
                    if let jsonDict = jsonObject as? [String : Any] {
                        parsableJson = jsonDict
                        completionBlock(parsableJson, nil, nil)

                    } else if let jsonArray = jsonObject as? [Any] {
                        if urlObject.isResponseInArray {
                            parsableJson = jsonArray.first as? [String : Any]
                        } else {
                            parsableJson = ["array": jsonArray]
                        }
                    }
                    completionBlock(parsableJson, nil, nil)

                } else {
                    completionBlock(nil, urlObject.infoDictionary, NSError.NoResponseFromServer)
                }
            }
        }
    }
}


extension NSError {
    
    convenience init(_ errorCode:Int, _ errorSting:String) {
        self.init(domain: Bundle.main.bundleIdentifier ?? "com.contact.ContactApp", code: errorCode, userInfo: [NSLocalizedDescriptionKey : errorSting])
    }
    
    static let NoResponseFromServer = NSError(400, "No response from Server.")
    static let InternalClassMissing = NSError(400, "Please provide and internal class for data to be mapped.")
    static let AppInBackground = NSError(-1040, "Application in background.")
    
    fileprivate func localized() -> NSError {
        var localizedError = ""
        switch code {
        case -999, -1001, -1003, -1011, -1012, -1020:
            localizedError = "Looks like we have encountered a problem. Please try again."
        case -1005, -1009:
            localizedError = "Seems you are offline. Please check your network connection."
        case -1018:
            localizedError = "Looks like you are Roaming. Please check your network connection."
        case 500:
            localizedError = "Internal Server Error."
        case 400:
            localizedError = "No response from Server."
        default:
            break
        }
        
        return localizedError.isEmpty ? self : NSError(code, localizedError)
    }
}

