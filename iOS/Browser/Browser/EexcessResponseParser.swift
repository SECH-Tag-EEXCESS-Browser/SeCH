//
//  EexcessResponseParser.swift
//  Browser
//
//  Created by Burak Erol on 12.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class EexcessResponseParser:AbstractResponseParser{
    
    let query:SearchQuery
    
    init(query:SearchQuery){
        self.query = query
    }
    
    func parse(data:NSData)->SearchResult?{
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        guard let allResults = JSONData.fromObject(json!)!["result"]?.array as [JSONData]! else{
            return SearchResult()
        }
        var title = ""
        var url = ""
        var index = 0
            var searchResultItems = [SearchResultItem]()
            var generatingQuery:String?
            for res in allResults{
                let u = (res.object!["documentBadge"]?["uri"]?.string)!
                let p = (res.object!["documentBadge"]?["provider"]?.string)!
                let t = (res.object!["title"]?.string)!
                let l = (res.object!["language"]?.string)!
                let m = (res.object!["mediaType"]?.string)!
                if generatingQuery == nil {
                    generatingQuery = (res.object!["generatingQuery"]?.string)!
                }
                title = query.getTitle()
                url = query.getUrl()
                index = query.getIndex()
                searchResultItems.append(SearchResultItem(title: t, provider: p, uri: u, language: l, mediaType: m))
            }
        return SearchResult(index: index, url: url, resultItems: searchResultItems,title: title)
     }
    
}