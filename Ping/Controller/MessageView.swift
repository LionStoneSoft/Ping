//
//  MessageView.swift
//  Ping
//
//  Created by Ryan Soanes on 15/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase
import AES256CBC
import IQKeyboardManagerSwift
import ReverseExtension

class MessageView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var messageTextInput: UITextField!
    @IBOutlet var messageNameLabel: UILabel!
    @IBOutlet var messageTableView: UITableView!
    var messages = [MessageData]() //declared array to hold messages
    var username: String!
    var currentUser: UserStored?
    var currentName: String?
    var recipientName: String?
    let password = "1htftu856PGrD46H1F3gz5fG400GZz64"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.re.delegate = self //sets self as delegate for table view
        messageTableView.re.dataSource = self //sets self as data source for table view
        messageTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell") //register xib file to chat table view
        messageTableView.register(UINib(nibName: "CustomMessageCell2", bundle: nil), forCellReuseIdentifier: "customMessageCell2")
        configureTableView()
        hideKeyboardWhenTappedAround()
        messageNameLabel.text = currentUser?.username
        refreshMessages()
        setupNames()
        removeMessagesRefresh()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].recipient == currentUser?.uid {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "customMessageCell2", for: indexPath) as! CustomMessageCell2
            //cell.cellBackView.backgroundColor = UIColor.gray
            cell2.messageFromUserText.text = messages[indexPath.row].text
            return cell2
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell //initiate custom cell for chat table view
            cell.messageFromUserText.text = messages[indexPath.row].text //alter chatUsername element with test data for username
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns number of cells wanted on tableview
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let uid = Auth.auth().currentUser!.uid
        if editingStyle == .delete {
            if messages[indexPath.row].sender == uid {
                let ref = Database.database().reference().child("messages").child(messages[indexPath.row].messageID!)
                ref.removeValue()
                messages.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("deleted")
            } else {
                print("You can't delete this")
            }
                //tableView.deleteRows(at: [indexPath], with: .automatic)
            //print(messages[indexPath.row].text)
            
        }
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension //adjust the height of the cell to content
        messageTableView.estimatedRowHeight = 85.0
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessageButton(_ sender: UIButton) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId() //adds a child node to ref with a unique id for each message
        let timestamp = NSNumber(value: NSDate().timeIntervalSince1970)
        let text = messageTextInput?.text
        let values = ["messageID": childRef.key, "senderName": currentName, "receiverName": recipientName, "text": AES256CBC.encryptString(text ?? "", password: password), "recipient": currentUser?.uid, "sender": Auth.auth().currentUser?.uid, "timestamp": timestamp] as [String : Any]
        if text == "" {
            print("Message was blank")
        } else {
            childRef.updateChildValues(values as [AnyHashable : Any])
        }
        print(messageTextInput.text!)
        messageTextInput.text = ""
    }
    
    func refreshMessages() {
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = MessageData(dictionary: dictionary)
                if message.recipient == self.currentUser?.uid && message.sender == uid || message.recipient == uid && message.sender == self.currentUser?.uid {
                    message.setValuesForKeys(dictionary)
                    message.text = AES256CBC.decryptString(message.text!, password: self.password)
                    self.messages.append(message)
                }

                DispatchQueue.main.async(execute: {
                    self.messageTableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    func removeMessagesRefresh() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messages.removeAll()
            self.refreshMessages()
        }, withCancel: nil)
    }
    
    
    
    func setupNames() {
        let uid = Auth.auth().currentUser!.uid
        Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            self.currentName = snapshot.value as? String
        }, withCancel: nil)
        
        Database.database().reference().child("users").child(currentUser!.uid).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            self.recipientName = snapshot.value as? String
        }, withCancel: nil)
    }
    
}

