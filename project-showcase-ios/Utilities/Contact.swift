//
//  Contact.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/29/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import Foundation
import UIKit

//Represent the data
class Contact: NSObject, NSCoding {
    var name: String = ""
    var major: String = ""
    var gradYear: String = ""
    var email: String = ""
    var teamName: String = ""
    var teamType: String = ""
    var title: String = ""
    
    init(name: String, major: String, gradYear: String, email: String, teamName: String, teamType: String, title: String) {
        self.name = name
        self.major = major
        self.gradYear = gradYear
        self.email = email
        self.teamName = teamName
        self.teamType = teamType
        self.title = title
    }
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "Name: \(name) | Major: \(major) | Graduation Year: \(gradYear) | Email: \(email) | Team: \(teamName) (\(teamType)) | \(title)"
    }
    
    // NSCoding
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: StringDict.contactName.rawValue) as? String ?? ""
        major = aDecoder.decodeObject(forKey: StringDict.major.rawValue) as? String ?? ""
        gradYear = aDecoder.decodeObject(forKey: StringDict.gradYear.rawValue) as? String ?? ""
        email = aDecoder.decodeObject(forKey: StringDict.email.rawValue) as? String ?? ""
        teamName = aDecoder.decodeObject(forKey: StringDict.teamName.rawValue) as? String ?? ""
        teamType = aDecoder.decodeObject(forKey: StringDict.teamType.rawValue) as? String ?? ""
        title = aDecoder.decodeObject(forKey: StringDict.title.rawValue) as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: StringDict.contactName.rawValue)
        aCoder.encode(major, forKey: StringDict.major.rawValue)
        aCoder.encode(gradYear, forKey: StringDict.gradYear.rawValue)
        aCoder.encode(email, forKey: StringDict.email.rawValue)
        aCoder.encode(teamName, forKey: StringDict.teamName.rawValue)
        aCoder.encode(teamType, forKey: StringDict.teamType.rawValue)
        aCoder.encode(title, forKey: StringDict.title.rawValue)
    }
}
