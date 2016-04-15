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
    
    init(searchResults:[SearchResult]){
        self.mSearchResults = searchResults
    }
    
    func getSearchResults()->[SearchResult]{
        return self.mSearchResults
    }
}

class SearchResult {
    private let url:String
    private let resultItems:[SearchResultItem]
    private let index: Int
    
    init(index:Int,url:String,resultItems:[SearchResultItem])
    {
        self.url = url
        self.resultItems = resultItems
        self.index = index
    }
    
    func getIndex()->Int{
        return self.index
    }
}

class SearchResultItem {
    private let title : String
    private let provider : String
    private let uri : String?
    private let language: String
    private let mediaType: String
    private var avg:Double!
    
    private var description: String {
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

func < (left : SearchResultItem, right : SearchResultItem) -> Bool
{
    return left.avg < right.avg
}
