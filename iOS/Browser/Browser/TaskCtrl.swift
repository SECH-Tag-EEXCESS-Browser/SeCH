//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {
    
    func getRecommendations(webContent:WebContent, setRecommendations: (status:String,message: String, result: SearchResult? , searchModels:SEARCHModels) -> Void)
    {
//-------------------------------- SeARCHExtraction ----------------------------------------
        // Generate SearchObjects for QueryBuildCtrl
        let searchModels:SEARCHModels = SEARCHManager().getSEARCHObjects(webContent)
        
        // Controll container is Empty
        if(searchModels.getSearchModels().isEmpty){
            setRecommendations(status: "FAILED",message: "Es sind keine Suchwörter vorhanden", result: nil,searchModels: searchModels)
            return
        }
//-------------------------------- /SeARCHExtraction ---------------------------------------
//-------------------------------- QueryBuild ----------------------------------------------
        // Generate SearchQuerys
        let searchQuerys = QueryBuildCtrl().buildQuery(searchModels)
//-------------------------------- /QueryBuild ---------------------------------------------
//-------------------------------- QueryResulution -----------------------------------------
  /*      JSONConnectionCtrl().post(searchQuerys.getSearchQuerys()[0], postCompleted: { (succeeded: Bool,result:SearchResult) -> () in
            if (succeeded) {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result,searchModels: searchModels)
            }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil,searchModels: searchModels)
            }
        })*/
        
        URLConnectionCtrl().post(searchQuerys.getSearchQuerys()[0], postCompleted: { (succeeded: Bool,result:SearchResult) -> () in
            if (succeeded) {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result, searchModels: searchModels)
            }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil, searchModels: searchModels)
            }
        })
//-------------------------------- /QueryResulution -----------------------------------------
    }
    
    func getRecommendationsNew(webContent:WebContent, setRecommendations: (status:String,message: String, result: SearchResult? , searchModel:SEARCHModel) -> Void)
    {
        //-------------------------------- SeARCHExtraction ----------------------------------------
        // Generate SearchObjects for QueryBuildCtrl
        let searchModel = SEARCHManager().getSEARCHObjects(webContent).getSearchModels()[0]

        //-------------------------------- /SeARCHExtraction ---------------------------------------
        //-------------------------------- QueryBuild ----------------------------------------------
        // Generate SearchQuery
        let searchQuery = QueryBuildCtrl().buildQuery(searchModel)
        //-------------------------------- /QueryBuild ---------------------------------------------
        //-------------------------------- QueryResulution -----------------------------------------
        JSONConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult) -> () in
            if (succeeded) {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result,searchModel: searchModel)
            }
            else {
                setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil,searchModel: searchModel)
            }
        })
        
                URLConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult) -> () in
                    if (succeeded) {
                        setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result,searchModel: searchModel)
                    }
                    else {
                        setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil,searchModel: searchModel)
                    }
                })
        //-------------------------------- /QueryResulution -----------------------------------------
    }
}
