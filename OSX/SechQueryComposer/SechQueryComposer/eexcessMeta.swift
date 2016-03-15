//
//  eexcessMeta.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

class EEXCESSMetaInfo {
    private let prefs = Preferences()
    
    var ageRange : Int {
        get {
            let theAge = prefs.age
            let eexcessAge : Int
       
            switch theAge {
            case 0 ... 7:
                eexcessAge = 0
            case 8 ... 19:
                eexcessAge = 1
            default :
                eexcessAge = 2
            }
        return eexcessAge
        }
    }
    
    var gender : String {
        get {
            if (prefs.isFemale) {
                return "female"
            }
            else {
                return "male"
            }
        }
    }
    
    var numResult : Int {
        get {
            return prefs.numResults
        }
    }
}