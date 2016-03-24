//
//  recommendationDataSource.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Cocoa

class RecommendationDataSource : NSObject, NSTableViewDataSource
{
    var data : [EEXCESSRecommendation] = []
    var ready = false
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {

        return data.count
    }
    
    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        
        data = ((data as NSArray).sortedArrayUsingDescriptors(tableView.sortDescriptors)) as! [EEXCESSRecommendation]
        tableView.reloadData()
    }
    
}