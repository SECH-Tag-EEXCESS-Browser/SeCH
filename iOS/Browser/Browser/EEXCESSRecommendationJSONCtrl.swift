//
//  EEXCESSRecommendationJSON.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESSRecommendationJSONCtrl {
    
    private func addOrigin (var json:[String : AnyObject])->[String:AnyObject]
    {
        let eInfos = EEXCESSOrigin()
        var originInfo : [String : AnyObject] = [:]
        
        originInfo["clientType"] = eInfos.clientType
        originInfo["clientVersion"] = eInfos.clientVersion
        originInfo["userID"] = eInfos.userID
        originInfo["module"] = eInfos.module
        
        json["origin"] = originInfo
        
        return json
    }
    
//    private func addMetaInfo()
//    {
//        let mInfos = EEXCESSMetaInfo()
//        //jsonObject["ageRange"] = mInfos.ageRange
//        jsonObject["gender"] = mInfos.gender
//        jsonObject["numResults"] = mInfos.numResult
//    }
    
    func addKontextKeywords(searchQuerys:SearchQuerys)->(SearchQuerys,AnyObject)
    {
        // create the jsonRequestObject and add the origin
        var jsonObject = addOrigin([String:AnyObject]())
        
        var allKWS : [[[String:AnyObject]]] = []
        let lSearchModels = searchQuerys.getSearchQuerys()
        for searchModel in lSearchModels {
            var dic = [[String:AnyObject]]()
            for contextTag in searchModel.getSearchContext() {
                var context = [String:AnyObject]()
                context["text"] = contextTag.1.getValues()["text"] as! String
                context["isMainTopic"] = contextTag.0 == "link"
                //contextTag.getValues()["isMainTopic"] as! Bool
                if context["type"] == nil {
                    context["type"] = "Misc"
                }
                if context["type"] as! String == "" {
                    context["type"] = "Misc"
                }
                let str = context["type"] as! String
                context["type"] = str.substringToIndex(str.startIndex.advancedBy(1)).uppercaseString + str.substringFromIndex(str.startIndex.advancedBy(1))
                dic.append(context)
            }
            allKWS.append(dic)
        }
        jsonObject["contextKeywords"] = allKWS
        // Schneller Hack um Anzahl der möglichen Suchergebnisse zu erhöhen
        jsonObject["numResults"] = 50 * searchQuerys.getSearchQuerys().count
        jsonObject["loggingLevel"] = 1

        return (searchQuerys,jsonObject as AnyObject)
    }
}