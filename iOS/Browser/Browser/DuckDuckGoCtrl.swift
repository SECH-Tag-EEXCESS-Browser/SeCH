//
//  DuckDuckGoCtrl.swift
//  Browser
//
//  Created by Andreas Ziemer on 19.04.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation


class DuckDuckGoCtrl{
    
    func extractSearch(data : NSData, searchQuerys:SearchQuerys?)->SearchResults?{
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        let relatedTopics = JSONData.fromObject(json!)!["RelatedTopics"]?.array as [JSONData]!
        let results = JSONData.fromObject(json!)!["Results"]?.array as [JSONData]!
        var searchResults = [SearchResult]()
        var searchResultItems = [SearchResultItem]()
        
        let title = ""
        let url = ""
        let index = 0

        //Abstract
        let uri = (JSONData.fromObject(json!)!["AbstractURL"]?.string)! as String
        let provider = (JSONData.fromObject(json!)!["AbstractSource"]?.string)! as String
        let topic = (JSONData.fromObject(json!)!["Heading"]?.string)! as String
        let language = (JSONData.fromObject(json!)!["meta"]?["src_options"]?["language"]?.string)! as String
        let mediaType = "unknown"
        searchResultItems.append(SearchResultItem(title: topic, provider: provider, uri: uri, language: language, mediaType: mediaType))
        
        //Official site
        for result in results{
            let u = (result.object!["FirstURL"]?.string)!
            let p = "duckduckgo"
            let t = (result.object!["Text"]?.string)!
            let l = language
            let m = "unknown"
            searchResultItems.append(SearchResultItem(title: t, provider: p, uri: u, language: l, mediaType: m))
        }
        
        
        //RelatedTopics
        for topic in relatedTopics{
            let u = (topic.object!["FirstURL"]?.string)!
            let p = "duckduckgo"
            let t = (topic.object!["Text"]?.string)!
            let l = language
            let m = "unknown"
            
            searchResultItems.append(SearchResultItem(title: t, provider: p, uri: u, language: l, mediaType: m))
        }
        searchResults.append(SearchResult(index: index, url: url, resultItems: searchResultItems,title: title))
        return SearchResults(searchResults: searchResults)
    }
}