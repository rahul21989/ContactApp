//
//  ViewController.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var orderedContacts = [String: [Contact]]() //Contacts ordered in dicitonary alphabetically
    var sortedContactKeys = [String]()
    var filteredContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Contact"
        view.backgroundColor = UIColor(red: 245.0, green: 245.0, blue: 245.0, alpha: 1.0)
        
        tableView.register(UINib(nibName: "ContactHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ContactHeader")
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    func fetchContactData() {
        ContactManager.getContactData() { (contactList, info, error) in
            if let contactList = contactList {
                self.filteredContacts = contactList
                for contact in contactList {
                    var key: String = "#"
                    //If ordering has to be happening via frist name change it here.
                    if let firstLetter = contact.first_name [0..<1], firstLetter.containsAlphabets() {
                        key = firstLetter.uppercased()
                    }
                    var tempContacts = [Contact]()
                    
                    if let segregatedContact = self.orderedContacts[key] {
                        tempContacts = segregatedContact
                    }
                    tempContacts.append(contact)
                    self.orderedContacts[key] = tempContacts
                }
                
                self.sortedContactKeys = Array(self.orderedContacts.keys).sorted(by: <)
                if self.sortedContactKeys.first == "#" {
                    self.sortedContactKeys.removeFirst()
                    self.sortedContactKeys.append("#")
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContactData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let nextButton = UIBarButtonItem(title: "add", style: .done, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = nextButton
    }
    
    
    @objc func addTapped() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numSection:Int
        numSection = sortedContactKeys.count
        return numSection
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedContactKeys
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount:Int = 0
        if let contactsForSection = orderedContacts[sortedContactKeys[section]] {
            rowsCount = contactsForSection.count
        }
        return rowsCount
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactCell
        let contact: Contact
        let indexPth = indexPath
        guard let contactsForSection = orderedContacts[sortedContactKeys[(indexPth as NSIndexPath).section]] else {
            return UITableViewCell()
        }
        
        contact = contactsForSection[(indexPth as NSIndexPath).row]
        cell.updateUI(contact, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let changeSection = section
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContactHeader") as! ContactHeader
        headerView.sectionTitle.text = sortedContactKeys[changeSection]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        let detailVC = ContactDetailVC(nibName: "ContactDetailVC", bundle: nil)
        detailVC.contact = cell.contact!
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    subscript(r: Range<Int>) -> String? {
        get {
            let stringCount = self.count as Int
            if (stringCount < r.upperBound) || (stringCount < r.lowerBound) {
                return nil
            }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[(startIndex ..< endIndex)])
        }
    }
    
    func containsAlphabets() -> Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains( where: {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        })
    }
}


