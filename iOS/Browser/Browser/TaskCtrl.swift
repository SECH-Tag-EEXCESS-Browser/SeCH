//
//  TaskCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class TaskCtrl {
    
    func getRecommendationsNew(searchModel:SEARCHModel, setRecommendations: (status:String,message: String, result: SearchResult) -> Void)
    {
        //-------------------------------- QueryBuild ----------------------------------------------
        let searchQuery = QueryBuildCtrl().buildQuery(searchModel)
        //-------------------------------- /QueryBuild ---------------------------------------------
        //-------------------------------- QueryResulution -----------------------------------------
        let builders = getListOfAllSearchEngineBuilder(searchQuery)
        for builder in builders {
            print("<<< send me >>>")
            if let lbuilder  = builder as? AbstractJSONBuilder {
                print("send JSON")
                JSONConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
                    setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result!)
                    }, builder: lbuilder)
            }else if let lbuilder = builder as? AbstractURLBuilder {
                print("send URL")
                URLConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
                    setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result!)
                    }, builder: lbuilder)
            }else {
                print("nothing")
            }
        }
        print("getRecommendationsNew")
        //-------------------------------- /QueryResulution -----------------------------------------
    }
    
    private func getListOfAllSearchEngineBuilder(query:SearchQuery)->[AbstractBuilder] {
        //Legt die unterstützten Suchmaschinen fest
        var searchBuilders = [AbstractBuilder]()

        //Prüft ab, ob der Nutzer bevorzugte Suchmaschinen eingestellt hat
        if(SettingsManager.getEexcessPreference()){
            searchBuilders.append(EEXCESS_JSONBuilder())
            print("checkCalls EexcessPreference")
        }
        if(SettingsManager.getDuckDuckGoPreference()){
            searchBuilders.append(DuckDuckGoURLBuilder())
            print("checkCalls DDG")
        }
        
        if(SettingsManager.getFarooPreference()){
            searchBuilders.append(FarooURLBuilder())
            print("checkCalls Faroo")
        }
        
        let builders:[String:AbstractBuilder] = ["eexcess":EEXCESS_JSONBuilder(), "duckduckgo":DuckDuckGoURLBuilder(), "faroo":FarooURLBuilder()]
        let provider = query.getLink().getFilterProvider()

        if(searchBuilders.isEmpty && provider != ""){
            let str:String = ((provider == "duckduckgo" || provider == "faroo") ? provider : "eexcess")
            searchBuilders.append(builders[str]!)
            }
        
        if(searchBuilders.isEmpty){
            searchBuilders.append(EEXCESS_JSONBuilder())
            searchBuilders.append(DuckDuckGoURLBuilder())
            searchBuilders.append(FarooURLBuilder())
        }
        return searchBuilders
    }
}