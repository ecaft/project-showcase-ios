//
//  TeamTableViewCell.swift
//  project-showcase-ios
//
//  Created by Sungmin Kim on 4/18/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit

protocol AddRemoveDelegate {
    func unstar(team: Team)
    func star(team: Team)
}

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableLabel: UILabel!
    
    var teamForThisCell: Team!
    var delegate: AddRemoveDelegate?
    static let identifier = "TeamTableViewCell"
    
    var name: String? {
        didSet {
            nameLabel.text = name //Sets text of name label to cell's name property
        }
    }
    
    var table: String? {
        didSet {
            tableLabel.text = "Table \(table ?? "0")"
        }
    }
    
    var img: UIImage? {
        didSet {
            starButton.setImage(img, for: .normal)
        }
    }
    
    @IBAction func starPressed(_ sender: UIButton) {
        if teamForThisCell.isFavorited {
            teamForThisCell.isFavorited = false
            starButton.setImage(#imageLiteral(resourceName: "starUnfilled"), for: .normal)
            delegate?.unstar(team: teamForThisCell)
            
        } else {
            teamForThisCell.isFavorited = true
            starButton.setImage(#imageLiteral(resourceName: "starFilled"), for: .normal)
            delegate?.star(team: teamForThisCell)
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
