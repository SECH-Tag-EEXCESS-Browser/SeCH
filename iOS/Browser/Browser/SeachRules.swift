//
//  SeachRules.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 11.01.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

//Diese Klasse ist nur für die Datenhaltung der Regeln zuständig
class SeachRules {
    
    var seachRules: [[Rule]]
    
    init(){
        seachRules = []
    }
    
    func appendSeachRules(seachRule: [Rule]){
        seachRules.append(seachRule)
    }
    
}
