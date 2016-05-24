//
//  FarooURLBuilder.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class FarooURLBuilder:AbstractURLBuilder {
    
    func generateURL(query:SearchQuery)->String{
        
        var topic: String = ""
        
        let language = query.getLanguage()
        let basicUrl = "http://www.faroo.com/api?q="
        
        let key = "&key=FQtTu5NKF02wXVyU2viD2SjfJ4Q_"
        let restUrl = "&start=1&length=10&l=\(language)&src=web&f=json\(key)"
        
        
        
            topic += checkSpecialCharakters(query.getLink().getSearchWord())
            topic += "&q="
        
            
            topic += checkSpecialCharakters(query.getSection().getSearchWord())
            
            topic += "&q="
            
            topic += checkSpecialCharakters(query.getHead().getSearchWord())
            
            let completeUrl = basicUrl + topic + restUrl
            
            print("URL " + completeUrl)
        
        
    

        return completeUrl
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
        return FarooResponseParser(query: query)
    }

    private func checkSpecialCharakters(var query: String)->String{
        let specialCharacters = [" ", "/", "=", "(", ")", ":", ";"]
        
        
        for specialChar in specialCharacters{
            
            query = query.stringByReplacingOccurrencesOfString(specialChar, withString: "%20")
        }
        
        return query
    }

}