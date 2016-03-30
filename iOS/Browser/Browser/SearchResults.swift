//
//  SearchResult.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 22.03.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class SearchResults {
    private var mSearchResults: [SearchResult]
    
    var searchResults:[SearchResult]{
        get{
            return mSearchResults
        }
    }
    
    init(){
        mSearchResults = []
    }
    
    init(searchResults:[SearchResult]){
        self.mSearchResults = searchResults
    }
    
    func addSearchResult(searchResult: SearchResult){
        self.mSearchResults.append(searchResult)
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