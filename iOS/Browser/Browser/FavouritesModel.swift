//
//  FavouritesModel.swift
//  Browser
//
//  Created by Patrick Büttner on 31.10.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class FavouritesModel : NSObject, NSCoding
{
    var title: String
    var url : String
    
    init(title:String, url:String)
    {
        self.title = title
        self.url = url
    }
    
    
    override init()
    {
        self.title = ""
        self.url = ""
    }
    
    required init(coder aCoder:NSCoder)
    {
        title = aCoder.decodeObjectForKey("title") as! String
        url = aCoder.decodeObjectForKey("url") as! String
    }
    
    func encodeWithCoder(aCoder:NSCoder)
    {
        aCoder.encodeObject(title, forKey:"title")
        aCoder.encodeObject(url, forKey:"url")
    }
}

//Zugriffsschicht
extension FavouritesModel
{
    var extTitle : String
    {
        get
        {
            return title
        }
            
        set(newValue)
        {
            title = newValue
        }
        
    }
    
    var extUrl : String
    {
        get
        {
            return url
        }
        
        set(newValue)
        {
            url = newValue
        }
    }
}
    
//Persistency Manager
class DataObjectPersistency
{
    private let fileName = "data.plist"
    private let dataKey = "DataObject"
    
    func loadDataObject()->[FavouritesModel]
    {
        var items : [FavouritesModel] = []
        let file = dataFileForName(fileName)
        
        if(!NSFileManager.defaultManager().fileExistsAtPath(file))
        {
            return items
        }
        
        if let data = NSData(contentsOfFile: file)
        {
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            items = unarchiver.decodeObjectForKey(dataKey) as! [FavouritesModel]
            unarchiver.finishDecoding()
        }
        
        return items
    }
    
    func saveDataObject(items: [FavouritesModel])
    {
        let file = dataFileForName(fileName)
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: dataKey)
        archiver.finishEncoding()
        data.writeToFile(file, atomically: true)
    }
}

private func documentPath()->String
{
    let allPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) 
    return allPaths[0]
}

private func tmpPath()->String
{
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



