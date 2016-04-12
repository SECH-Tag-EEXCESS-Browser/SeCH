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
    
    func addKontextKeywords(searchQuerys:SearchQuerys)->[String:AnyObject]
    {
        //print("seachData \(seachData.first?.tags)")
        var allKWS : [[[String:AnyObject]]] = []
        let lSearchModels = searchQuerys.getSearchQuerys()
        
        for searchModel in lSearchModels {
            var dic = [[String:AnyObject]]()
            for contextTag in searchModel.getSearchContext() {
                var context = [String:AnyObject]()
                context["text"] = contextTag.getValues()["text"] as! String
                context["isMainTopic"] = contextTag.getValues()["isMainTopic"] as! Bool
                context["type"] = contextTag.getValues()["type"] as! String
                dic.append(context)
                
            }
            allKWS.append(dic)
        }
        jsonObject["contextKeywords"] = allKWS
        
        return jsonObject
    }
    
    init()
    {
        addOrigin()
        //addMetaInfo()
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

