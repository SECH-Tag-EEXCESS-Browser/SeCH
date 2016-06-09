//
//  FavTableDelegate.swift
//  Browser
//
//  Created by Burak Erol on 31.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation
import UIKit

class FavTableViewDelegate: NSObject, UITableViewDelegate{
    
    var favourites = [FavouritesModel]()
    var p = FavDataObjectPersistency()
    
    internal var viewCtrl: ViewController!
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        favourites = p.loadDataObject()
        let url = favourites[indexPath.row].url
        viewCtrl.loadURL(url)
    }

func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
{
    //Load PersistencyModel
    favourites = p.loadDataObject()
    
    let editAction = UITableViewRowAction(style: .Normal, title: "Bearbeiten")
    { (action, indexPath)-> Void in
        
        let alertSheetController = UIAlertController(title: "Favoriten bearbeiten", message: "Geben Sie den Titel ein", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
        {
            action-> Void in
            print("Cancel")
        }
        
        alertSheetController.addAction(cancelAction)
        
        let enterAction = UIAlertAction(title: "Enter", style: .Default)
        {
            action-> Void in
            
            let textfieldTitel : UITextField = alertSheetController.textFields![0]
            let title = textfieldTitel.text!
            
            let textfieldURL : UITextField = alertSheetController.textFields![1]
            let url = textfieldURL.text!
            
            self.favourites[indexPath.row].title = title
            self.favourites[indexPath.row].url = url
            
            self.p.saveDataObject(self.favourites)
            
            self.viewCtrl.favTableView.reloadData()
        }
        
        alertSheetController.addAction(enterAction)
        
        alertSheetController.addTextFieldWithConfigurationHandler
            {
                textField -> Void in
                textField.text = self.favourites[indexPath.row].title
        }
        
        alertSheetController.addTextFieldWithConfigurationHandler
            {
                textField -> Void in
                textField.text = self.favourites[indexPath.row].url
        }
        
        self.viewCtrl.presentViewController(alertSheetController, animated: true) {}
    }
    
    editAction.backgroundColor = UIColor.greenColor()
    
    let deleteAction = UITableViewRowAction(style: .Normal, title: "Löschen")
    { (action, indexPath)-> Void in
        
        self.favourites.removeAtIndex(indexPath.row)
        self.p.saveDataObject(self.favourites)
        //Dont work
        self.viewCtrl.favTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.viewCtrl.favTableView.reloadData()
    }
    
    deleteAction.backgroundColor = UIColor.redColor()
    
    return [editAction, deleteAction]
}
}