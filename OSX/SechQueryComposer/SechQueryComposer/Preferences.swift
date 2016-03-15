//
//  Preferences.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

class Preferences {
    private let pGate = PreferencesR()
    
    var isFemale : Bool {
        get {
            return gender == 1
        }
    }
    
    var gender : Int {
        get {
            return pGate.gender
        }
        set (gIndex) {
            pGate.gender = gIndex
        }
    }
    
    var age : Int {
        get {
            return pGate.age
        }
        set (age) {
            pGate.age = age
        }
    }
    
    var url : String {
        get {
            return pGate.url
        }
        set (url) {
            pGate.url = url
        }
    }
    
    var numResults : Int {
        get {
            return pGate.numResults
        }
        set (cnt) {
            pGate.numResults = cnt
        }
    }
}