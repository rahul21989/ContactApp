//
//  ContactCell.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var contactTextLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactContainerView: UIView!
    @IBOutlet weak var favoriteImageView: UIView!
    
    var contact: Contact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contactContainerView.layer.masksToBounds = true
        contactContainerView.layer.cornerRadius = contactContainerView.frame.size.width/2
        contactContainerView.layer.borderWidth = 2.0
        contactContainerView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(_ contact: Contact, indexPath: IndexPath) {
        self.contact = contact
        self.contactTextLabel?.text = contact.first_name
        self.favoriteImageView.isHidden = !contact.favorite
        let defaultURL = baseURL + contact.profile_pic
        contactImageView?.setImageWithURL(defaultURL, withCompletionBlock: {(_ imageURL: String, _ error: Error?) -> Void in
            self.contactImageView.contentMode = .scaleAspectFill
        })
    }
}
