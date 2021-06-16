//
//  ProfileTableViewCell.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 27.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var requisiteTitleLabel: UILabel!
    
    @IBOutlet weak var requisiteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
