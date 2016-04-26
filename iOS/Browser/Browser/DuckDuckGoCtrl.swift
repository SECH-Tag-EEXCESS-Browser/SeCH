//
//  DuckDuckGoCtrl.swift
//  Browser
//
//  Created by Andreas Ziemer on 19.04.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class DuckDuckGoCtrl:URLConnectionCtrl{
    
    func extractSearch(searchQuerys:SearchQuerys)->SearchResults?{

        var topic: String = ""
        let basicUrl = "http://api.duckduckgo.com/?q=\(topic)&format=json&pretty=1&t=sechbrowser"
        
        var searchResults: [SearchResult] = []
        let searchQueryArr: [SearchQuery] = searchQuerys.getSearchQuerys()
        
        for query in searchQueryArr{
            let searchContexts: [String:SearchContext] = query.getSearchContext()
            
            for searchContext in searchContexts{
                let searchContextValues: [String: AnyObject] = searchContext.1.getValues()
                topic += searchContextValues["text"] as! String
                topic += "+"
            }
            
            let request = NSMutableURLRequest(URL: NSURL(string: basicUrl)!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            self.post((searchQuerys, NSData()), request: request, postCompleted: { (succeeded, data, querys) -> () in
                
                searchResults.append(self.extractQuery(data, index: query.getIndex(), url: query.getUrl(), title: query.getTitle())!)
            })
            
            
            topic = ""
            
        }
        return SearchResults(searchResults: searchResults)
    }
    
    
    func extractQuery(data: NSData, index: Int, url: String, title: String)->SearchResult?{
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        let relatedTopics = JSONData.fromObject(json!)!["RelatedTopics"]?.array as [JSONData]!
        let results = JSONData.fromObject(json!)!["Results"]?.array as [JSONData]!
        var searchResultItems = [SearchResultItem]()
        
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
        
        return SearchResult(index: index, url: url, resultItems: searchResultItems, title: title)
    }
}