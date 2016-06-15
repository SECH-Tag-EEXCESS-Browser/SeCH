//
//  SechTableDataSource.swift
//  Browser
//
//  Created by Brian Mairhörmann on 18.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
// This is the Datasource for the tableView in the main-view, which displays the title of the loaded search-tags. At the top the class-variables are
// listed and below that tableview-datasource-specific, such as numberOfRowsInSection, are collected. At the bottom of this class other methods, that do
// not fall in the categories above, are listed.

import Foundation
import UIKit

class SechTableDataSource: NSObject, UITableViewDataSource{
    
    //#########################################################################################################################################
    //##########################################################___Class_Variables___##########################################################
    //#########################################################################################################################################
    
    var sechTags = [SEARCHModel]()
    
    
    
    //#########################################################################################################################################
    //##########################################################___TableView_Datasource_Methods___#############################################
    //#########################################################################################################################################
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sechTags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SechCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabel!.text = sechTags[indexPath.row].title
        
        return cell
    }

    //#########################################################################################################################################
    //##########################################################___Other_Methods___############################################################
    //#########################################################################################################################################
    
    func appendModels(searchModels : [SEARCHModel]) {
        emptyTable()
        
        for searchModel in searchModels{
            if !containValue(searchModel){
                sechTags.append(searchModel)
            }
        }
    }
    
    private func containValue(value:SEARCHModel)->Bool{
        return sechTags.contains(value)
    }
    
    func emptyTable() {
        sechTags.removeAll()
    }
}