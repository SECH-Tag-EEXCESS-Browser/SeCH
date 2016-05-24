//
//  FarooResponseParser.swift
//  Browser
//
//  Created by Burak Erol on 12.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class FarooResponseParser:AbstractResponseParser{
    
    let query:SearchQuery
    
    init(query:SearchQuery){
        self.query = query
    }
    
    func parse(data:NSData)->SearchResult?{

        let provider = "Faroo"
        var searchResultItems: [SearchResultItem] = []
        
        
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        
        print("Faroo json" + String(data: data, encoding: NSUTF8StringEncoding)!)
        
        guard let allResults = JSONData.fromObject(json!)!["results"]?.array as [JSONData]! else{
            return nil
        }
        
        if(allResults.count == 0){
            return nil
        }
        
        for(index, allResult) in allResults.enumerate(){
            let title2 = allResult.object!["title"]?.string
            let url = allResult.object!["url"]?.string
            let author = allResult.object!["author"]?.string
            
            searchResultItems.append(SearchResultItem(title: title2!, provider: provider, uri: url!, language: query.getLanguage(), mediaType: MediaTypes.unknown.simpleDescription()))
            
        }
        
        return SearchResult(index: query.getIndex(), url: query.getUrl(), resultItems: searchResultItems, title: query.getTitle())


    }
    
  }