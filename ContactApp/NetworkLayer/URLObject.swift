//
//  URLObject.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import Alamofire

enum RequestType {
    case get, post, delete, put
}

class URLObject {
    
    var url:URL?
    var requestType:RequestType = .get
    var urlPath:String
    var shouldReturnRawData = false
    var encoding:ParameterEncoding?
    var isResponseInArray = false
    var infoDictionary = [String:Any]()
    var params:Parameters?
    var headerParams:[String : String]?
    var data:Data?

    
    init(urlPath:String) {
        self.urlPath = urlPath
    }
    
    func checkSanity() -> NSError? {
        guard let urlEncodedString = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), !urlPath.isEmpty else {
            return NSError(400, "No Path has been provided.")
        }
        urlPath = urlEncodedString
        self.url = URL(string: urlPath)
        if url == nil {
            return NSError(400, "Bad URL")
        }
        
        return nil
    }
}
