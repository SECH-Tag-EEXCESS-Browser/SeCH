//
//  EexcessRecommendationCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESSRecommendationCtrl {
    
    func extractRecommendatins(data : NSData, url:String)->[EEXCESSAllResponses]?
    {
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        
        guard let allResults = JSONData.fromObject(json!)!["results"]?.array as [JSONData]! else{
            return nil
        }
        var pRecommendations = [EEXCESSAllResponses]()
        
        
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
            
            pRecommendations.append(allResponses)
            
        }
        return pRecommendations
    }
    
    //For Interface SearchResults
    func extractRecommendatins2(data : NSData, url:String)->SearchResults?
    {
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        
        guard let allResults = JSONData.fromObject(json!)!["results"]?.array as [JSONData]! else{
            return nil
        }
        var searchResults = [SearchResult]()
        
        for (index, allResult) in allResults.enumerate()
        {
            var searchResultItems = [SearchResultItem]()

            let result = allResult.object!["result"]?.array
            
            for res in result!{
                let u = (res.object!["documentBadge"]?["uri"]?.string)!
                let p = (res.object!["documentBadge"]?["provider"]?.string)!
                let t = (res.object!["title"]?.string)!
                let l = (res.object!["language"]?.string)!
                let m = (res.object!["mediaType"]?.string)!
                
                searchResultItems.append(SearchResultItem(title: t, provider: p, uri: u, language: l, mediaType: m))
            }
            searchResults.append(SearchResult(index: index, url: url, resultItems: searchResultItems))
            
        }
        return SearchResults(searchResults: searchResults)
    }
}