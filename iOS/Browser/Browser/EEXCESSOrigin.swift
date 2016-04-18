//
//  EEXCESSOrigin.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

struct EEXCESSOrigin {
    let clientType = "Advance OSX Query"
    let clientVersion = "0.42"
    let module = "SECH-Client"
    var userID : String {
        get {
            //return NSUserName()
            return "iOS-SeCH-Browser"
        }
    }
}