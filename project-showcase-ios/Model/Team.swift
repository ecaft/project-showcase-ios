//
//  Team.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/29/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import Foundation
import UIKit

//Represent the data
class Team: NSObject, NSCoding {
    var teamName: String = ""
    var teamType: String = ""
    var descrip: String = ""
    var contacts: [Contact] = []
    var isFavorited: Bool = false
    
    init(teamName: String, type: String, descrip: String, contacts: [Contact]) {
        self.teamName = teamName
        self.teamType = type
        self.descrip = descrip
        self.contacts = contacts
    }
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "Name: \(teamName) | Type: \(teamType) | Description: \(descrip) | Contacts: \(contacts) | Is Favorited: \(isFavorited)"
    }
    
    // NSCoding
    required init?(coder aDecoder: NSCoder) {
        teamName = aDecoder.decodeObject(forKey: StringDict.teamName.rawValue) as? String ?? ""
        teamType = aDecoder.decodeObject(forKey: StringDict.teamType.rawValue) as? String ?? ""
        descrip = aDecoder.decodeObject(forKey: StringDict.descrip.rawValue) as? String ?? ""
        contacts = aDecoder.decodeObject(forKey: StringDict.contacts.rawValue) as? [Contact] ?? []
        isFavorited = aDecoder.decodeObject(forKey: StringDict.isFavorited.rawValue) as? Bool ?? false

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(teamName, forKey: StringDict.teamName.rawValue)
        aCoder.encode(teamType, forKey: StringDict.teamType.rawValue)
        aCoder.encode(descrip, forKey: StringDict.descrip.rawValue)
        aCoder.encode(contacts, forKey: StringDict.contacts.rawValue)
        aCoder.encode(contacts, forKey: StringDict.isFavorited.rawValue)
    }
}
