//
//  ContactList.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//


import ObjectMapper

class ContactList: Mappable {
    
    var contacts:[Contact] = []

    required convenience init?(map: Map) {
        self.init()
    }
    
     func mapping(map: Map) {
        contacts <- map["array"]
    }
}
