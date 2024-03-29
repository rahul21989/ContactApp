//
//  ContactDetailVC.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit
import MessageUI

enum fieldType : Int {
    case name, lastName, mob, email
}

enum viewMode : Int {
    case add, edit
}


class ContactAddEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    var contact: Contact?
    var mode: viewMode = .add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = tableHeaderView
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        tableView.register(UINib(nibName: "ContactDetailCell", bundle: nil), forCellReuseIdentifier: "ContactDetailCell")
        setUpContactImage()
    }
    
    func setUpContactImage() {
        contactImageView.layer.masksToBounds = true
        contactImageView.layer.cornerRadius = contactImageView.frame.size.width/2
        contactImageView.layer.borderWidth = 2.0
        contactImageView.layer.borderColor = UIColor.white.cgColor
        
        if let contact = contact {
            let defaultURL = baseURL + contact.profile_pic
            contactImageView?.setImageWithURL(defaultURL, withCompletionBlock: {(_ imageURL: String, _ error: Error?) -> Void in
                self.contactImageView.contentMode = .scaleAspectFill
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell") as! ContactDetailCell

        if let contact = contact {
            if indexPath.row == 0 {
                cell.updateDetailUI(contact, type: .name)
            } else if indexPath.row == 1 {
                cell.updateDetailUI(contact, type: .lastName)
            } else if indexPath.row == 2 {
                cell.updateDetailUI(contact, type: .mob)
            } else if indexPath.row == 3 {
                cell.updateDetailUI(contact, type: .email)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    

    @objc func doneButtonTapped(){
        let firstName = (self.tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ContactDetailCell).contactTextLabel.text ?? ""
        
        let lastName = (self.tableView(self.tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as! ContactDetailCell).contactTextLabel.text ?? ""
        
        let mobile = (self.tableView(self.tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as! ContactDetailCell).contactTextLabel.text ?? ""
        
        let email = (self.tableView(self.tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as! ContactDetailCell).contactTextLabel.text ?? ""
        
        if !firstName.isEmpty && !lastName.isEmpty && !mobile.isEmpty && !email.isEmpty {
            
            if let contact = contact {
                if mode == .edit {
                    ContactManager.updateContactData(contactId: contact.id, firstName: firstName, lastName: lastName, email: email, mobile: mobile, favorite: contact.favorite) { (contact, info, error) in
                        if (error == nil) {
                            self.contact = contact
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                else {
                    contact.first_name = firstName
                    contact.last_name = lastName
                    contact.email = email
                    contact.phone_number = mobile
                    contact.favorite = true
                    ContactManager.addContactData(contact: contact) { (contact, info, error) in
                        if (error == nil) {
                            self.contact = contact
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func updateImage(_ sender: Any) {
        ImagePicker.showActionSheet(self, { (image, error) in
            if error == nil, let selectedImage = image {
                self.contactImageView.image = selectedImage
            }
        })
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: false, completion:nil)
    }
}

