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
        //-------------------------------- QueryCreation ----------------------------------------------
        let searchQuery = QueryCreationCtrl().buildQuery(searchModel)
        //-------------------------------- /QueryCreation ---------------------------------------------
        //-------------------------------- QueryResulution -----------------------------------------
        let builders = getListOfAllSearchEngineBuilder(searchQuery)
        for builder in builders {
            if let lbuilder  = builder as? AbstractJSONBuilder {
                JSONConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
                    setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result!)
                    }, builder: lbuilder)
            }else if let lbuilder = builder as? AbstractURLBuilder {
                URLConnectionCtrl().post(searchQuery, postCompleted: { (succeeded: Bool,result:SearchResult?) -> () in
                    setRecommendations(status:"SUCCEDED",message: "Die Anfrage war erfolgreich", result: result!)
                    }, builder: lbuilder)
            }else {
                print("<<<!!!! ERROR - Found a other class extends AbstractBuilder !!!!>>> ")
            }
        }
        //-------------------------------- /QueryResulution -----------------------------------------
    }
    
    private func getListOfAllSearchEngineBuilder(query:SearchQuery)->[AbstractBuilder] {
        //Legt die unterstützten Suchmaschinen fest
        var searchBuilders = [AbstractBuilder]()

        //Prüft ab, ob der Nutzer bevorzugte Suchmaschinen eingestellt hat
        if(SettingsManager.getEexcessPreference()){// if EEXCESS is enable in settings
            searchBuilders.append(EEXCESS_JSONBuilder())
            print("use Passau")
        }
        if(SettingsManager.getDuckDuckGoPreference()){// if DuckDuckGo is enable in settings
            searchBuilders.append(DuckDuckGoURLBuilder())
            print("use Duck")
        }
        
        if(SettingsManager.getFarooPreference()){// if Faroo is enable in settings
            searchBuilders.append(FarooURLBuilder())
            print("use Faroo")
        }
        // dic with all searchengines + keys
        let builders:[String:AbstractBuilder] = ["eexcess":EEXCESS_JSONBuilder(), "duckduckgo":DuckDuckGoURLBuilder(), "faroo":FarooURLBuilder()]
        // author filter for searchengine; if not set => provider = "" else name of searchengine (@see github/sech/wiki/Attributwerte)
        let provider = query.getLink().getFilterProvider()

        if(searchBuilders.isEmpty && provider != ""){// if no searchengine select and provider isn't "" => set authors searchengine setting
            let str:String = ((provider == "duckduckgo" || provider == "faroo") ? provider : "eexcess")
            searchBuilders.append(builders[str]!)
            print("use Author")
            }
        
        if(searchBuilders.isEmpty){// if nothing select or set => use all engines
            searchBuilders.append(EEXCESS_JSONBuilder())
            searchBuilders.append(DuckDuckGoURLBuilder())
            searchBuilders.append(FarooURLBuilder())
            print("use all")
        }
        return searchBuilders
    }
}