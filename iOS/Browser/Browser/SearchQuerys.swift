//
//  SearchQuery.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 22.03.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import UIKit

class SearchQuerys {
    
    private let mSearchQuerys:[SearchQuery]
    
    private let language:String
    
    init(mSearchQuerys:[SearchQuery], language:String){
        self.mSearchQuerys = mSearchQuerys
        self.language = language
    }
    
    func getSearchQuerys()->[SearchQuery]{
        return self.mSearchQuerys
    }
    
    func getLanguage()->String {
        return self.language
    }
}

class SearchQuery{

    private let index:Int

    private let linkContext:SearchContext
    private let sectionContext:SearchContext
    private let headContext:SearchContext
    // url of the 
    private let url:String
    // title
    private let title:String
    private let language:String

    
    init(index:Int,link:SearchContext,section:SearchContext,head:SearchContext,url:String,title:String,language:String){
        self.index = index
        self.linkContext = link
        self.sectionContext = section
        self.headContext = head
        self.url = url
        self.title = title
        self.language = language
    }
    
    func getSearchContext()->[SearchContext] {
        return [getHead(),getSection(),getLink()]
    }
    
    func getLink()->SearchContext {
        return self.linkContext
    }
    
    func getSection()->SearchContext {
        return self.sectionContext
    }
    
    func getHead()->SearchContext {
        return self.headContext
    }

    func getUrl()->String{
        return self.url
    }
    
    func getTitle()->String {
        return self.title
    }
    
    func getLanguage()->String {
        return self.language
    }
    
    func getIndex()->Int{
        return self.index
    }
}
// SearchContext represent a KeyWord with attributes and filters for the searchEngine ToDO: In Wiki
class SearchContext{
    private let searchWord:String
    private let searchTyp:String
    
    private let filterMediaType:String
    private let filterProvider:String
    private let filterLicence:String
    
    init(searchWord:String,searchTyp:String,filterMediaType:String,filterProvider:String,filterLicence:String){
        self.searchWord = searchWord
        self.searchTyp = searchTyp
        self.filterLicence = filterLicence
        self.filterMediaType = filterMediaType
        self.filterProvider = filterProvider
    }
    
    func getSearchWord()->String {
        return self.searchWord
    }
    
    func getSearchTyp()->String {
        return self.searchTyp
    }
    
    func getFilterMediaType()->String {
        return self.filterMediaType
    }
    
    func getFilterProvider()->String {
        return self.filterProvider
    }
    
    func getFilterLicence()->String {
        return self.filterLicence
    }
}
