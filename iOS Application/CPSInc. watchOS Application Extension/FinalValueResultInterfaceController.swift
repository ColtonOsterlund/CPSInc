//
//  FinalValueResultInterfaceController.swift
//  CPSInc. watchOS Application Extension
//
//  Created by Colton on 2019-06-07.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

public class FinalValueResultInterfaceController: WKInterfaceController, WKCrownDelegate, WCSessionDelegate{
    
    private var mainIC: MainInterfaceController? = nil
    private var session: WCSession? = nil
    
    
    @IBOutlet weak var optionsPicker: WKInterfacePicker!
    private var optionsPickerData = [WKPickerItem]()
    private var optionsPickerIndex: Int = 0
    
    @IBOutlet weak var finalValueResultLabel: WKInterfaceLabel!
    
    
    @IBAction func optionsPickerChangedValue(_ value: Int) {
        optionsPickerIndex = value
    }
    
    public override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if(optionsPickerIndex == 0){
            //do nothing
        }
        else if(optionsPickerIndex == 1){
            //reset test
            popToRootController() //resets the test in willDissapear
        }
        else{
            if(session!.isReachable){
                do{
                    try session?.updateApplicationContext(["SaveTest":"SaveTest"])
                }catch{
                    print("Error while sending application context")
                }
                
                let action = WKAlertAction.init(title: "Dismiss", style:.default) {
                    self.popToRootController()
                }
                
                presentAlert(withTitle: "Save Test", message: "Please See iPhone to Save Test", preferredStyle:.actionSheet, actions: [action])
            }
        }
    }
    
    public override func willDisappear() {
        if(session!.isReachable){
            do{
                try session?.updateApplicationContext(["ResetTest":"ResetTest"])
            }catch{
                print("Error while sending application context")
            }
        }
        
        optionsPicker.setHidden(true)
        optionsPicker.resignFocus()
        finalValueResultLabel.setTextColor(.white)
        finalValueResultLabel.setText("Test in Progress...")
    }
    
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //fill out
    }
    
    
    override public func awake(withContext context: Any?) { //called to setup any relevant contextual data from a previous interface controller. Use this method to finish the initialization of your interface.
        super.awake(withContext: context)
        
    }
    
    override public func willActivate() { //equivalent of viewDidLoad
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        if WCSession.isSupported() {
            session = WCSession.default
            session!.delegate = self
            session!.activate()
            
            print("wcSession has been activated on iWatch - FinalValueResultInterfaceController")
        }
        
        setupItems()
    }
    
    private func setupItems(){
        optionsPicker.setHidden(true)
        //optionsPicker.resignFocus()
        optionsPickerData.removeAll()
        
        let nothingItem = WKPickerItem()
        nothingItem.title = "Select Option"
        optionsPickerData.append(nothingItem)
        
        let resetItem = WKPickerItem()
        resetItem.title = "Discard"
        optionsPickerData.append(resetItem)
        
        let saveItem = WKPickerItem()
        saveItem.title = "Save"
        optionsPickerData.append(saveItem)
        
        optionsPicker.setItems(optionsPickerData)
        optionsPicker.focus()
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if(applicationContext["FinalValueTestResult"] != nil){
            if((applicationContext["FinalValueTestResult"] as! Float) < 3.0){
                finalValueResultLabel.setTextColor(.red)
            }
            else if((applicationContext["FinalValueTestResult"] as! Float) >= 3.0 && (applicationContext["FinalValueTestResult"] as! Float) < 4.0){
                finalValueResultLabel.setTextColor(.yellow)
            }
            else if((applicationContext["FinalValueTestResult"] as! Float) >= 4.0 && (applicationContext["FinalValueTestResult"] as! Float) < 8.0){
                finalValueResultLabel.setTextColor(.green)
            }
            else if((applicationContext["FinalValueTestResult"] as! Float) >= 8.0 && (applicationContext["FinalValueTestResult"] as! Float) < 12.0){
                finalValueResultLabel.setTextColor(.yellow)
            }
            else{
                finalValueResultLabel.setTextColor(.red)
            }
            
            finalValueResultLabel.setText(String(applicationContext["FinalValueTestResult"] as! Float) + "mmol/L")
            
            optionsPicker.setHidden(false)
            //optionsPicker.focus()
        }
        else if(applicationContext["ContinuousValueFinalTestResult"] != nil){
            if((applicationContext["ContinuousValueFinalTestResult"] as! Float) < 3.0){
                finalValueResultLabel.setTextColor(.red)
            }
            else if((applicationContext["ContinuousValueFinalTestResult"] as! Float) >= 3.0 && (applicationContext["ContinuousValueFinalTestResult"] as! Float) < 4.0){
                finalValueResultLabel.setTextColor(.yellow)
            }
            else if((applicationContext["ContinuousValueFinalTestResult"] as! Float) >= 4.0 && (applicationContext["ContinuousValueFinalTestResult"] as! Float) < 8.0){
                finalValueResultLabel.setTextColor(.green)
            }
            else if((applicationContext["ContinuousValueFinalTestResult"] as! Float) >= 8.0 && (applicationContext["ContinuousValueFinalTestResult"] as! Float) < 12.0){
                finalValueResultLabel.setTextColor(.yellow)
            }
            else{
                finalValueResultLabel.setTextColor(.red)
            }
            
            finalValueResultLabel.setText(String(applicationContext["ContinuousValueFinalTestResult"] as! Float) + "mmol/L")
            
            optionsPicker.setHidden(false)
            //optionsPicker.focus()
        }
    }
}
