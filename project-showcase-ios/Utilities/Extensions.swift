//
//  Extensions.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/19/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    public static let ecaftRed = UIColor(red: 179/255, green: 27/255, blue: 27/255, alpha: 1.0)
    public static let backgroundGray = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
    public static let ecaftGray = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.9)
    public static let ecaftDarkGray = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
    public static let ecaftWhite = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)

    public static func colorFromCode(code: Int) -> UIColor {
        let red = CGFloat((code & 0xFF0000) >> 16) / 255
        let green = CGFloat((code & 0xFF00) >> 8) / 255
        let blue = CGFloat(code & 0xFF) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
