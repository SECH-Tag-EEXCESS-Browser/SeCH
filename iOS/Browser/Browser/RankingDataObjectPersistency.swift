//
//  RankingDataObjectPersistency.swift
//  Browser
//
//  Created by Burak Erol on 11.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation


class RankingDataObjectPersistency {
    private let fileName = "rankingData.plist"
    private let dataKey = "DataObject"
    
    func loadDataObject() -> RankingDataObject {
        var item : RankingDataObject!
        let file = dataFileForName(fileName)
        
        if(!NSFileManager.defaultManager().fileExistsAtPath(file)){
            return RankingDataObject()
        }
        
        if let data = NSData(contentsOfFile: file){
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            item = unarchiver.decodeObjectForKey(dataKey) as! RankingDataObject
            unarchiver.finishDecoding()
        }
        
        return item
    }
    
    
    func saveDataObject(items: RankingDataObject) {
        let file = dataFileForName(fileName)
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: dataKey)
        archiver.finishEncoding()
        data.writeToFile(file, atomically: true)
    }
    
    
    
    private func documentPath() ->String {
        let allPathes = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return allPathes[0]
    }
    
    private func tmpPath() ->String {
        return NSTemporaryDirectory()
    }
    
    private func dataFileForName(fileName: String) ->String {
        return (documentPath() as NSString).stringByAppendingPathComponent(fileName)
    }
    
    private func tmpFileForName(fileName: String) ->String {
        return (tmpPath() as NSString).stringByAppendingPathComponent(fileName)
    }
    
    
    
    
}
