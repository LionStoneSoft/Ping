//
//  ContactsUserCell.swift
//  Ping
//
//  Created by Ryan Soanes on 08/03/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class ContactsUserCell: UITableViewCell {

    @IBOutlet var contactUsername: UILabel!
    @IBOutlet var contactImage: UIImageView!
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
        self.contactImage.layer.cornerRadius = 30
        self.contactImage.clipsToBounds = true
    }
    
}
