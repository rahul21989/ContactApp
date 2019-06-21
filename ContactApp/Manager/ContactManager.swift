//
//  ContactManager.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit

class ContactManager {
    class func getContactData(_ completionBlock: @escaping (_ contactData: [Contact]?, _ infoDictionary:[String:Any]?, _ error:Error?) -> Void) {
        let urlObject = URLObject(urlPath: downloadContacts)
        DataManager.getData(fromURLObject: urlObject, ofType: ContactList.self) { (contactData, info, error) in
            if let contactData = contactData {
                completionBlock(contactData.contacts, info, error)
            }
            completionBlock(nil, info, error)
        }
    }
}
