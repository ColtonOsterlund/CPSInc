//
//  SettingsInterfaceController.swift
//  CPSInc. watchOS Application Extension
//
//  Created by Colton on 2019-06-07.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS WKINTERFACECONTROLLER DEALS WITH THE SETTINGS SCREEN OF THE WATCH APP

import WatchKit
import Foundation
import WatchConnectivity

public class SettingsInterfaceController: WKInterfaceController, WKCrownDelegate, WCSessionDelegate{
    
    private var mainIC: MainInterfaceController? = nil
    private var session: WCSession? = nil
    
    
    
    @IBOutlet weak var finalVsContPicker: WKInterfacePicker!
    var finalVsContPickerData = [WKPickerItem]()
    var finalVsContPickerIndex = 0
    
    @IBOutlet weak var testDurationPicker: WKInterfacePicker!
    var testDurationPickerData = [WKPickerItem]()
    var testDurationPickerIndex = 0
    
    @IBOutlet weak var testTypePicker: WKInterfacePicker!
    var testTypePickerData = [WKPickerItem]()
    var testTypePickerIndex = 0
    
    
    @IBAction func finalVsContPickerChanged(_ value: Int) { //wait until picker settles to send to the phone
//        if(session!.isReachable){
//            do{
//                try session?.updateApplicationContext(["FinalContSettingsUpdate":value - 1]) // -1 to take away the "Select Option" index
//            }catch{
//                print("Error while sending application context")
//            }
//        }
        
        finalVsContPickerIndex = value
        
    }
    
    @IBAction func testDurationPickerChanged(_ value: Int) { //wait until picker settles to send to the phone
//        if(session!.isReachable){
//            do{
//                try session?.updateApplicationContext(["TestDurationSettingsUpdate":value - 1]) // -1 to take away the "Select Option" index
//            }catch{
//                print("Error while sending application context")
//            }
//        }
        
        testDurationPickerIndex = value
        
    }
    
    @IBAction func testTypePickerChanged(_ value: Int) { //this should only send when the picker settes
//        if(session!.isReachable){
//            do{
//                try session?.updateApplicationContext(["TestTypeSettingsUpdate":value - 1]) // -1 to take away the "Select Option" index
//            }catch{
//                print("Error while sending application context")
//            }
//        }
        testTypePickerIndex = value
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
            
            print("wcSession has been activated on iWatch - SettingsInterfaceController")
        }
        
        
        setupLayoutItems()
    }
    
    private func setupLayoutItems(){
        finalVsContPickerData.removeAll()
        testDurationPickerData.removeAll()
        testTypePickerData.removeAll()
        
        let nothingItem1 = WKPickerItem()
        nothingItem1.title = "Select Option"
        finalVsContPickerData.append(nothingItem1)
        let finalItem = WKPickerItem()
        finalItem.title = "Final"
        finalVsContPickerData.append(finalItem)
        let contItem = WKPickerItem()
        contItem.title = "Continuous"
        finalVsContPickerData.append(contItem)
        
        finalVsContPicker.setItems(finalVsContPickerData)
        finalVsContPicker.focus()
        
        let nothingItem2 = WKPickerItem()
        nothingItem2.title = "Select Option"
        testDurationPickerData.append(nothingItem2)
        let fiveSecItem = WKPickerItem()
        fiveSecItem.title = "5 Seconds"
        testDurationPickerData.append(fiveSecItem)
        let tenSecItem = WKPickerItem()
        tenSecItem.title = "10 Seconds"
        testDurationPickerData.append(tenSecItem)
        let fifteenSecItem = WKPickerItem()
        fifteenSecItem.title = "15 Seconds"
        testDurationPickerData.append(fifteenSecItem)
        let twentySecItem = WKPickerItem()
        twentySecItem.title = "20 Seconds"
        testDurationPickerData.append(twentySecItem)
        
        testDurationPicker.setItems(testDurationPickerData)
        
        let nothingItem3 = WKPickerItem()
        nothingItem3.title = "Select Option"
        testTypePickerData.append(nothingItem3)
        let immunoItem = WKPickerItem()
        immunoItem.title = "Immunoglobulins"
        testTypePickerData.append(immunoItem)
        let lactoItem = WKPickerItem()
        lactoItem.title = "Lactoferrin"
        testTypePickerData.append(lactoItem)
        let calcItem = WKPickerItem()
        calcItem.title = "Blood Calcium"
        testTypePickerData.append(calcItem)
        let glucItem = WKPickerItem()
        glucItem.title = "Glucose"
        testTypePickerData.append(glucItem)
        
        testTypePicker.setItems(testTypePickerData)
    }
    
    public override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if(picker == finalVsContPicker){
            
            if(session!.isReachable){
                do{
                    try session?.updateApplicationContext(["FinalContSettingsUpdate":finalVsContPickerIndex - 1]) // -1 to take away the "Select Option" index
                }catch{
                    print("Error while sending application context")
                }
            }
            
            finalVsContPicker.resignFocus()
            testDurationPicker.focus()
        }
        else if(picker == testDurationPicker){
            
            if(session!.isReachable){
                do{
                    try session?.updateApplicationContext(["TestDurationSettingsUpdate":testDurationPickerIndex - 1]) // -1 to take away the "Select Option" index
                }catch{
                    print("Error while sending application context")
                }
            }
            
            testDurationPicker.resignFocus()
            testTypePicker.focus()
        }
        else{
            
            if(session!.isReachable){
                do{
                    try session?.updateApplicationContext(["TestTypeSettingsUpdate":testTypePickerIndex - 1]) // -1 to take away the "Select Option" index
                }catch{
                    print("Error while sending application context")
                }
            }
            
            testTypePicker.resignFocus()
            popToRootController()
        }
    }
    
    public override func willDisappear() {
        if(session!.isReachable){
            do{ 
                try session!.updateApplicationContext(["ChangeScreens": "Main"])
            }catch{
                print("Error sending application context")
            }
        }
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if(applicationContext["FinalContSettingsUpdate"] != nil){
            DispatchQueue.main.async {
                self.finalVsContPicker.setSelectedItemIndex(applicationContext["FinalContSettingsUpdate"] as! Int)
            }
        }
        
        else if(applicationContext["TestDurationSettingsUpdate"] != nil){
            DispatchQueue.main.async {
                self.testDurationPicker.setSelectedItemIndex(applicationContext["TestDurationSettingsUpdate"] as! Int)
            }
        }
        
        else if(applicationContext["TestTypeSettingsUpdate"] != nil){
            DispatchQueue.main.async {
                self.testTypePicker.setSelectedItemIndex(applicationContext["TestTypeSettingsUpdate"] as! Int)
            }
        }
    }
    
    
}
