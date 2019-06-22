//
//  ContactAppTests.swift
//  ContactAppTests
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import XCTest
@testable import ContactApp

class ContactAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDownloadContacts() {
        ContactManager.getContactData() { (contactList, info, error) in
            if error != nil {
                XCTFail("errored: \(String(describing: error))")
            }
            if contactList != nil {
                XCTAssertTrue(true)
            }
        }
    }
    
    func testAddContact() {
        ContactManager.addContactData(contact:mockContact()) { (contact, info, error) in
            if error != nil {
                XCTFail("errored: \(String(describing: error))")
            }
            if contact != nil {
                XCTAssertTrue(true)
            }
        }
    }
    
    func testUpdateContact() {
        ContactManager.getContactData() { (contactList, info, error) in
            if error != nil {
                XCTFail("errored: \(String(describing: error))")
            }
            if contactList != nil {
                if let contact = contactList?.first {
                    ContactManager.updateContactData(contactId: contact.id, firstName: "firstName", lastName: "lastName", email: "email", mobile: "mobile", favorite: true) { (contact, info, error) in
                        if error != nil {
                            XCTFail("errored: \(String(describing: error))")
                        }
                        if contact != nil {
                            XCTAssertTrue(true)
                        }
                    }
                }
            }
        }
    }
    
    func testDeleteContact() {
        ContactManager.getContactData() { (contactList, info, error) in
            if error != nil {
                XCTFail("errored: \(String(describing: error))")
            }
            if contactList != nil {
                if let contact = contactList?.first {
                    ContactManager.deleteContactData(contactId: contact.id) { (response, info, error) in
                        if error != nil {
                            XCTFail("errored: \(String(describing: error))")
                        } else {
                            XCTAssertTrue(true)
                        }
                    }
                }
            }
        }
    }
    
    func mockContact() -> Contact {
        let contact = Contact()
        contact.first_name  = "Rahul"
        contact.last_name   = "Goyal"
        contact.email  = "rahul2.1989@gmail.com"
        contact.phone_number  = "+627383330003"
        contact.favorite = true
        return contact
    }
}
