//
//  PreferenceController.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Cocoa

class PreferenceController: NSViewController {


    @IBOutlet weak var baseURL: NSTextField!
    @IBOutlet weak var ageMatrix: NSMatrix!
    @IBOutlet weak var genderMatrix: NSMatrix!
    @IBOutlet weak var cntSlider: NSSlider!
    @IBOutlet weak var cntValue: NSTextField!

    @IBAction func sliding(sender: NSSlider) {
        cntValue.stringValue = String(sender.integerValue)
    }
    
    @IBAction func savePressed(sender: NSButton) {
        let ageIndex = ageMatrix.selectedColumn
        let genderIndex = genderMatrix.selectedColumn
        let url = baseURL.stringValue;
        let cnt = cntValue.integerValue
        
        let prefs = Preferences()

        prefs.age = ageIndex
        prefs.gender = genderIndex
        prefs.url = url
        prefs.numResults = cnt
        
        self.dismissViewController(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = Preferences()
        
        let age = prefs.age
        let gender = prefs.gender
        let url = prefs.url
        let cnt = prefs.numResults
        
        baseURL.stringValue = url
        genderMatrix.selectCellAtRow(0, column: gender)
        ageMatrix.selectCellAtRow(0, column: age)
        cntValue.integerValue = cnt
        cntSlider.integerValue = cnt
    }
    
}
