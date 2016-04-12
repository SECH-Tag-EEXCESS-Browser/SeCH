//
//  SearchResult.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 22.03.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class SearchResults {
    private let mSearchResults: [SearchResult]
    private let index: Int

    
    init(searchResults:[SearchResult], index: Int){
        self.mSearchResults = searchResults
        self.index = index
    }
    
    func getSearchResults()->[SearchResult]{
        return self.mSearchResults
    }
    
    func getIndex()->Int{
        return self.index
    }
    
}



class SearchResult {
    var title : String
    var provider : String
    var uri : String?
    var language: String
    var mediaType: String
    var avg:Double!
    
    var description: String {
        get {
            return "Title:\(title) -- Provider:\(provider) -- URI:\(uri)"
        }
    }
    init(title : String, provider : String, uri : String, language: String, mediaType: String)
    {
        self.title = title
        self.provider = provider
        self.uri = uri
        self.language = language
        self.mediaType = mediaType
        
    }
}

func < (left : SearchResult, right : SearchResult) -> Bool
    {
        return left.avg < right.avg
}
