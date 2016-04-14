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
    
    func addKontextKeywords(searchQuerys:SearchQuerys)->(String,AnyObject)
    {
        //print("seachData \(seachData.first?.tags)")
        var allKWS : [[[String:AnyObject]]] = []
        let lSearchModels = searchQuerys.getSearchQuerys()
        var url:String?
        for searchModel in lSearchModels {
            var dic = [[String:AnyObject]]()
            for contextTag in searchModel.getSearchContext() {
                var context = [String:AnyObject]()
                context["text"] = contextTag.getValues()["text"] as! String
                context["isMainTopic"] = contextTag.getValues()["tag"] as! String == "link"
                //contextTag.getValues()["isMainTopic"] as! Bool
                let str = contextTag.getValues()["type"] as! String
                context["type"] = str.substringToIndex(str.startIndex.advancedBy(1)).uppercaseString + str.substringFromIndex(str.startIndex.advancedBy(1))
                dic.append(context)
                
            }
            allKWS.append(dic)
            if url == nil {
                url = searchModel.getUrl()
            }
        }
        jsonObject["contextKeywords"] = allKWS
        
        return (url!,jsonObject as AnyObject)
    }
    
    init()
    {
        addOrigin()
        //addMetaInfo()
    }
}

