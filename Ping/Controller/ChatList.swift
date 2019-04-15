//
//  ChatList.swift
//  Ping
//
//  Created by Ryan Soanes on 11/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class ChatList: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerBDelegate {
    
    @IBOutlet var settingsButtonPicture: UIButton!
    @IBOutlet var chatsTableView: UITableView!
    @IBOutlet var topNameLabel: UILabel!
    var currentUser: UserStored?
    var userList = [UserStored]()
    var messages = [MessageData]() //declared array to hold messages objects
    var messagesDictionary = [String: MessageData]() //contains messages parsed into string data
    var nameArray = [String]()
    var users = [UserStored]()
    var currentName: String?
    var recipientName: String?
    var allUsers = [UserStored]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatsTableView.delegate = self //sets self as delegate for table view
        chatsTableView.dataSource = self //sets self as data source for table view
        chatsTableView.register(UINib(nibName: "CustomChatCell", bundle: nil), forCellReuseIdentifier: "customChatCell") //register xib file to chat table view
        retrieveUsername()
        retrieveChats()
        retrieveUserAvatar()
        usersName()
        retrieveAllUsers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //before segue, sets currentUser with current user snapshot
        if segue.identifier == "toMessages" {
            let secondView = segue.destination as! MessageView
            secondView.currentUser = currentUser
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customChatCell", for: indexPath) as! CustomChatCell //initiate custom cell for chat table view
        cell.chatUsername.text = nameArray[indexPath.row] //alter chatUsername element with test data for username
        cell.chatLastMessage.text = ""
        for user in allUsers {
            if user.username == cell.chatUsername.text {
                cell.chatImage.loadImageUsingCacheWithUrlString(user.profileImageURL)
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns number of cells wanted on tableview
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //when the specific row is selected, segues to the message view
        let selectedName = nameArray[indexPath.row]
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: AnyObject] {
                let user = UserStored()
                user.setValuesForKeys(userDictionary)
                self.users.append(user)
                if user.username == selectedName {
                    self.currentUser = user
                    self.segueToMessages()
                }
                
            }
        }, withCancel: nil)
        
    }
    
    @IBAction func addConvo(_ sender: UIButton) { //Upon button press, creates a contacts view, sets self as contacts delegate and presents contacts view.
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let contacts = sb.instantiateViewController(withIdentifier: "Contacts View") as! ContactsView
        contacts.delegate = self
        self.present(contacts, animated: true, completion: nil)
    }
    
    func getDataBack(selectedUser: UserStored) { //used to retrieve data from the contacts view
        currentUser = selectedUser
    }
    
    func retrieveUsername() { //retrieves the username of the currently logged in user and displays in the top bar
        let uid = Auth.auth().currentUser!.uid
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        databaseReference.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.value as? [String: AnyObject] {
                self.topNameLabel.text = name["username"] as? String
            }
        }
    }
    
    func retrieveChats() { //groups the messages by their recipients and displays them in the UITableView
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = MessageData(dictionary: dictionary)
                if message.receiverName == self.currentName || message.senderName == self.currentName {
                    if let recipient = message.recipient {
                        self.messagesDictionary[recipient] = message
                        self.messages = Array(self.messagesDictionary.values)
                        if message.receiverName != self.currentName {
                            self.nameArray.append(message.receiverName!)
                        } else {
                            self.nameArray.append(message.senderName!)
                        }
                    }
                }
                self.nameArray.removeDuplicates()

                DispatchQueue.main.async(execute: {
                    self.chatsTableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    func segueToMessages() { //when called, segues to the message view
        self.performSegue(withIdentifier: "toMessages", sender: self)
    }
    
    func retrieveUserAvatar() { //creates a snapshot of the logged in users profileImageURL, downloads the image and sets the buttons image
        let uid = Auth.auth().currentUser!.uid
        Database.database().reference().child("users").child(uid).child("profileImageURL").observeSingleEvent(of: .value, with: { (snapshot) in
            let profileURL = snapshot.value as! String
            let storageRef = Storage.storage().reference(forURL: profileURL)
            storageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                let pic = UIImage(data: data!)
                self.settingsButtonPicture.setImage(pic, for: .normal)
            })
            
        }, withCancel: nil)
    }
    
    func usersName() {
        let uid = Auth.auth().currentUser!.uid
        Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            self.currentName = snapshot.value as? String
        }, withCancel: nil)
    }
    
    func retrieveAllUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: AnyObject] {
                let user = UserStored()
                user.setValuesForKeys(userDictionary)
                self.allUsers.append(user)
                
            }
        }, withCancel: nil)
    }
    
//    func retrieveUser() {
//        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
//            if let userDictionary = snapshot.value as? [String: AnyObject] {
//                let user = UserStored()
//                user.setValuesForKeys(userDictionary)
//                //print(user.username, user.email)
//                self.users.append(user)
//                DispatchQueue.main.async {
//                    self.retrieveContactsTable.reloadData()
//                }
//            }
//        }, withCancel: nil)
//    }
    
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
