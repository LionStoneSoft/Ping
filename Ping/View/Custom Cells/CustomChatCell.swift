//
//  CustomChatCell.swift
//  Ping
//
//  Created by Ryan Soanes on 14/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class CustomChatCell: UITableViewCell {

    @IBOutlet var chatImage: UIImageView!
    @IBOutlet var chatUsername: UILabel!
    @IBOutlet var chatLastMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func roundedImage() {
        self.chatImage.layer.cornerRadius = 30
        self.chatImage.clipsToBounds = true
    }
    
}
