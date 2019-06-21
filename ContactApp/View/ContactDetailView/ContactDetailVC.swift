//
//  ContactDetailVC.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!


    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
        
        tableView.register(UINib(nibName: "ContactDelete", bundle: nil), forHeaderFooterViewReuseIdentifier: "ContactDelete")
        
        tableView.register(UINib(nibName: "ContactDetailCell", bundle: nil), forCellReuseIdentifier: "ContactDetailCell")
        
        tableView.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        setUpContactDetailData()
    }
    
    func setUpContactDetailData()  {
        contactImageView.layer.masksToBounds = true
        contactImageView.layer.cornerRadius = contactImageView.frame.size.width/2
        contactImageView.layer.borderWidth = 2.0
        contactImageView.layer.borderColor = UIColor.white.cgColor
        
        if let contact = contact {
            contactName?.text = contact.first_name
            let defaultURL = "http://gojek-contacts-app.herokuapp.com" + contact.profile_pic
            contactImageView?.setImageWithURL(defaultURL, withCompletionBlock: {(_ imageURL: String, _ error: Error?) -> Void in
                self.contactImageView.contentMode = .scaleAspectFill
            })
            
            self.messageButton.isUserInteractionEnabled = contact.phone_number.isEmpty
            self.callButton.isUserInteractionEnabled = contact.phone_number.isEmpty
            self.emailButton.isUserInteractionEnabled = contact.email.isEmpty
            self.favoriteButton.isUserInteractionEnabled = true
            
            self.favoriteButton.setImage(UIImage(named: "favourite_button"), for: .normal)
            self.favoriteButton.setImage(UIImage(named: "favourite_button"), for: .highlighted)
            
            if contact.favorite {
                self.favoriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal)
                self.favoriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .highlighted)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell") as! ContactDetailCell
        
        if let contact = contact {
            if indexPath.row == 0 {
                cell.updateDetailUI(contact, type: .mob)
            } else if indexPath.row == 1 {
                cell.updateDetailUI(contact, type: .email)
            }
        }
        
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContactDelete") as? ContactDelete {
            headerView.contact = contact
            headerView.controller = self
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    
    @objc func editButtonTapped() {
        let editVC = ContactEditVC(nibName: "ContactEditVC", bundle: nil)
        editVC.contact = contact
        self.present(editVC,animated: true, completion: nil)
    }
    
    
    @IBAction public func didTapMessageIcon() {
        if let mobile = self.contact?.phone_number, MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.recipients = [mobile]
            composeVC.messageComposeDelegate = self
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapCallIcon() {
        if let mobile = self.contact?.phone_number, let url = URL(string: "tel://\(mobile)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func didTapEmailIcon() {
        if let email = self.contact?.email, MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            self.present(mail, animated: true)
        }
    }
    
    @IBAction func didTapFavoriteIcon() {
        DispatchQueue.main.async {
            if self.contact?.favorite ?? false {
                self.favoriteButton.setImage(UIImage(named: "favourite_button"), for: .normal)
                self.favoriteButton.setImage(UIImage(named: "favourite_button"), for: .highlighted)
            } else {
                self.favoriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal)
                self.favoriteButton.setImage(UIImage(named: "favourite_button_selected"), for: .highlighted)
            }
            
            self.contact?.favorite = !(self.contact?.favorite ?? false)
        }
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

