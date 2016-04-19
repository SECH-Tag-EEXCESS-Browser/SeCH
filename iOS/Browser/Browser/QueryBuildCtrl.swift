//
//  QueryBuildCtrl.swift
//  Browser
//
//  Created by Burak Erol on 12.04.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class QueryBuildCtrl {
    
    func buildQuery(searchModels:SEARCHModels)->SearchQuerys {
        var searchQuery = [SearchQuery]()
        for searchModel in searchModels.getSearchModels() {
            var searchContexts = [SearchContext]()
            
            for (key,value) in searchModel.tags {
                var dic = value.getValues()
                dic["tag"] = key

                if (dic["type"]! as! String) == "" {
                    dic["type"] = "Misc"
                }else{
//                    let str = dic["type"] as! String
//                    dic["type"] = str.substringToIndex(str.startIndex.advancedBy(1)).uppercaseString + str.substringFromIndex(str.startIndex.advancedBy(1))
                }
                searchContexts.append(SearchContext(values: dic, filters: searchModel.filters.getValues()))
            
            }
            searchQuery.append(SearchQuery(index: searchModel.index, searchContext: searchContexts,url: searchModel.url,title: searchModel.title))
        }
        return SearchQuerys(mSearchQuerys: searchQuery)
    }
}