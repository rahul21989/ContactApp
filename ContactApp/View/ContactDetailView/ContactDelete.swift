//
//  ContactDelete.swift
//  ContactApp
//
//  Created by Rahul Goyal on 20/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit

class ContactDelete: UITableViewHeaderFooterView {
    var contact: Contact?
    var controller: ContactDetailVC?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.white
    }
    
    @IBAction func deleteButtonTapped() {
        if let contact = contact{
            let urlObject = URLObject.init(urlPath: String(format: deleteContact, contact.id))
            DataManager.deleteData(fromURLObject: urlObject) { (verifyResponse, info, error) in
                if error == nil {
                    self.controller?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
