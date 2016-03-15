//
//  JsonRecommendation.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

class JsonRecommendation {
    private var pRecommendations : [EEXCESSRecommendation]?
    
    var recommendations : [EEXCESSRecommendation]? {
        get {
            return pRecommendations
        }
    }
    
    init? (data : NSData)
    {
        let jsonT = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
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
        guard let allResults = jsonData["result"]?.array as [JSONData]! else
        {
            return
        }
        
        pRecommendations = []
        for i in allResults
        {
            let u = (i["documentBadge"]?["uri"]?.string)!
            let p = (i["documentBadge"]?["provider"]?.string)!
            let t = (i["title"]?.string!)!

            let newRecommendation = EEXCESSRecommendation(title: t, provider: p, uri: u)
            pRecommendations?.append(newRecommendation)
        }
    }
}