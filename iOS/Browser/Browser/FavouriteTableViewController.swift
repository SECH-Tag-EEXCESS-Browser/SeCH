//
//  FavouriteTableViewController.swift
//  Browser
//
//  Created by Patrick Büttner on 01.11.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import UIKit

protocol BackDelegate
{
    func receiveInfo(ctrl: FavouriteTableViewController, info: FavouritesModel)
}

class FavouriteTableViewController: UITableViewController
{
    var favourites = [FavouritesModel]()
    let fav = FavouritesModel()
    var delegate : BackDelegate?//Wird nicht verwendet!
    let p = DataObjectPersistency()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return favourites.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavouriteCell", forIndexPath: indexPath) as! FavouriteCell
        
        cell.lblTitle.text = "Titel: \(favourites[indexPath.row].title)"
        cell.lblUrl.text = "URL: \(favourites[indexPath.row].url)"
    
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(delegate != nil)
        {
            fav.url = favourites[indexPath.row].url
            favourites.append(fav)
            
            delegate!.receiveInfo(self, info: fav)
            
//            print(fav)
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let editAction = UITableViewRowAction(style: .Normal, title: "Bearbeiten")
            { (action, indexPath)-> Void in
                
                //self.performSegueWithIdentifier("editFavouriteName", sender: self)
                
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
                        
                        let textfield : UITextField = alertSheetController.textFields![0]
                        
                        //var title = self.favourites[indexPath.row].title
                        let title = textfield.text!
                        self.fav.title = title
                        self.favourites[indexPath.row].title = title
                        
                        self.p.saveDataObject(self.favourites)
                        
                        tableView.reloadData()
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
                
                self.presentViewController(alertSheetController, animated: true) {}
        }
        
        editAction.backgroundColor = UIColor.greenColor()
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Löschen")
            { (action, indexPath)-> Void in
                
                self.favourites.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                self.p.saveDataObject(self.favourites)
        }
        
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [editAction, deleteAction]
    }

    
}
