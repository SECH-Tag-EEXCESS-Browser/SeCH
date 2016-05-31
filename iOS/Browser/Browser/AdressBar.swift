//
//  AdressBar.swift
//  Browser
//
//  Created by Andreas Ziemer on 11.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
//
// This class validates the URL or send the query to google


import Foundation

class AddressBar{
    
    func checkURL(url : String) -> String{
        let checkedURL: String?
        
        if(validateHTTPWWW(url) || validateHTTP(url)){
            checkedURL = url
        }else if(validateWWW(url)){
            checkedURL = "https://" + url
        }else{
            let searchString = url.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            checkedURL = "https://www.google.de/#q=\(searchString)"
        }
       return checkedURL!
    }
    
    func validateHTTP (stringURL : NSString) -> Bool
    {
        let urlRegEx = "((https|http)://).*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        return predicate.evaluateWithObject(stringURL)
    }
    func validateWWW (stringURL : NSString) -> Bool
    {
        let urlRegEx = "((\\w|-)+)(([.]|[/])((\\w|-)+)).*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        return predicate.evaluateWithObject(stringURL)
    }
    func validateHTTPWWW (stringURL : NSString) -> Bool
    {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+)).*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        return predicate.evaluateWithObject(stringURL)
    }

}