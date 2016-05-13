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
        return "blabla"
    }
    
    func getHTTPMethod()->String{
        return "POST"
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
}