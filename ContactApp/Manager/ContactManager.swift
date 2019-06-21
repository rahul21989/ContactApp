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
    
    class func addContactData(contact:Contact, _ completionBlock: @escaping (_ contact: Contact?, _ infoDictionary:[String:Any]?, _ error:Error?) -> Void) {
        
        let urlObject = URLObject(urlPath: addContact)
        urlObject.headerParams = ["Content-Type" : "application/json", "Accept" : "application/json"]
        urlObject.params = ["first_name": contact.first_name, "last_name": contact.last_name, "email": contact.email, "phone_number":contact.phone_number, "favorite":contact.favorite]
        urlObject.encoding = DictionaryEncoding()
        DataManager.postData(fromURLObject: urlObject, ofType: Contact.self) { (contact, info, error) in
            if (error == nil) {
                completionBlock(contact, info, error)
            }
        }
    }
    
    class func updateContactData(contactId:Int, firstName:String, lastName:String, email:String, mobile:String, favorite:Bool, _ completionBlock: @escaping (_ contact: Contact?, _ infoDictionary:[String:Any]?, _ error:Error?) -> Void) {
        
        let urlString = String(format: updateContact, contactId)
        let urlObject = URLObject(urlPath: urlString)
        urlObject.headerParams = ["Content-Type" : "application/json", "Accept" : "application/json"]
        urlObject.params = ["first_name": firstName, "last_name": lastName, "email": email, "phone_number":mobile, "favorite":favorite]
        urlObject.encoding = DictionaryEncoding()
        DataManager.putData(fromURLObject: urlObject, ofType: Contact.self) { (contact, info, error) in
            if (error == nil) {
                completionBlock(contact, info, error)
            }
        }
    }
    
    class func deleteContactData(contactId:Int, _ completionBlock: @escaping (_ response: [String : Any]?, _ infoDictionary:[String:Any]?, _ error:Error?) -> Void) {
        let urlString = String(format: deleteContact, contactId)
        let urlObject = URLObject(urlPath: urlString)
        DataManager.deleteData(fromURLObject: urlObject) { (response, info, error) in
            if (error == nil) {
                completionBlock(response, info, nil)
            }
        }
    }
}
