//
//  MessageView.swift
//  Ping
//
//  Created by Ryan Soanes on 15/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class MessageView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var messageTextInput: UITextField!
    @IBOutlet var messageNameLabel: UILabel!
    @IBOutlet var messageTableView: UITableView!
    var databaseHandle: DatabaseHandle!
    var databaseRefer: DatabaseReference!
    let messages = ["Hello", "This is a test", "This message is to test the resizing abilities of the cell in the UI Table View", "Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test"] //declared array for test data
    var userName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messageTableView.delegate = self //sets self as delegate for table view
        messageTableView.dataSource = self //sets self as data source for table view
        messageTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell") //register xib file to chat table view
        configureTableView()
        hideKeyboardWhenTappedAround()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell //initiate custom cell for chat table view
        cell.messageFromUserText.text = messages[indexPath.row] //alter chatUsername element with test data for username
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns number of cells wanted on tableview
        return messages.count
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension //adjust the height of the cell to content
        messageTableView.estimatedRowHeight = 35.0
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessageButton(_ sender: UIButton) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["text": messageTextInput.text!, "username": userName]
        childRef.updateChildValues(values as [AnyHashable : Any])
        print(messageTextInput.text!)
    }
}

