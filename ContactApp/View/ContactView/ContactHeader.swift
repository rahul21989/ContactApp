//
//  ContactHeader.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit

class ContactHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var sectionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.lightGray
    }
}
