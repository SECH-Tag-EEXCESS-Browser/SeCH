//
//  DuckDuckGoURLBuilder.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class DuckDuckGoURLBuilder:AbstractURLBuilder {
    
    func generateURL(query:SearchQuery)->String{
        
        let searchUrl = query.getLink().getSearchWord()
        let newSearchString = searchUrl.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let basicUrl = "http://api.duckduckgo.com/?q=\(newSearchString)&format=json&pretty=1&t=sechbrowser"
       // let basicUrl = "http://api.duckduckgo.com/?q=bayern&format=json&pretty=1&t=sechbrowser"
        print(basicUrl)
        
        return basicUrl
    }
    
    func getHTTPMethod()->String{
        return "GET"
    }
    
    func getContentType()->String{
        return "application/json"
    }
    
    func getAcceptType()->String{
        return "application/json"
    }
    
    func getParser(query:SearchQuery)->AbstractResponseParser{
        return DuckDuckGoResponseParser(query: query)
    }

}