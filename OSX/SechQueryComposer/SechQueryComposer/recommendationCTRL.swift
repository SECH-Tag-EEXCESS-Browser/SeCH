//
//  recommendationCTRL.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

class RecommendationCTRL {
    func getRecommendsForKeyWords(keywordInfo : (kw:[String], mainTopicIndex:Int?), dataSource : RecommendationDataSource, update: () -> Void)
    {
        let c = Connection()
        let rec = RecommendationJSON(keywordInfo: keywordInfo)
        let url = Preferences().url + "/recommend"
        
        c.post(rec.jsonObject, url: url){ (succeeded: Bool, msg: NSData) -> () in
            if (succeeded) {
                guard let recommJson = JsonRecommendation(data: msg) else
                {
                    print ("Versagen 1")
                    return
                }
                let recomms = recommJson.recommendations
                dataSource.data = recomms!
                update()
                for i in recomms!
                {
                    print ("\(i)")
                }
            }
            else {
                print("Versagen 2")
            }
        }
        
    }

    
}

class RecommendationJSON {
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
    
    private func addMetaInfo()
    {
        let mInfos = EEXCESSMetaInfo()
        //jsonObject["ageRange"] = mInfos.ageRange
        jsonObject["gender"] = mInfos.gender
        jsonObject["numResults"] = mInfos.numResult
    }
    
    private func addKontextKeywords(keywordInfo : (kw:[String], mainTopicIndex:Int?))
    {
        var allKWS : [AnyObject] = []
        
        for i in 0 ..< keywordInfo.kw.count
        {
            var newEntry : [String : AnyObject] = [:]
            
            newEntry["text"] = keywordInfo.kw[i]
            if (keywordInfo.kw.count > 2) {
                newEntry["isMainTopic"] = (keywordInfo.mainTopicIndex! == i)
            }
            allKWS.append(newEntry)
        }
        jsonObject["contextKeywords"] = allKWS
    }
    
    init(keywordInfo : (kw:[String], mainTopicIndex:Int?))
    {
        addOrigin()
        addMetaInfo()
        addKontextKeywords(keywordInfo)
    }
}

