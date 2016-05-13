//
//  EexcessJSONBuilder.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESS_JSONBuilder:AbstractJSONBuilder{
    
    init(){
    }
    
    func getURL()->String{
        //let QUERY_URL: String = "https://eexcess-dev.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend"
        let QUERY_URL: String = "https://eexcess.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend"
        return QUERY_URL
    }

    
    func getHTTPMethod()->String{
        return "POST"
    }
    
    func getContentType()->String{
        return "application/json"
    }
    
    func getAcceptType()->String{
        return "application/json"
    }
    
    func getJSON(searchQuery:SearchQuery)-> [String:AnyObject]{
        var json = generateJSON(searchQuery)
        print(json)
        
        return json
    }
    
    func getParser(query:SearchQuery)->AbstractResponseParser{
        return EexcessResponseParser(query: query)
    }
    
    private func createJSONAndAddOrigin()->[String:AnyObject]
    {
        var json = [String:AnyObject]()
        
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
    
    func generateJSON(searchQuery:SearchQuery)->[String:AnyObject]
    {
        var jsonObject = createJSONAndAddOrigin()
        // create the jsonRequestObject and add the origin
        var allKWS : [[String:AnyObject]] = [[String:AnyObject]]()
        var context = [String:AnyObject]()
        for contextTag in searchQuery.getSearchContext() {
            context["text"] = contextTag.getSearchWord()
            context["isMainTopic"] = contextTag.getSearchTyp() == "link"
            if context["type"] == nil {
                context["type"] = "Misc"
            }
            if context["type"] as! String == "" {
                context["type"] = "Misc"
            }
            let str = context["type"] as! String
            context["type"] = str.substringToIndex(str.startIndex.advancedBy(1)).uppercaseString + str.substringFromIndex(str.startIndex.advancedBy(1))
         }
        allKWS.append(context)
        jsonObject["contextKeywords"] = allKWS
        // Schneller Hack um Anzahl der möglichen Suchergebnisse zu erhöhen
        jsonObject["numResults"] = 50 * 1
        jsonObject["loggingLevel"] = 1
        
        return jsonObject
    }
}