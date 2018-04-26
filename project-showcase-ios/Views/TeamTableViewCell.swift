//
//  TeamTableViewCell.swift
//  project-showcase-ios
//
//  Created by Sungmin Kim on 4/18/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    static let identifier = "TeamTableViewCell"
    
    var name: String? {
        didSet {
            nameLabel.text = name //Sets text of name label to cell's name property
        }
    }
    
    var department: String? {
        didSet {
            departmentLabel.text = "Department: " + department!
        }
    }
    
    var img: UIImage? {
        didSet {
            starImage.image = img
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
