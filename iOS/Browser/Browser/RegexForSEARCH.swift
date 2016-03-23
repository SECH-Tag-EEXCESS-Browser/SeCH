//
//  Browser
//
//  Created by Brian Mairhörmann on 04.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class RegexForSEARCH {
    
    func findSEARCHTags(inString string : String) -> [String]{
        
        let pattern = "</?search-[^>]*>"
        let regex = makeRegEx(withPattern: pattern)
        
        for item in getStringArrayWithRegex(string, regex: regex){
            print(item)
        }
        
        return getStringArrayWithRegex(string, regex: regex)
        
    }
    
    func isSEARCHSectionClosing(inString string : String) -> Bool {
        
        let pattern = "</search-section"
        let regex = makeRegEx(withPattern: pattern)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil
    }
    
    func isSEARCHLinkClosing(inString string : String) -> Bool {
        
        let pattern = "</search-link"
        let regex = makeRegEx(withPattern: pattern)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil
    }
    
    func isSEARCHSection(inString string : String) -> Bool {
        
        let pattern = "<search-section"
        let regex = makeRegEx(withPattern: pattern)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil
    }
    
    func isSEARCHLink(inString string : String) -> Bool {
        
        let pattern = "<search-link"
        let regex = makeRegEx(withPattern: pattern)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(), range: range) != nil
    }
    
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
    
    // Private Methods
    //#################################################################################################
    private func makeRegEx(withPattern pattern : String) -> NSRegularExpression{
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        return regex
    }
    
    private func getStringArrayWithRegex(string : String, regex : NSRegularExpression) -> [String]{
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matchesInString(string, options: NSMatchingOptions(), range: range)
        
        return matches.map {
            let range = $0.range
            return (string as NSString).substringWithRange(range)
        }
    }
}