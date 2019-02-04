//
//  Team.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/29/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import Foundation
import UIKit

enum Major: String {
    case be = "biological engineering"
    case bme = "biomedical engineering"
    case cheme = "chemical engineering"
    case ce = "civil engineering"
    case cs = "computer science"
    case ece = "electrical and computer engineering"
    case phy = "physics"
    case enve = "environmental engineering"
    case isst = "information science systems and technology"
    case mse = "materials science and engineering"
    case me = "mechanical engineering"
    case ore = "operations research and engineering"
    case ses = "science of earth systems"
    case bs = "biological sciences"
    case gd = "game design"
    case math = "mathematics"
    case bio = "biology"
    case chem = "chemistry"
    case ss = "statistical science"
    case infosci = "information science"
    case astro = "astronomy"
}

//Represent the data
class Team: NSObject, NSCoding {
    var teamName: String = ""
    var teamType: String = ""
    var table: String = "" //short decrip to be displayed in list
    var descrip: String = ""
    var contacts: [Contact] = []
    var isFavorited: Bool = false
    var majors: [String] = []
    
    init(teamName: String, type: String, table: String, descrip: String, contacts: [Contact], majors: [String]) {
        self.teamName = teamName
        self.teamType = type
        self.table = table
        self.descrip = descrip
        self.contacts = contacts
        self.majors = majors
    }
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "Name: \(teamName) | Type: \(teamType) | Table: \(table) | Description: \(descrip) | Contacts: \(contacts) | Is Favorited: \(isFavorited)"
    }
    
    // NSCoding
    required init?(coder aDecoder: NSCoder) {
        teamName = aDecoder.decodeObject(forKey: StringDict.teamName.rawValue) as? String ?? ""
        teamType = aDecoder.decodeObject(forKey: StringDict.teamType.rawValue) as? String ?? ""
        table = aDecoder.decodeObject(forKey: StringDict.table.rawValue) as? String ?? ""
        descrip = aDecoder.decodeObject(forKey: StringDict.descrip.rawValue) as? String ?? ""
        contacts = aDecoder.decodeObject(forKey: StringDict.contacts.rawValue) as? [Contact] ?? []
        isFavorited = aDecoder.decodeObject(forKey: StringDict.isFavorited.rawValue) as? Bool ?? false
        majors = aDecoder.decodeObject(forKey: StringDict.majors.rawValue) as? [String] ?? []
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(teamName, forKey: StringDict.teamName.rawValue)
        aCoder.encode(teamType, forKey: StringDict.teamType.rawValue)
        aCoder.encode(table, forKey: StringDict.table.rawValue)
        aCoder.encode(descrip, forKey: StringDict.descrip.rawValue)
        aCoder.encode(contacts, forKey: StringDict.contacts.rawValue)
        aCoder.encode(isFavorited, forKey: StringDict.isFavorited.rawValue)
        aCoder.encode(majors, forKey: StringDict.majors.rawValue)
    }
}
