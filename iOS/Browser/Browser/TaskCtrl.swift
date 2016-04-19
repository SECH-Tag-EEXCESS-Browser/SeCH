//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {
    
    //let QUERY_URL: String = "https://eexcess-dev.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend"
    let QUERY_URL: String = "https://eexcess.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend"
    var searchObjects: SEARCHModels!
    
    func getRecommendations(webContent:WebContent, setRecommendations: (status:String,message: String, recommendationData: SearchResults?) -> Void)
    {
        searchObjects = SEARCHManager().getSEARCHObjects(webContent)
        
        if(searchObjects.getSearchModels().count == 0){
            setRecommendations(status: "FAILED",message: "Es sind keine Suchwörter vorhanden", recommendationData: nil)
            return
        }
        
        let searchQuerys = QueryBuildCtrl().buildQuery(searchObjects)
        
        let requestData = EEXCESSRecommendationJSONCtrl().addKontextKeywords(searchQuerys)

        JSONConnectionCtrl().post(requestData, url: QUERY_URL){ (succeeded: Bool, msg: NSData, searchQuerys:SearchQuerys?) -> () in
            if (succeeded) {
                let recommendationCtrl = EEXCESSRecommendationCtrl()
                guard let recommendation = recommendationCtrl.extractRecommendatins(msg,searchQuerys: searchQuerys) else
                {
                    print ("Versagen 1")
                    print(String(data: msg, encoding: NSUTF8StringEncoding)!)
                    setRecommendations(status: "FAILED",message: "Das Datenformat ist nicht verwertbar", recommendationData: nil)
                    return
                }
                
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", recommendationData: recommendation)
                
                let sm = SettingsManager()
                sm.getPreferencesValues()
            }
            else {
                print("Versagen 2")
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", recommendationData: nil)
            }
        }
    }
    
}
