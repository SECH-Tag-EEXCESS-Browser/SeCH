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
    private var resultItems:[SearchResultItem]
    private let index: Int
    private let title:String
    
    init(index:Int,url:String,resultItems:[SearchResultItem], title:String)
    {
        self.url = url
        self.resultItems = resultItems
        self.index = index
        self.title = title
    }
    
    func getIndex()->Int{
        return self.index
    }
    
    func getResultItems()->[SearchResultItem]{
        return self.resultItems
    }
    
    func setResultItems(resultItems:[SearchResultItem]){
        self.resultItems = resultItems
    }
    
    func getTitle()->String {
        return self.title
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
    
    func getUri()->String{
        return self.uri!
    }
    
    func getTitle()->String{
        return self.title
    }
    
    func getAvg()->Double{
        return self.avg
    }
    
    func setAvg(avg: Double){
        self.avg = avg
    }
    
    func getProvider()->String{
        return self.provider
    }
    
    func getMediaType()->String{
        return self.mediaType
    }
    
    func getLanguage()->String{
        return self.language
    }
}

func < (left : SearchResultItem, right : SearchResultItem) -> Bool
{
    return left.avg < right.avg
}
