//
//  ConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class JSONConnectionCtrl:ConnectionCtrl {
    
    override func post(params : (SearchQuerys,AnyObject), url : String,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
    {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let data =  try! NSJSONSerialization.dataWithJSONObject(params.1, options: [NSJSONWritingOptions()])
        
        self.post((params.0 ,data), request: request, postCompleted: postCompleted)
    }
}


class FarooConnectionCtrl: ConnectionCtrl{
    
    
    
    func sendRequest(searchQuerys: SearchQuerys)->SearchResults{
        var topic: String = ""
        let language = SettingsManager.getLanguage()
        let basicUrl = "http://www.faroo.com/api?\(topic)start=1&length=10&l=\(language)&src=web&f=json"
        
        var searchResults: [SearchResult] = []
        
        
        let searchQueryArray: [SearchQuery] = searchQuerys.getSearchQuerys()
        
        for searchQuery in searchQueryArray{
            let searchContexts: [String:SearchContext] = searchQuery.getSearchContext()
            
            for searchContext in searchContexts{
                let searchContextValues: [String: AnyObject] = searchContext.1.getValues()
                topic += "q="
                topic += searchContextValues["text"] as! String
                topic += "&"
                
            }
            
            print("topic in URL: " + topic)
            
            let request = NSMutableURLRequest(URL: NSURL(string: basicUrl)!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            self.post((searchQuerys, NSData()), request: request, postCompleted: { (succeeded, data, searchQuerys) -> () in

                 searchResults.append(self.parseJson(data, index: searchQuery.getIndex(), url: searchQuery.getUrl(), title: searchQuery.getTitle(), language: language)!)
            })
            
            
            topic = ""
            
        }
        
        print("Anzahl an Results: \(searchResults.count)")
        
        return SearchResults(searchResults: searchResults)
        
    }
    
    private func parseJson(data: NSData, index: Int, url: String, title: String, language: String)->SearchResult?{
        
        let provider = "Faroo"
         var searchResultItems: [SearchResultItem] = []
        
        
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableContainers]) as AnyObject
        
        print("Faroo json" + String(data: data, encoding: NSUTF8StringEncoding)!)
        
        guard let allResults = JSONData.fromObject(json!)!["results"]?.array as [JSONData]! else{
            return nil
        }
        
        for(index, allResult) in allResults.enumerate(){
            let title2 = allResult.object!["title"]?.string
            let url = allResult.object!["url"]?.string
            let author = allResult.object!["author"]?.string
            
            searchResultItems.append(SearchResultItem(title: title2!, provider: provider, uri: url!, language: language, mediaType: MediaTypes.unknown.simpleDescription()))
            
        }
        
        return SearchResult(index: index, url: url, resultItems: searchResultItems, title: title)
        
    }
}

class ConnectionCtrl {

    var searchQuerys:SearchQuerys?
    
    func post(params : (SearchQuerys,AnyObject), url : String,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ()){
            postCompleted(succeeded: false,data: "Es wird die abstrakte Klasse ConnectionCtrl".dataUsingEncoding(NSUTF8StringEncoding)!,searchQuerys: nil)
    }
    
     private func post(data : (SearchQuerys,NSData), request : NSMutableURLRequest,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
     {
        print("start")
        self.searchQuerys = data.0
        request.HTTPMethod = "POST"
        request.HTTPBody = data.1
        let session = NSURLSession.sharedSession()
        print("running")
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("stoped")
            postCompleted(succeeded: error == nil, data: data!,searchQuerys: self.searchQuerys!)
        })
        task.resume()
    }
}