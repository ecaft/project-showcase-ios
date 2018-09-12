//
//  TeamDetailTableViewCell.swift
//  project-showcase-ios
//
//  Created by Sungmin Kim on 5/5/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit

class ContactInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactMajorYear: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
