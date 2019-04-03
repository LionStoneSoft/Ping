//
//  MessageData.swift
//  Ping
//
//  Created by Ryan Soanes on 02/04/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class MessageData: NSObject {

    @objc var senderName: String?
    @objc var recipient: String?
    @objc var sender: String?
    @objc var text: String?
    @objc var timestamp: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.senderName = dictionary["senderName"] as? String
        self.recipient = dictionary["recipient"] as? String
        self.sender = dictionary["sender"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
}
