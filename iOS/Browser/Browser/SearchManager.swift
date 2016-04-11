//
//  SearchManager.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class SEARCHManager {
    private let regex = RegexForSEARCH()
    private let headFilter = Filter()
    private var searchCollection = [SEARCHModel]()
    
    // TODO: Validation of Filterattributes
    private var validationFilterMediaType = []
    
    func getSEARCHObjects(html:WebContent) -> SEARCHModels {
        
        let searchHead = getSEARCHHead(html.getHtml().getHeadAndBody().0)
        makeSech(searchHead, htmlBody: html.getHtml().getHeadAndBody().1)
        
        let searchModels = SEARCHModels(searchModels: searchCollection)
        searchCollection.removeAll()
        
        return searchModels
    }
    
//    func getSEARCHObjects(htmlHead : String, htmlBody : String) -> [SEARCHModel] {
//        
//        let searchHead = getSEARCHHead(htmlHead)
//        makeSech(searchHead, htmlBody: htmlBody)
//        
//        let tmpSEARCHCollection = searchCollection
//        searchCollection = [SEARCHModel]()
//        
//        return tmpSEARCHCollection
//    }
    
    // Private Methods
    // #################################################################################################
    private func getSEARCHHead(htmlHead : String) -> Tag{
        
        // Get Head-SEARCH-Tag
        let headSEARCH = regex.findSEARCHTags(inString: htmlHead)
        var headAttributes = [String : String]()
        let head = Tag()
        
        
        if headSEARCH.isEmpty != true{
            headAttributes = regex.getAttributes(inString: "\(headSEARCH[0])")
            
            // Set Headattributes
            head.topic = headAttributes["topic"]!
            head.type = headAttributes["type"]!
            head.isMainTopic = false
            
            // Set Filterattributes
            headFilter.mediaType = headAttributes["mediaType"]!
            headFilter.provider = headAttributes["provider"]!
            headFilter.licence = headAttributes["licence"]!
        }
        return head
    }
    
    private func makeSech(head: Tag, htmlBody : String){
        
        let searchBodyArray = regex.findSEARCHTags(inString: htmlBody)
        var tmpSection = Tag()
        var tmpFilter = headFilter
        var sectionIsAvailable = false
        
        if searchBodyArray.count > 0{
        for i in 0 ..< searchBodyArray.count-1 {
            
            //Check for Closingtags
            if regex.isSEARCHSectionClosing(inString: searchBodyArray[i]){
                tmpFilter = headFilter
                sectionIsAvailable = false
                continue
            }
            if regex.isSEARCHLinkClosing(inString: searchBodyArray[i]){
                continue
            }
            
            //Check if Element is Section
            if regex.isSEARCHSection(inString: searchBodyArray[i]){
                tmpSection = makeTagObject(searchBodyArray[i], isMainTopic: false)
                tmpFilter = setFilter(tmpFilter, newFilter: searchBodyArray[i])
                sectionIsAvailable = true
                continue
            }
            
            // Check if Element is Link
            if regex.isSEARCHLink(inString: searchBodyArray[i]){
                if sectionIsAvailable == true{
                    let link = makeTagObject(searchBodyArray[i], isMainTopic: true)
                    makeSEARCHObject(head, section: tmpSection, link: link, filter: setFilter(tmpFilter, newFilter: searchBodyArray[i]),withID: i)
                }
                if sectionIsAvailable == false{
                    let link = makeTagObject(searchBodyArray[i], isMainTopic: true)
                    makeSEARCHObject(head, section: Tag(), link: link, filter: setFilter(headFilter, newFilter: searchBodyArray[i]),withID: i)
                }
            }
        }
        }
    }
    
    private func makeTagObject(tagText : String, isMainTopic : Bool) -> Tag{
        let attributes = regex.getAttributes(inString: tagText)
        let tmpTag = Tag()
        
        tmpTag.isMainTopic = isMainTopic
        
        if (attributes["topic"] != nil){
            tmpTag.topic = (attributes["topic"])!
        }
        
        if (attributes["type"] != nil){
            tmpTag.type = attributes["type"]!
        }
        
        return tmpTag
    }
    
    private func setFilter(oldFilter : Filter, newFilter : String) -> Filter{
        let attributes = regex.getAttributes(inString: newFilter)
        let tmpFilter = Filter()
        
        // Get new Filter Attributes
        if (attributes["mediaType"] != nil){
            tmpFilter.mediaType = attributes["mediaType"]!
        }
        if (attributes["provider"] != nil){
            tmpFilter.provider = attributes["provider"]!
        }
        if (attributes["licence"] != nil){
            tmpFilter.licence = attributes["licence"]!
        }
        
        // If Attributes are not empty -> make new Filter
        if tmpFilter.mediaType.isEmpty{
            tmpFilter.mediaType = oldFilter.mediaType
        }
        if tmpFilter.provider.isEmpty{
            tmpFilter.provider = oldFilter.provider
        }
        if tmpFilter.licence.isEmpty{
            tmpFilter.licence = oldFilter.licence
        }
        
        return tmpFilter
    }
    
    private func makeSEARCHObject(head : Tag, section : Tag, link : Tag, filter : Filter, withID:Int){
        let searchObject = SEARCHModel()
        
        searchObject.tags = ["head" : head, "section" : section, "link" : link]
        searchObject.filters = filter
        searchObject.title = (searchObject.tags["link"]?.topic)!
        searchObject.index = withID
        searchCollection.append(searchObject)
    }
}
