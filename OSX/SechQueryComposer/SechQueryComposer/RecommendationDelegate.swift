//
//  RecommendationDelegate.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Cocoa

class RecommendationDelegate: NSObject, NSTableViewDelegate {

    var viewCtrl : ViewController!
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        let dataSource = tableView.dataSource() as! RecommendationDataSource
        
        if tableColumn!.identifier == "Provider" {
            // 3
            cellView.textField!.stringValue = dataSource.data[row].provider
            return cellView
        }
        cellView.textField!.stringValue = dataSource.data[row].title
        return cellView
        
    }
    
    func tableView(tableView: NSTableView,
        shouldSelectRow row: Int) -> Bool
    {
        return true
    }

}
