//
//  Rules.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 23.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

protocol Rule{
    var weighting: Double {get set}
    var classId: String {get}
    func applyRule(parameters: String)->RuleMatch
}


class Rules {
    var storedRules: [SeachRules]
    private var allResponses: [SearchResult]!
    
    init(){
        storedRules = []
    }
    
    func addRule(rule: SeachRules){
        storedRules.append(rule)
    }
    
    func applyRulesToAllResponses(var response: SearchResult) {
        calculateValueOfEachRule(response)

            var results = response.getResultItems()
            results.sortInPlace({$0.getAvg() > $1.getAvg()})
            response.setResultItems(results)
        
        
    }
    
    
    private func calculateValueOfEachRule(response: SearchResult){
        

            for res in response.getResultItems(){
                let avg = calculateRulesForSingleResponse(res)
                
                res.setAvg(avg)
                
                if(res.getProvider() == "Mendeley"){
                    res.setAvg(0)
                }
                
            } 
            
        
    }
    
    private func calculateRulesForSingleResponse(res: SearchResultItem)->Double{
        
        var ruleValues: [Double] = []
        var sum: Double = 0
        
        for seachrule in storedRules{
            for rules in seachrule.seachRules{
                for rule in rules{
                    let val = rule.applyRule(getRuleParameters(rule, response: res))
                    let v = Double(val.simpleDescription()) * rule.weighting
                    ruleValues.append(v)
                    sum = sum + v
                }
            }
        }
        
        sum = sum / Double(ruleValues.count)
        
        return sum
        
    }
    
    
    private func getRuleParameters(rule: Rule, response: SearchResultItem)->String{
        switch rule.classId{
        case "MediaType":
            return response.getMediaType()
        case "Language":
            return response.getLanguage()
        case "Mendeley":
            return response.getProvider()
        default:
            return ""
        }
    }
    
    
}


//<Rules> ----------------------------------------------------------------------------------------------------------------


class MediaType: Rule {
    var weighting: Double = 0.6
    var classId: String = "MediaType"
    var expectedResult: MediaTypes
    
    init(expectedResult: MediaTypes){
        self.expectedResult = expectedResult
    }
    
    func applyRule(responseValue: String) -> RuleMatch {
        
        return (expectedResult.simpleDescription() == responseValue.lowercaseString ? RuleMatch.Match : RuleMatch.NoMatch)
    }
    
}

class Language: Rule{
    var weighting: Double = 0.8
    var classId: String = "Language"
    var expectedResult: LanguageType
    var title:String
    
    
    
    init(expectedResult: LanguageType, title:String){
        self.expectedResult = expectedResult
        self.title = title
    }
    
    func applyRule(responseValue:String) -> RuleMatch {
        
        if(responseValue != "unknown"){
            return (expectedResult.simpleDescription() == responseValue.lowercaseString ? RuleMatch.Match : RuleMatch.NoMatch)
        }
        
        return getLanguage(title) == expectedResult ? RuleMatch.Match : RuleMatch.NoMatch
    }
    
    
    private func getLanguage(recommendationLanguage: String)->LanguageType{
        if(recommendationLanguage.contains("ö") || recommendationLanguage.contains("ä") || recommendationLanguage.contains("ü") || recommendationLanguage.contains("der") || recommendationLanguage.contains("die") || recommendationLanguage.contains("das")){
            return LanguageType.German
        }else if(recommendationLanguage.contains("the") || recommendationLanguage.contains("to") || recommendationLanguage.contains("and") || recommendationLanguage.contains("is") || recommendationLanguage.contains("are") || recommendationLanguage.contains("do")){
            return LanguageType.English
        }else if(recommendationLanguage.contains("é") || recommendationLanguage.contains("è") || recommendationLanguage.contains("â") || recommendationLanguage.contains("avec") || recommendationLanguage.contains("la") || recommendationLanguage.contains("les") || recommendationLanguage.contains("ô")){
            return LanguageType.French
        }else if(recommendationLanguage.contains("í") || recommendationLanguage.contains("ó") || recommendationLanguage.contains("con")){
            return LanguageType.Spanish
        }
        
        return LanguageType.Unknown
    }
}

class Mendeley: Rule {
    var weighting: Double = 0.5
    var expectedResult: String
    var classId:String = "Mendeley"
    
    init(expectedResult : String){
        self.expectedResult = expectedResult
    }
    
    
    func applyRule(parameters: String) -> RuleMatch {
        return (expectedResult.lowercaseString == parameters.lowercaseString) ? RuleMatch.NoMatch : RuleMatch.Match
    }
    
    
}

//class Image: Rule{
//    var weighting: Double {
//        get{
//            return self.weighting
//        }
//        set (value){
//            self.weighting = value
//        }
//    }
//
//    var classId: String = "Image"
//    func applyRule(parameters: String)->RuleMatch{
//        return (
//    }
//
//}


//<Enums> -----------------------------------------------------------------------------------------------------------------------

enum RuleMatch{
    case Match, NoMatch
    
    func simpleDescription()->Int{
        switch self{
        case .Match:
            return 1
        case .NoMatch:
            return 0
            
        }
        
    }
}

enum LanguageType{
    case German, English, French, Spanish, Unknown
    
    func simpleDescription()->String{
        switch self{
        case .German:
            return "de"
        case .English:
            return "en"
        case .French:
            return "fr"
        case .Spanish:
            return "es"
        case .Unknown:
            return "unknown"
        }
    }
}


enum MediaTypes{
    case image, text, unknown
    
    func simpleDescription()->String{
        switch self{
        case .image:
            return "image"
        case .text:
            return "text"
        case .unknown:
            return "unknown"
        }
    }
    
    
}

extension String{
    func contains(find: String)->Bool{
        return self.rangeOfString(find, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
        
    }
}


/*class Test{
    var allResponses: [EEXCESSAllResponses]
    var singleResponses: [EEXCESSSingleResponse]
    var rules: [Rule]
    var rule: Rules
    
    init(){
        rules = []
        rules.append(MediaType(expectedResult: MediaTypes.image))
        rules.append(Language(expectedResult: .English, title: ""))
        rules.append(Mendeley(expectedResult: "Mendeley"))
        
        singleResponses = []
        
        
        singleResponses.append(EEXCESSSingleResponse(title: "Das ist ein langer Test Titel", provider: "unknown", uri: "http://www.hof-university.de", language: "de", mediaType: "text"))
        singleResponses.append(EEXCESSSingleResponse(title: "Last Test Title", provider: "Europeana", uri: "http://www.facebook.com", language: "de", mediaType: "image"))
        singleResponses.append(EEXCESSSingleResponse(title: "Test Titel", provider: "Mendeley", uri: "http://www.google.de", language: "en", mediaType: "image"))
        
        allResponses = []
        let all = EEXCESSAllResponses()
        all.responses = singleResponses
        allResponses.append(all)
        
        rule = Rules()
        rule.addRule(rules[0])
        rule.addRule(rules[1])
        rule.addRule(rules[2])
        
        rule.applyRulesToAllResponses(allResponses)
        
        for i in allResponses{
            for j in i.responses{
                print("Title: \(j.title)       Avg: \(j.avg)")
            }
        }
        
    }*/
    
    
    
    
