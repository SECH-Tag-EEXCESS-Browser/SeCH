//
//  EEXCESSRecommendationJSON.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESSRecommendationJSONCtrl {
    var jsonObject : [String : AnyObject] = [:]
    
    private func addOrigin ()
    {
        let eInfos = EEXCESSOrigin()
        var originInfo : [String : AnyObject] = [:]
        
        originInfo["clientType"] = eInfos.clientType
        originInfo["clientVersion"] = eInfos.clientVersion
        originInfo["userID"] = eInfos.userID
        originInfo["module"] = eInfos.module
        
        jsonObject["origin"] = originInfo
    }
    
//    private func addMetaInfo()
//    {
//        let mInfos = EEXCESSMetaInfo()
//        //jsonObject["ageRange"] = mInfos.ageRange
//        jsonObject["gender"] = mInfos.gender
//        jsonObject["numResults"] = mInfos.numResult
//    }
    
    private func addKontextKeywords(searchModels:SEARCHModels)
    {
        //print("seachData \(seachData.first?.tags)")
        var allKWS : [AnyObject] = []
        let lSearchModels = searchModels.getSearchModels()
        
        for i in 0 ..< lSearchModels.count
        {
            var newEntry : [[String : AnyObject]] = [[:], [:], [:]]
            
            
            newEntry[0]["text"] = lSearchModels[i].tags["link"]?.topic
            newEntry[0]["isMainTopic"] = lSearchModels[i].tags["link"]?.isMainTopic
            newEntry[0]["type"] = createCorrectTypeString((lSearchModels[i].tags["link"]?.type)!)
            
            newEntry[1]["text"] = lSearchModels[i].tags["section"]?.topic
            newEntry[1]["isMainTopic"] = lSearchModels[i].tags["section"]?.isMainTopic
            newEntry[1]["type"] = createCorrectTypeString((lSearchModels[i].tags["section"]?.type)!)
            
            newEntry[2]["text"] = lSearchModels[i].tags["head"]?.topic
            newEntry[2]["isMainTopic"] = lSearchModels[i].tags["head"]?.isMainTopic
            newEntry[2]["type"] = createCorrectTypeString((lSearchModels[i].tags["head"]?.type)!)

            allKWS.append(newEntry)
        }
        jsonObject["contextKeywords"] = allKWS
    }
    
    init(lSearchModels:SEARCHModels)
    {
        addOrigin()
        //addMetaInfo()
        addKontextKeywords(lSearchModels)
    }
    
    private func createCorrectTypeString(type : String) -> String
    {
        let lower = type.lowercaseString
        switch lower {
            case "misc":
                return "Misc"
            case "persom":
                return "Person"
            case "location":
                return "Location"
        default:
            return "Organization"
        }
    }
}

