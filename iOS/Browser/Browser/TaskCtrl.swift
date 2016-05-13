//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {

    var searchObjects:SEARCHModels?
    
    func getRecommendations(webContent:WebContent, setRecommendations: (status:String,message: String, result: SearchResult?) -> Void)
    {
//-------------------------------- SeARCHExtraction ----------------------------------------
        // Generate SearchObjects for QueryBuildCtrl
        searchObjects = SEARCHManager().getSEARCHObjects(webContent)
        
        // Controll container is Empty
        if(searchObjects!.getSearchModels().isEmpty){
            setRecommendations(status: "FAILED",message: "Es sind keine Suchwörter vorhanden", result: nil)
            return
        }
//-------------------------------- /SeARCHExtraction ---------------------------------------
//-------------------------------- QueryBuild ----------------------------------------------
        // Generate SearchQuerys
        let searchQuerys = QueryBuildCtrl().buildQuery(searchObjects!)
//-------------------------------- /QueryBuild ---------------------------------------------
//-------------------------------- QueryResulution -----------------------------------------
        JSONConnectionCtrl().post(searchQuerys.getSearchQuerys()[0], postCompleted: { (succeeded: Bool,result:SearchResult) -> () in
            if (succeeded) {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result)
            }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil)
            }
        })
        
//        URLConnectionCtrl().post(searchQuerys.getSearchQuerys()[0], postCompleted: { (succeeded: Bool,result:SearchResult) -> () in
//            if (succeeded) {
//                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result)
//            }
//            else {
//                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil)
//            }
//        })
//-------------------------------- /QueryResulution -----------------------------------------
    }
}
