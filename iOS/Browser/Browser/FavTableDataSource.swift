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
        
        cell.backgroundColor = UIColor.clearColor()
                
        cell.favTitle.text = favourites[indexPath.row].title
        
        return cell
    }
}