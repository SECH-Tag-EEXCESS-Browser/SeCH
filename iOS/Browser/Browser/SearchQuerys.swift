//
//  SearchQuery.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 22.03.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import UIKit

class SearchQuerys {
    
    private let searchQuerys:[SearchQuery]
    
    init(searchQuerys:[SearchQuery]){
        self.searchQuerys = searchQuerys
    }
    //Create Array of SearchQuery
}

class SearchQuery{

    private let id:String
    private let searchContext:[SearchContext]
    
    init(id:String,searchContext:[SearchContext]){
        self.id = id
        self.searchContext = searchContext
    }
}

class SearchContext{
    private let values:[String:AnyObject]
    private let filters:[String:AnyObject]
    
    init(values:[String:AnyObject],filters:[String:AnyObject]){
        self.values = values
        self.filters = filters
    }
}