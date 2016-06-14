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
        // Generate SearchQuery
        let searchQuery = QueryBuildCtrl().buildQuery(searchModel)
        //-------------------------------- /QueryBuild ---------------------------------------------
        //-------------------------------- QueryResulution -----------------------------------------


        
        checkCalls(searchModel, searchQuery: searchQuery, setRecommendations: setRecommendations)
        
        print("getRecommendationsNew")
       
        //-------------------------------- /QueryResulution -----------------------------------------
    }
    
    
    /*func getRecommendationsNew(searchModel:SEARCHModel, setRecommendations: (status:String,message: String, result: SearchResult) -> Void)
    {
        //-------------------------------- QueryBuild ----------------------------------------------
        // Generate SearchQuery
        let searchQuery = QueryBuildCtrl().buildQuery(searchModel)
        //-------------------------------- /QueryBuild ---------------------------------------------
        //-------------------------------- QueryResulution -----------------------------------------
        JSONConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result!)
        })
        
        URLConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            if result != nil {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result!)
            }
        })
        //-------------------------------- /QueryResulution -----------------------------------------
    }*/

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func callJsonSearchEngines(searchQuery: SearchQuery, setRecommendations: (status:String,message: String, result: SearchResult)-> Void, builder: AbstractBuilder){
        JSONConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result!)
        }, builder: builder)
            print("callJsonSearchEngines")
    
    }
    
    private func callURLSearchEngines(searchQuery: SearchQuery, setRecommendations: (status:String,message: String, result: SearchResult) -> Void, builder: AbstractBuilder){
        
        URLConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
            if result != nil {
                setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result!)
            }
        }, builder: builder)
            
             print("callURLSearchEngines")

    }
    
    private func checkCalls(searchModel:SEARCHModel, searchQuery: SearchQuery, setRecommendations: (status:String,message: String, result: SearchResult) -> Void){
        //let isAutor = SettingsManager.getAutorPreference()
        //let enabledSearchEngines = [SettingsManager.getEexcessPreference(), SettingsManager.getDuckDuckGoPreference()] //SettingsManager.getFarooPreference()]
        var isUserPreferences = false
        
        //Legt die unterstützten Suchmaschinen fest
        let builders = [EEXCESS_JSONBuilder(), DuckDuckGoURLBuilder()]
        let providers = ["eexcess", "duckduckgo", "faroo"]
        
        //Prüft ab, ob der Nutzer bevorzugte Suchmaschinen eingestellt hat
        if(SettingsManager.getEexcessPreference()){
            callJsonSearchEngines(searchQuery, setRecommendations: setRecommendations, builder: EEXCESS_JSONBuilder())
            
            isUserPreferences = true
            
             print("checkCalls EexcessPreference")
        }
        if(SettingsManager.getDuckDuckGoPreference()){
            callURLSearchEngines(searchQuery, setRecommendations: setRecommendations, builder: DuckDuckGoURLBuilder())
            
            isUserPreferences = true
             print("checkCalls DDG")
        }
        
        
        
        if(isUserPreferences){
            return
        }
        
        
        //Prüft ab, ob die vom Autor angegebenen Suchmaschinen verwendet werden sollen
        
        if(SettingsManager.getAutorPreference()){
            let provider = searchQuery.getLink().getFilterProvider()
            
            if(!provider.isEmpty){
                for i in 0 ..< providers.count{
                    if(providers[i] == provider){
                        if(i < 1){
                            callJsonSearchEngines(searchQuery, setRecommendations: setRecommendations, builder: builders[i] as! AbstractBuilder)
                            print("checkCalls AutorPreference  callJsonSearchEngines")
                        }else{
                            print("checkCalls AutorPreference callURLSearchEngines")
                            callURLSearchEngines(searchQuery, setRecommendations: setRecommendations, builder: builders[i] as! AbstractBuilder)
                            
                        }
                    }else{
                        callJsonSearchEngines(searchQuery, setRecommendations: setRecommendations, builder: builders[0] as! AbstractBuilder)
                    }
                    
                    print("checkCalls AutorPreference 1")
                }
            }else{
                callAllSearchEngines(searchQuery, setRecommendations: setRecommendations, providers: providers, builders: builders)
                print("checkCalls AutorPreference 2")

            }
        }else {
            callAllSearchEngines(searchQuery, setRecommendations: setRecommendations, providers: providers, builders: builders)
            print("checkCalls AutorPreference 3")
        }
        
        
        
        
    
    }
    
    private func callAllSearchEngines(searchQuery: SearchQuery, setRecommendations: (status:String,message: String, result: SearchResult) -> Void, providers:[String], builders: AnyObject){
        for i in 0 ..< providers.count{
            
                if(i < 1){
                    callJsonSearchEngines(searchQuery, setRecommendations: setRecommendations, builder: builders[i] as! AbstractBuilder)
                }else{
                    callURLSearchEngines(searchQuery, setRecommendations: setRecommendations, builder: builders[i] as! AbstractBuilder)
                }
         
            print("callAllSearchEngines")
        }

    }
    
}
