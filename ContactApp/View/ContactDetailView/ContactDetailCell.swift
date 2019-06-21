//
//  ContactCell.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit

class ContactDetailCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contactTextLabel: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    var contact: Contact?
    var type:fieldType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        addDoneButtonOnKeyboard()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateDetailUI(_ contact: Contact, type: fieldType) {
        self.contact = contact
        self.type = type
        if type == .name {
            titleLabel.text = "First Name"
            contactTextLabel.text = self.contact?.first_name
            contactTextLabel.keyboardType = .namePhonePad
        } else if type == .lastName{
            titleLabel.text = "Last Name"
            contactTextLabel.text = self.contact?.last_name
            contactTextLabel.keyboardType = .namePhonePad
        } else if type == .mob {
            titleLabel.text = "mobile"
            contactTextLabel.text = self.contact?.phone_number
            contactTextLabel.keyboardType = .phonePad
        } else if type == .email {
            titleLabel.text = "email"
            contactTextLabel.text = self.contact?.email
            contactTextLabel.keyboardType = .emailAddress
        }
        self.hideCancelButton(hide: true)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        contactTextLabel?.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        endEditing(true)
    }
    
    @IBAction func didTapCancelButton() {
        self.contactTextLabel.text = ""
    }
    
    func hideCancelButton(hide: Bool) {
        self.cancelButton.isHidden = hide
    }
    
    // MARK: UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideCancelButton(hide: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideCancelButton(hide: true)
        if type == .name {
            self.contact?.first_name = textField.text ?? ""
        } else if type == .lastName{
            self.contact?.last_name = textField.text ?? ""
        } else if type == .mob {
            self.contact?.phone_number = textField.text ?? ""
        } else if type == .email {
            self.contact?.email = textField.text ?? ""
        }
    }
}
