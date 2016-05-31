//
//  SearchResult.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 22.03.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class SearchResults:NSObject{
    private dynamic var mSearchResults: [SearchResult]
    
    init(searchResults:[SearchResult]){
        self.mSearchResults = [SearchResult]()
    }
    
    func getSearchResults()->[SearchResult]{
        return self.mSearchResults
    }
    
    func getSearchResultForTitle(searchModel:SEARCHModel)->SearchResult?{
        let lresult = getSearchResult(searchModel)
        if lresult == nil {
            findResults(searchModel)
        }
        return lresult
    }
    
    func getSearchResult(searchModel:SEARCHModel)->SearchResult?{
        var lresult:SearchResult?
        for result in self.mSearchResults {
            if lresult == nil && result.getTitle() == searchModel.title && result.index == searchModel.index {
                lresult = result
            }else if result.getTitle() == searchModel.title && result.index == searchModel.index {
                lresult!.resultItems += result.resultItems
            }
        }
        return lresult
    }
    
    func append(result:SearchResult){
        self.mSearchResults.append(result)
    }
    
    func appendAll(results:[SearchResult]){
        self.mSearchResults += results
    }
    
    func hasResults()->Bool {
        return !mSearchResults.isEmpty
    }
    
    func findResults(searchModel:SEARCHModel){
        let setRecommendations = ({(status:String,msg: String, result: SearchResult) -> () in
            print(msg)
            // TODO: To be redesigned! 6
            
            if(status == "FAILED"){
                return
            }

            self.mSearchResults.append(result)
            print("######### SeARCH fertig #########")
        })
            let task = TaskCtrl()
            
            // Start SearchTask -> find results for Search-tags
            task.getRecommendationsNew(searchModel, setRecommendations: setRecommendations)
    }
}

class SearchResult:NSObject {
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
    
    override init()//Only for DummyBuild
    {
        self.url = ""
        self.resultItems = []
        self.index = 0
        self.title = ""
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

func ==(lhs: SearchResult, rhs: SearchResult) -> Bool{
    return lhs.index == rhs.index && lhs.url == rhs.url
}

class SearchResultItem:NSObject {
    private let title : String
    private let provider : String
    private let uri : String?
    private let language: String
    private let mediaType: String
    private var avg:Double!
    
    internal var itemDescription: String {
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