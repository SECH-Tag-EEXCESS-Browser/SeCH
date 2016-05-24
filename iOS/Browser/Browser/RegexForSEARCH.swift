//
//  Browser
//
//  Created by Brian Mairhörmann on 04.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
// This class implements methods for the usage of regex. The regex is specifically designed to fit the
// system of search-tags.

import Foundation

class RegexForSEARCH {
    
    //#########################################################################################################################################
    //##########################################################___Public_Methods___###########################################################
    //#########################################################################################################################################
    
    // Collects search-tags from a given string an returns them as a string-array
    func findSEARCHTags(inString string : String) -> [String]{
        
        let pattern = "</?search-[^>]*>"
        let regex = makeRegEx(withPattern: pattern)
        
        return getStringArrayWithRegex(string, regex: regex)
        
    }
    
    // Returns a boolean whether a given string is a section-closing-tag
    func isSEARCHSectionClosing(inString string : String) -> Bool {
        
        let pattern = "</search-section"
        let regex = makeRegEx(withPattern: pattern)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil
    }
    
    // Returns a boolean whether a given string is a link-closing-tag
    func isSEARCHLinkClosing(inString string : String) -> Bool {
        
        let pattern = "</search-link"
        let regex = makeRegEx(withPattern: pattern)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil
    }
    
    // Returns a boolean whether a given string includes a section
    func isSEARCHSection(inString string : String) -> Bool {
        
        let pattern = "<search-section"
        let regex = makeRegEx(withPattern: pattern)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil
    }
    
    // Returns a boolean whether a given string includes a link
    func isSEARCHLink(inString string : String) -> Bool {
        
        let pattern = "<search-link"
        let regex = makeRegEx(withPattern: pattern)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil
    }
    
    // Returns the attributes of a given string (head, section, link) as a dictionary
    func getAttributes(inString string : String) -> [String: String]{
        
        // Attributes: topic, type, mediaType, provider, licence
        let attributeNames = ["topic", "type", "mediaType", "provider", "licence"]
        var attributes = [String: String]()
        
        for attributeName in attributeNames {
            let regex = makeRegEx(withPattern: attributeName)
            let range = NSMakeRange(0, string.characters.count)
            
            if regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil {
                
                let regexAttribute = makeRegEx(withPattern: "(?<=\(attributeName)=\")([#-~ !§°`´äöüÄÖÜß]*)(?=\")")
                let match = getStringArrayWithRegex(string, regex: regexAttribute)
                
                if (match.isEmpty != true){
                    attributes[attributeName] = match[0]
                }
            }else{
                attributes[attributeName] = ""
            }
            
        }
        return attributes
    }
    
    
    
    //#########################################################################################################################################
    //##########################################################___Private_Methods___##########################################################
    //#########################################################################################################################################
    
    // Creates a regular-expression with a given pattern
    private func makeRegEx(withPattern pattern : String) -> NSRegularExpression{
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        return regex
    }
    
    // Returns all matches of a given string that map a given regex as a string-array
    private func getStringArrayWithRegex(string : String, regex : NSRegularExpression) -> [String]{
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matchesInString(string, options: NSMatchingOptions(), range: range)
        
        return matches.map {
            let range = $0.range
            return (string as NSString).substringWithRange(range)
        }
    }
}