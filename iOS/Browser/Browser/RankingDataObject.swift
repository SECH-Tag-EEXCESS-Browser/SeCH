//
//  RankingDataObject.swift
//  Browser
//
//  Created by Burak Erol on 11.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class RankingDataObject: NSObject, NSCoding {
    private var name: String = "Ranking"       //optional
    private var numbers: [Int] = []
    
    private let nameString = "name"
    private let numbersString = "numbers"
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        doDecoding(aDecoder)
    }
    
    private func doDecoding(aDecoder: NSCoder){
        name = aDecoder.decodeObjectForKey(nameString) as! String
        numbers = aDecoder.decodeObjectForKey(numbersString) as! [Int]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: nameString)
        aCoder.encodeObject(numbers, forKey: numbersString)
    }
}


//Zugriffsschicht
extension RankingDataObject {
    var firstName: String {
        get {
            return name
        }
        set (newValue) {
            name = newValue
        }
    }
    
    var firstNumbers: [Int] {
        get {
            return numbers
        }
        set (newValue) {
            numbers = newValue
        }
    }
}
