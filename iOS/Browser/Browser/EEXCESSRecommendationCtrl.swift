//
//  EexcessRecommendationCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EEXCESSRecommendationCtrl {

    func extractRecommendatins(data : NSData, searchQuerys:SearchQuerys?)->SearchResults?
    {
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        guard let allResults = JSONData.fromObject(json!)!["results"]?.array as [JSONData]! else{
            return nil
        }
        var searchResults = [SearchResult]()
        var title = ""
        var url = ""
        var index = 0
        for allResult in allResults
        {
            var searchResultItems = [SearchResultItem]()
            let result = allResult.object!["result"]?.array
            var generatingQuery:String?
            for res in result!{
                let u = (res.object!["documentBadge"]?["uri"]?.string)!
                let p = (res.object!["documentBadge"]?["provider"]?.string)!
                let t = (res.object!["title"]?.string)!
                let l = (res.object!["language"]?.string)!
                let m = (res.object!["mediaType"]?.string)!
                if generatingQuery == nil {
                    generatingQuery = (res.object!["generatingQuery"]?.string)!
                }
                //Sucht nach title und url in dem er die generatingQuery mit den Suchwörtern aus SearchQuerys vergleicht
                for searchQuery in (searchQuerys?.getSearchQuerys())! {
                    var isCorrectQuery = true
//                    for (tagTyp,context) in searchQuery.getSearchContext(){
//                        if !((generatingQuery?.contains(context.getValues()["text"] as! String)) != nil) {
//                            isCorrectQuery = false
//                        }
//                    }
                    if isCorrectQuery {
                        title = searchQuery.getTitle()
                        url = searchQuery.getUrl()
                        index = searchQuery.getIndex()
                    }
                }
                searchResultItems.append(SearchResultItem(title: t, provider: p, uri: u, language: l, mediaType: m))
            }
            searchResults.append(SearchResult(index: index, url: url, resultItems: searchResultItems,title: title))
        }
        return SearchResults(searchResults: searchResults)
    }
}