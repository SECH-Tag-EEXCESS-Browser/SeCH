//
//  QueryBuildCtrl.swift
//  Browser
//
//  Created by Burak Erol on 12.04.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation
/**
This Controller build a general Queryformat
 
 with SEARCHModels (and Settings)

*/
class QueryBuildCtrl {
    /**
        searchModels -> SearchModels of the

        return The general QueryFormat
    */
    func buildQuery(searchModels:SEARCHModels)->SearchQuerys {
        var searchQuery = [SearchQuery]()
        for searchModel in searchModels.getSearchModels() {
            var searchContexts = [String:SearchContext]()
            for (tagTyp,tag) in searchModel.tags {
                
                searchContexts[tagTyp] = (SearchContext(searchWord: tag.topic, searchTyp: tag.type, filterMediaType: searchModel.filters.mediaType, filterProvider: searchModel.filters.provider, filterLicence: searchModel.filters.licence))
            }
            searchQuery.append(SearchQuery(index: searchModel.index,link: searchContexts["link"]!,section:searchContexts["section"]!,head:searchContexts["head"]! ,url: searchModel.url,title: searchModel.title))
        }
        return SearchQuerys(mSearchQuerys: searchQuery,language: SettingsManager.getLanguage())
    }
    
    /**


    */
    func buildQuery(searchModel:SEARCHModel)->SearchQuery {
            var searchContexts = [String:SearchContext]()
            for (tagTyp,tag) in searchModel.tags {
                
                searchContexts[tagTyp] = (SearchContext(searchWord: tag.topic, searchTyp: tag.type, filterMediaType: searchModel.filters.mediaType, filterProvider: searchModel.filters.provider, filterLicence: searchModel.filters.licence))
            }
            return SearchQuery(index: searchModel.index,link: searchContexts["link"]!,section:searchContexts["section"]!,head:searchContexts["head"]! ,url: searchModel.url,title: searchModel.title)
    }
}