//
//  Contact.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import ObjectMapper

class Contact: Mappable {
    @objc dynamic var id:Int  = 0
    @objc dynamic var first_name = ""
    @objc dynamic var last_name = ""
    @objc dynamic var email = ""
    @objc dynamic var phone_number = ""
    @objc dynamic var profile_pic = ""
    @objc dynamic var favorite = false
    @objc dynamic var created_at = ""
    @objc dynamic var updated_at = ""

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        phone_number <- map["phone_number"]
        profile_pic <- map["profile_pic"]
        favorite <- map["favorite"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}
