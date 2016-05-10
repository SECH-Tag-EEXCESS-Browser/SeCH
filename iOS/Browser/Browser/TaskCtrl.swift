//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {
//-------------------------------- EXXCESS 
    //let QUERY_URL: String = "https://eexcess-dev.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend"
    let QUERY_URL: String = "https://eexcess.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend"
//-------------------------------- /EXXCESS

    var searchObjects: SEARCHModels!
    
    func getRecommendations(webContent:WebContent, setRecommendations: (status:String,message: String, recommendationData: SearchResults?) -> Void)
    {
//-------------------------------- SeARCHExtraction ----------------------------------------
        // Generate SearchObjects for QueryBuildCtrl
        searchObjects = SEARCHManager().getSEARCHObjects(webContent)
        
        // Controll container is Empty
        if(searchObjects.getSearchModels().isEmpty){
            setRecommendations(status: "FAILED",message: "Es sind keine Suchwörter vorhanden", recommendationData: nil)
            return
        }
//-------------------------------- /SeARCHExtraction ---------------------------------------
//-------------------------------- QueryBuild ----------------------------------------------
        // Generate SearchQuerys
        let searchQuerys = QueryBuildCtrl().buildQuery(searchObjects)
//-------------------------------- /QueryBuild ---------------------------------------------
//-------------------------------- QueryResulution -----------------------------------------
//-------------------------------- Faroo

        /*FarooConnectionCtrl().sendRequest(searchQuerys) {(searchResults: SearchResults) -> () in
            
            if(searchResults.getSearchResults().count == 0){
                setRecommendations(status: "FAILED", message: "Keine Suchergebnisse gefunden", recommendationData: nil)
                return
            }
            
            setRecommendations(status: "SUCCEDED", message: "Faroo war erfolgreich", recommendationData: searchResults)
            
            
        }*/
//-------------------------------- /Faroo
//-------------------------------- DuckDuckGo
      //let test = DuckDuckGoCtrl().extractSearch(searchQuerys)
        
//-------------------------------- /DuckDuckGo
//-------------------------------- EXXCESS
        
        // Generate Tuple(NSData,SearchQuerys) || NSData -> Query in JSON
        let requestData = EEXCESSRecommendationJSONCtrl().generateJSON(searchQuerys)
        
        // Send EEXCESS Request
        JSONConnectionCtrl().post(requestData, url: QUERY_URL){ (succeeded: Bool, msg: NSData, searchQuerys:SearchQuerys?) -> () in
            if (succeeded) {
                let recommendationCtrl = EEXCESSRecommendationCtrl()
                guard let recommendation = recommendationCtrl.extractRecommendatins(msg,searchQuerys: searchQuerys) else
                {
                    setRecommendations(status: "FAILED",message: "Das Datenformat ist nicht verwertbar", recommendationData: nil)
                    return
                }
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", recommendationData: recommendation)
            }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", recommendationData: nil)
            }
        }
//-------------------------------- /EXXCESS
//-------------------------------- /QueryResulution -----------------------------------------
    }
}
