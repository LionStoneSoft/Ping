//
//  CustomMessageCell2.swift
//  Ping
//
//  Created by Ryan Soanes on 15/04/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class CustomMessageCell2: UITableViewCell {

    @IBOutlet var messageFromUserText: UILabel!
    @IBOutlet var messageColourView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedMessage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func roundedMessage() {
        messageColourView.layer.cornerRadius = 10
    }
    
}
