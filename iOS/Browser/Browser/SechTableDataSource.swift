//
//  SechTableDataSource.swift
//  Browser
//
//  Created by Brian Mairhörmann on 18.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation
import UIKit

class SechTableDataSource : NSObject, UITableViewDataSource{
    
    var sechTags = ["Teststring"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sechTags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SechCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = sechTags[indexPath.row]
        
        
        return cell
    }
    
    func makeLabels(sechs : [SEARCHModel]){
        
        sechTags = []
        
        for item in sechs{
            sechTags.append(item.id)
        }
        
        
    }
}