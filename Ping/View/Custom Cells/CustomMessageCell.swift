//
//  CustomMessageCell.swift
//  Ping
//
//  Created by Ryan Soanes on 15/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {

    @IBOutlet var cellBackView: UIView!
    @IBOutlet var messageFromUserText: UILabel!
    
    
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
        cellBackView.layer.cornerRadius = 10
    }
    
}
