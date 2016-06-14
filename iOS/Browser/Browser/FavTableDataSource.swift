//
//  FavTableDataSource.swift
//  Browser
//
//  Created by Burak Erol on 31.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation
import UIKit

class FavTableDataSource: NSObject, UITableViewDataSource{
    
    var favourites = [FavouritesModel]()
    let favPersistency = FavDataObjectPersistency()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        favourites = favPersistency.loadDataObject()
        
        return favourites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCellWithIdentifier("FavouriteCell", forIndexPath: indexPath) as! FavouriteCell
                
        cell.favTitle.text = favourites[indexPath.row].title
        
        cell.backgroundColor = UIColorFromHex(0xFF9500, alpha:0.5)
        tableView.backgroundColor = UIColorFromHex(0xFF9500, alpha:0.1)
        
        return cell
    }
    
    //Convert HEX in RGB
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}