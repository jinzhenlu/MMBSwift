//
//  PersonalTableViewCell.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/28.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

class PersonalTableViewCell: UITableViewCell {

    @IBOutlet weak var imgV_icon: UIImageView!
    @IBOutlet weak var lab_Name: UILabel!
    @IBOutlet weak var labContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
