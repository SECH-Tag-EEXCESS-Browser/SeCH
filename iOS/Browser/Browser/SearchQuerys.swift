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
    // Contain [tagTyp:SearchContext] || tagTyp -> "link", "head" or "section" || SearchContext -> contain one SearchTag(SearchWord + Attributes)
    private let searchContext:[String:SearchContext]
    // url of the 
    private let url:String
    // title
    private let title:String
    
    init(index:Int,searchContext:[String:SearchContext],url:String,title:String){
        self.index = index
        self.searchContext = searchContext
        self.url = url
        self.title = title
    }
    
    func getSearchContext()->[String:SearchContext] {
        return self.searchContext
    }
    
    func getUrl()->String{
        return self.url
    }
    
    func getTitle()->String {
        return self.title
    }
    
    func getIndex()->Int{
        return self.index
    }
}
// SearchContext represent a KeyWord with attributes and filters for the searchEngine ToDO: In Wiki
class SearchContext{
    
    //values contain "type", "text"
    private let values:[String:AnyObject]
    private let filters:[String:AnyObject]
    
    init(values:[String:AnyObject],filters:[String:AnyObject]){
        self.values = values
        self.filters = filters
    }
    
    func getValues()->[String:AnyObject]{
        return self.values
    }
}
