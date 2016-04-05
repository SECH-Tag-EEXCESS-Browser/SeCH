//
//  EexcessRecommendationCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESSRecommendationCtrl {
    private var pRecommendations : [EEXCESSAllResponses]?
    
    var recommendations : [EEXCESSAllResponses]? {
        get {
            return pRecommendations
        }
    }
    
    init? (data : NSData)
    {
        let jsonT = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        
        //print(jsonT)
        
        guard let json = jsonT else {

            return nil
        }
        extractRecommendatins(json)
    }
    
    private func extractRecommendatins(json : AnyObject)
    {
        guard let jsonData = JSONData.fromObject(json) else
        {
            return
        }
        guard let allResults = jsonData["results"]?.array as [JSONData]! else
        {

            return
        }
        
        pRecommendations = []
        
        
        for (index, allResult) in allResults.enumerate()
        {
            
            let allResponses = EEXCESSAllResponses()
            allResponses.index = index
            
            let result = allResult.object!["result"]?.array
            
            for res in result!{
                
                let u = (res.object!["documentBadge"]?["uri"]?.string)!
                let p = (res.object!["documentBadge"]?["provider"]?.string)!
                let t = (res.object!["title"]?.string)!
                let l = (res.object!["language"]?.string)!
                let m = (res.object!["mediaType"]?.string)!
                
                let newRecommendation = EEXCESSSingleResponse(title: t, provider: p, uri: u, language: l, mediaType: m)
                allResponses.appendSingleResponse(newRecommendation)
            }
            
            pRecommendations?.append(allResponses)
            
        }
        
    }
}