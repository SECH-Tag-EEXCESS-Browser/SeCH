//
//  MainController.swift
//  Sech
//
//  Created by Alexander Pöhlmann on 23.10.15.
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

class MainController2{
    
    var finishMethod:((msg:String) -> ())?
    let queryJSONManager = QueryJSONManager()
    let CONNECTIONMANAGER = ConnectionManager()
    let RESPONSEJSONMANAGER = ResponseJSONManager()
    var counterRecommend = 0
    
    init(){
        responseMethod = ({(succeeded: Bool, msg: NSData) -> () in
            
            if(succeeded)
            {
                dispatch_async(dispatch_get_main_queue(), {
                    let json = JSONObject(data: msg)
                    self.sortRecommend(json)
                    self.counterRecommend--
                    if self.counterRecommend <= 0{
                        self.finishMethod!(msg: "DONE")
                    }
                })
            }else {
                self.finishMethod!(msg: "ERROR")
            }
        })
    }
    
    var responseMethod = ({(succeeded: Bool, msg: NSData) -> () in
    
    })
    
    let detaileResponseMethod = ({(succeeded: Bool, msg: NSData) -> () in
        if(succeeded){
                dispatch_async(dispatch_get_main_queue(), {
//                    self.detailView.string = String(data: msg, encoding: NSUTF8StringEncoding)!
//                    self.msg = msg
//                    self.MAINCONTROLLER.mapOfJSONs["\(self.recommendation.stringValue)_DETAIL"] = JSONObject(data: msg)
                })
        }else {
//            self.finishMethod!(msg: "ERROR")
        }
    })
    
    func sortRecommend(json:JSONObject){
        RESPONSEJSONMANAGER.sortRecommend(json)
    }
    
    func setFinishMethod(listener:(msg:String)->()){
        self.finishMethod = listener
    }
    
    func createJSONForRequest(sechs:[String:Sech],detail:Bool, pref: [String:String]){
        //var json = [JSONObject]()
        
        if detail {
//            var dataForDetailRequest:[String:AnyObject]
//            if let data = (keyWordsWithKeys["json"] as? JSONObject) {
//                dataForDetailRequest = createDetailRequest(data)
//            }else{
//                dataForDetailRequest = createDetailRequest(keyWordsWithKeys["json"] as! [[String:AnyObject]])
//            }
//            
//            json.append(JSONMANAGER.createDetailRequest(dataForDetailRequest["queryID"] as! String, documentBadge: dataForDetailRequest["documentBadge"] as! [[String:AnyObject]]))
        }else{
            SechPage.instance.sechs = sechs
            counterRecommend++
            makeRequest(queryJSONManager.createRequestJSON(SechPage.instance.sechs,preferences: pref),detail: detail)
        }
    }
    
    func makeRequest(json:JSONObject,detail:Bool)->Bool{
        print("\(json.convertToString())/n")
        if detail{
            self.CONNECTIONMANAGER.makeHTTP_Request(json, url: PROJECT_URL.GETDETAILS, httpMethod: ConnectionManager.POST, postCompleted: self.detaileResponseMethod)
        }else{
            self.CONNECTIONMANAGER.makeHTTP_Request(json, url: PROJECT_URL.RECOMMEND, httpMethod: ConnectionManager.POST, postCompleted: self.responseMethod)
        }
        
        return  true
    }

    
}

class MainController{
    let JSONMANAGER:JSONManager
    let CONNECTIONMANAGER:ConnectionManager
    
    var responseMethod:((succeeded: Bool, data: NSData) -> ())?
    var detaileResponseMethod:((succeeded: Bool, data: NSData) -> ())?
    //normal response have sech-tag name and detaile response have a prefix: "_DETAILE"
    var mapOfJSONs = [String:JSONObject]()
    
    required init(){
        self.CONNECTIONMANAGER = ConnectionManager()
        self.JSONMANAGER = JSONManager()
    }
//    
//    func createJSONForRequest(keyWordsWithKeys:[String:AnyObject],detail:Bool, pref: [String:String])->JSONObject?{
//        var json = [JSONObject]()
//        
//        if detail {
//            var dataForDetailRequest:[String:AnyObject]
//            if let data = (keyWordsWithKeys["json"] as? JSONObject) {
//                dataForDetailRequest = createDetailRequest(data)
//            }else{
//                dataForDetailRequest = createDetailRequest(keyWordsWithKeys["json"] as! [[String:AnyObject]])
//            }
//            
//            //json.append(JSONMANAGER.createDetailRequest(dataForDetailRequest["queryID"] as! String, documentBadge: dataForDetailRequest["documentBadge"] as! [[String:AnyObject]]))
//        }else{
//            
//            
//            let num = 0.1
//            let gender = pref["gender"]!
//            let language = pref["language"]!
//            let city = pref["city"]!
//            let country = pref["country"]!
//            let age = pref["age"]!
//   
//            let ageRange = calculateAgeRange(Int (age)!)
//            
//            
//            
//           // json = JSONMANAGER.createRequestJSON(keyWordsWithKeys["ContextKeywords"] as! [[JSONObject]], numResults: keyWordsWithKeys["numResults"] as! Int!,gender: gender,ageRange:ageRange, languages: [JSONObject(keyValuePairs: ["iso2":language,"languageCompetenceLevel":num])],address: JSONObject(keyValuePairs: ["country":country,"city":city]),queryID: keyWordsWithKeys["queryID"] as! String)
//        }
//        return json
//    }
    
    func getFirstItem()->JSONObject{
        for json in self.mapOfJSONs {
            return json.1
        }
        return JSONObject()
    }
    
    func setMethodForResponse(postCompleted :(succeeded: Bool, data: NSData) -> ())->Bool{
        self.responseMethod = postCompleted
        return true
    }
    func setMethodForDetaileResponce(postCompleted :(succeeded: Bool, data: NSData) -> ())->Bool{
        self.detaileResponseMethod = postCompleted
        return true
    }
    
    func makeRequest(json:JSONObject,detail:Bool)->Bool{
        if detail{
            self.CONNECTIONMANAGER.makeHTTP_Request(json, url: PROJECT_URL.GETDETAILS, httpMethod: ConnectionManager.POST, postCompleted: self.detaileResponseMethod!)
        }else{
            self.CONNECTIONMANAGER.makeHTTP_Request(json, url: PROJECT_URL.RECOMMEND, httpMethod: ConnectionManager.POST, postCompleted: self.responseMethod!)
        }
        
        return  true
    }
    func seperateDocumentBages(json:JSONObject)->[[String:AnyObject]]{
        var jsons = [[String:AnyObject]]()
        for jsonA in json.getJSONArray("results")! {
            for jsonObject in jsonA.getJSONArray("result")!{
                jsons.append(jsonObject.getJSONObject("documentBadge")!.jsonObject)
            }
        }
        return jsons
    }
    
    private func createDetailRequest(json:JSONObject)->[String:AnyObject]{
        let queryID:String = self.getFirstItem().getString("queryID")!
        return ["queryID":queryID,"documentBadge":[json.jsonObject]]
    }
    private func createDetailRequest(json:[[String:AnyObject]])->[String:AnyObject]{
        let queryID:String = self.getFirstItem().getString("queryID")!
        return ["queryID":queryID,"documentBadge":json]
    }
    
    private func getLicenceType(licenseURL: String) ->LicenceType{
        if (licenseURL.lowercaseString.rangeOfString("creative") != nil || licenseURL.lowercaseString.rangeOfString("common") != nil){
            return LicenceType.CreativeCommon
        }else if(licenseURL.lowercaseString.rangeOfString("restricted") != nil){
            return LicenceType.Restricted
        }else if(licenseURL.lowercaseString.rangeOfString("europeana") != nil){
            return LicenceType.Europeana
        }
        
        return LicenceType.Other
    }
    
    
    private func calculateAgeRange(ageInYears:Int) -> Int{
    
    //child = 0 - 17
    //young adult = 18 - 25
    //adult > 25
    
        
        if(ageInYears < 18){
            return 0
        }else if(ageInYears > 25){
            return 2
        }
        
        return 1
        
        
    }
    
    enum LicenceType{
        case CreativeCommon
        case Restricted
        case Europeana
        case Other
    }
}
