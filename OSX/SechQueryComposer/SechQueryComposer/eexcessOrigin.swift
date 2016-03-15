//
//  eexcessOrigin.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

struct EEXCESSOrigin {
    let clientType = "Advance OSX Query"
    let clientVersion = "0.42"
    let module = "SECH-Client"
    var userID : String {
        get {
            return NSUserName()
        }
    }
}