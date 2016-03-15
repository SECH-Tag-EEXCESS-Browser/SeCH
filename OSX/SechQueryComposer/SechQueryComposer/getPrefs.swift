//
//  getPrefs.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

class PreferencesR {
    let NR_ID = "numResults"
    let GENDER_ID = "gender"
    let AGE_ID = "age"
    let URL_ID = "url"
    
    let defaults = NSUserDefaults.standardUserDefaults()

    var numResults : Int {
        get {
            let v = defaults.integerForKey(NR_ID)
            if (v < 10) {
                return 10
            }
            return v
        }
        set (gIndex) {
            defaults.setInteger(gIndex, forKey: NR_ID)
        }
    }

    var gender : Int {
        get {
            return defaults.integerForKey(GENDER_ID)
        }
        set (gIndex) {
            defaults.setInteger(gIndex, forKey: GENDER_ID)
        }
    }
    
    var age : Int {
        get {
            return defaults.integerForKey(AGE_ID)
        }
        set (age) {
            defaults.setInteger(age, forKey: AGE_ID)
        }
    }
    
    var url : String {
        get {
            let v = defaults.valueForKey(URL_ID)
            if (v == nil) {
                return "https://eexcess-dev.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer"
            }
            return v as! String
        }
        set (url) {
            var cUrl = url
            if (cUrl[cUrl.endIndex.predecessor()] == "/") {
                cUrl.removeAtIndex(cUrl.endIndex.predecessor())
            }
            
            defaults.setValue(cUrl, forKey: URL_ID)
        }
        
    }
}