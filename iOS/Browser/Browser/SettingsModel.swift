//
//  SettingsModel.swift
//  Browser
//
//  Created by Andreas Ziemer on 13.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class SettingsModel : NSObject, NSCoding{
    var homeURL: String
    
    //Sech-Daten
    var age: Int
    var gender: String
    var city: String
    var country: String
    var language: String

    init(homeURL:String, age:Int, gender: String, city: String, country: String, language: String){
        self.homeURL = homeURL
        self.age = age
        self.gender = gender
        self.city = city
        self.country = country
        self.language = language
    }
    
    override init(){
        self.homeURL = "http://sech-browser.de/"
        self.age = 0
        self.gender = "Geschlecht"
        self.city = "Stadt"
        self.country = "Land"
        self.language = "Sprache"
    }
    
    required init(coder aCoder:NSCoder){
        homeURL = aCoder.decodeObjectForKey("homeURL") as! String
        age = aCoder.decodeObjectForKey("age") as! Int
        gender = aCoder.decodeObjectForKey("gender") as! String
        city = aCoder.decodeObjectForKey("city") as! String
        country = aCoder.decodeObjectForKey("country") as! String
        language = aCoder.decodeObjectForKey("language") as! String
    }
    
    func encodeWithCoder(aCoder:NSCoder){
        aCoder.encodeObject(homeURL, forKey:"homeURL")
        aCoder.encodeObject(age, forKey:"age")
        aCoder.encodeObject(gender, forKey:"gender")
        aCoder.encodeObject(city, forKey:"city")
        aCoder.encodeObject(country, forKey:"country")
        aCoder.encodeObject(language, forKey:"language")
    }
}

extension SettingsModel {
    var extHome : String {
        get {
            return homeURL
        }
        set(newURL) {
            homeURL = newURL
        }
    }
    
    var extAge : Int {
        get {
            return age
        }
        set(newAge){
            age = newAge
        }
    }
    
    var extGender : String {
        get {
            return gender
        }
        set(newGender) {
            gender = newGender
        }
    }
    
    var extCity : String{
        get {
            return city
        }
        set(newCity) {
            city = newCity
        }
    }
    
    var extCountry : String {
        get {
            return country
        }
        set(newCountry){
            country = newCountry
        }
    }
    
    var extLanguage : String {
        get {
            return language
        }
        set(newLanguage) {
            language = newLanguage
        }
    }
}

class SettingsPersistency {
    private let fileName = "settings.plist"
    private let dataKey = "SettingsObj"
    
    func loadDataObject()-> SettingsModel {
        var item : SettingsModel!
        let file = dataFileForName(fileName)
        
        if(!NSFileManager.defaultManager().fileExistsAtPath(file)){
            return SettingsModel()
        }
        if let data = NSData(contentsOfFile: file){
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            item = unarchiver.decodeObjectForKey(dataKey) as! SettingsModel
            unarchiver.finishDecoding()
        }
        return item
    }
    
    func saveDataObject(items: SettingsModel){
        let file = dataFileForName(fileName)
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: dataKey)
        archiver.finishEncoding()
        data.writeToFile(file, atomically: true)
    }
    
    private func documentPath() -> String{
        let allPathes = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) 
        return allPathes[0]
    }
    
    private func tmpPath() -> String{
        return NSTemporaryDirectory()
    }
    
    private func dataFileForName(fileName:String)->String
    {
        return (documentPath() as NSString).stringByAppendingPathComponent(fileName)
    }
    
    private func tmpFileForName(fileName:String)->String
    {
        return (tmpPath() as NSString).stringByAppendingPathComponent(fileName)
    }

}


//<Settings.bundle> ----------------------------------------------------------------------------------------


class SettingsManager {
    
    func getPreferencesValues(){
        let a = NSUserDefaults.standardUserDefaults().floatForKey("slider_preference")
        print("slider_preference: \(a)")
    }
    
    static func getLanguage()->String{
        var l = NSUserDefaults.standardUserDefaults().valueForKey("language_preference") as? String
        
        if(l == nil){
            NSUserDefaults.standardUserDefaults().setObject("de", forKey: "language_preference")
            l = "de"
        }
        
        return l!
    }
}






