//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {
    
    func getRecommendationsNew(searchModel:SEARCHModel, setRecommendations: (status:String,message: String, results: [SearchResult]) -> Void)
    {
        var results = [SearchResult]()
        var countResults = 0 // ++ for every SearchEngine Callback
        //-------------------------------- QueryBuild ----------------------------------------------
        // Generate SearchQuery
        let searchQuery = QueryBuildCtrl().buildQuery(searchModel)
        //-------------------------------- /QueryBuild ---------------------------------------------
        //-------------------------------- QueryResulution -----------------------------------------
        JSONConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            countResults++
            print(countResults)
            if (succeeded && result != nil) {
                results.append(result!)
            }else {
                //setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil)
            }
            if countResults == 3 {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", results: results)
            }
        })
        
        URLConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            countResults++
            print(countResults)
            if (succeeded && result != nil) {
                results.append(result!)
               // setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result)
            }else {
                //setRecommendations(status: "FAILED",message: "Die Anfrage war nicht erfolgreich", result: nil)
                 }
            if countResults == 3 {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", results: results)
            }
         })
        //-------------------------------- /QueryResulution -----------------------------------------
    }
}
