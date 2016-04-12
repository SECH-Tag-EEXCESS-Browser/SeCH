//
//  SearchQuery.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 22.03.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import UIKit

class SearchQuerys {
    
    private let /*var*/ mSearchQuerys:[SearchQuery]
    
//    var searchQuerys:[SearchQuery]{
//        get{
//            return mSearchQuerys
//        }
//    }
    
    init(mSearchQuerys:[SearchQuery]){
        self.mSearchQuerys = mSearchQuerys
    }
    
    func getSearchQuerys()->[SearchQuery]{
        return self.mSearchQuerys
    }
    
    
//    init(){
//        self.mSearchQuerys = []
//    }
//    
//    func addSearchQuery(searchQuery:SearchQuery){
//        self.mSearchQuerys.append(searchQuery)
//    }
}

class SearchQuery{

    private let index:Int
    private let searchContext:[SearchContext]
    
    init(index:Int,searchContext:[SearchContext]){
        self.index = index
        self.searchContext = searchContext
    }
    
    func getSearchContext()->[SearchContext] {
        return self.searchContext
    }
}

class SearchContext{
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