//
//  ViewController.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {


    @IBOutlet weak var recommendButton: NSButton!
    @IBOutlet weak var resultTable: NSTableView!
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var kw00: NSTextField!

    
    var isMainWidth = CGFloat(0.0)
    var recommendCTRL : RecommendationCTRL!
    var selectedRow = 0

    // ################################
    

    @IBAction func searchPressed(sender: NSButton) {
        
        let recData : ([String], Int?)
        
        sender.enabled = false
        progress.startAnimation(self)
        
        recData = createRecommendInfo()
        recommendCTRL.getRecommendsForKeyWords(recData, dataSource: resultTable.dataSource() as! RecommendationDataSource){() -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.resultTable.reloadData()
                
                self.recommendButton.enabled = true
                self.progress.stopAnimation(self)
                self.resultTable.enabled = true
                
            })}
    }
    
    private func createRecommendInfo() -> ([String], Int?)
    {
        var keyWords : [String] = []
        let content = kw00.stringValue
        
        keyWords = content.componentsSeparatedByString(" ")
        
        return (keyWords, 0)
    }
    
    // ################################

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle sorting
        let descriptorTitle = NSSortDescriptor(key: "title", ascending: true)
        let descriptorProvider = NSSortDescriptor(key: "provider", ascending: true)
        
        resultTable.tableColumns[0].sortDescriptorPrototype = descriptorProvider
        resultTable.tableColumns[1].sortDescriptorPrototype = descriptorTitle
        
        kw00.enabled =  true
        kw00.selectable = true
        kw00.delegate = self
        
        let dele = resultTable.delegate() as! RecommendationDelegate
        dele.viewCtrl = self
        resultTable.enabled = false
        resultTable.doubleAction = #selector(ViewController.performSegue(_:))
        // Create the CTRLs
        recommendCTRL = RecommendationCTRL()
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func performSegue(table : NSTableView)
    {
        let ds = resultTable.dataSource() as! RecommendationDataSource
        selectedRow = table.selectedRow
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: ds.data[selectedRow].uri)!)

        
        //performSegueWithIdentifier("toWebView", sender: self)
    }
    

    
    // Delegates fur Textfields

    override func controlTextDidEndEditing(obj: NSNotification) {
            }
    override func controlTextDidChange(notification: NSNotification)
    {
    }
    
}

