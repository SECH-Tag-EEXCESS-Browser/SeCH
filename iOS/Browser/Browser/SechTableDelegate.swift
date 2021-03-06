//
//  SechTableDelegate.swift
//  Browser
//
//  Created by Burak Erol on 31.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation
import UIKit

class SechTableViewDelegate: NSObject, UITableViewDelegate{
    
    
    //#########################################################################################################################################
    //##########################################################___Class_Variables___##########################################################
    //#########################################################################################################################################
    
    internal var viewCtrl: ViewController!
    
    //#########################################################################################################################################
    //##########################################################___TableView_Delegate_Methods___###############################################
    //#########################################################################################################################################
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewCtrl.hideAndOpenSechTableView()
        viewCtrl.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    
        viewCtrl.indexPathForSelectedSearchTag = indexPath.row
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        viewCtrl.headLine = (currentCell.textLabel?.text!)! as String
        print("\n\n\n\n\n\n\n")
        print("selected: "+viewCtrl.headLine)
    
    let searchModel = viewCtrl.searchModelsOfCurrentPage?.getSearchModels()[indexPath.row]
    viewCtrl.currentSearchModel = searchModel
    
    return indexPath
    }
}