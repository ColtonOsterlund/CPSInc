//
//  InterfaceController.swift
//  CPSInc. watchOS Application Extension
//
//  Created by Colton on 2019-05-30.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

public class MainInterfaceController: WKInterfaceController, WKCrownDelegate, WCSessionDelegate{
    
    private let findDeviceIC = FindDeviceInterfaceController()
    private let runTestIC = RunTestInterfaceController()
    private let settingsIC = SettingsInterfaceController()
    private let finalValIC = FinalValueResultInterfaceController()
    
    private var session: WCSession? = nil
    
    private var nextUp: Int! = 0
    
    @IBOutlet private weak var optionsPicker: WKInterfacePicker!
    private var pickerData = [WKPickerItem]()
    
    
    
//    @IBOutlet weak var selectBtn: WKInterfaceButton!
    
    
    @IBAction func optionsPickerDidChangeIndex(_ value: Int) {
        nextUp = value
    }
    
//    @IBAction func selectBtnPressed() {
//        if(nextUp == 0){
//            //do nothing
//        }
//        else if(nextUp == 1){
//            if(session!.isReachable){
//                do{
//                    try session!.updateApplicationContext(["ChangeScreens": "FindDevice"])
//                }catch{
//                    print("Error sending application context")
//                }
//            }
//
//            pushController(withName: "FindDeviceInterfaceController", context: nil)
//        }
//        else if(nextUp == 2){
//            if(session!.isReachable){
//                do{
//                    try session!.updateApplicationContext(["ChangeScreens": "RunTest"])
//                }catch{
//                    print("Error sending application context")
//                }
//            }
//
//            pushController(withName: "RunTestInterfaceController", context: nil)
//        }
//        else{
//            if(session!.isReachable){
//                do{
//                    try session!.updateApplicationContext(["ChangeScreens": "Settings"])
//                }catch{
//                    print("Error sending application context")
//                }
//            }
//
//            pushController(withName: "SettingsInterfaceController", context: nil)
//        }
//    }
    
    public override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if(nextUp == 0){
            //do nothing
        }
        if(nextUp == 1){
            if(session!.isReachable){
                do{
                    try session!.updateApplicationContext(["ChangeScreens": "FindDevice"])
                }catch{
                    print("Error sending application context")
                }
            }
            
            pushController(withName: "FindDeviceInterfaceController", context: nil)
        }
        else if(nextUp == 2){
            if(session!.isReachable){
                do{
                    try session!.updateApplicationContext(["ChangeScreens": "RunTest"])
                }catch{
                    print("Error sending application context")
                }
            }
            
            pushController(withName: "RunTestInterfaceController", context: nil)
        }
        else if(nextUp == 3){
            if(session!.isReachable){
                do{
                    try session!.updateApplicationContext(["ChangeScreens": "Settings"])
                }catch{
                    print("Error sending application context")
                }
            }
            
            pushController(withName: "SettingsInterfaceController", context: nil)
        }
        else if(nextUp == 4){
            if(session!.isReachable){
                do{
                    try session!.updateApplicationContext(["ChangeScreens": "Logbook"])
                }catch{
                    print("Error sending application context")
                }
            }
            
            pushController(withName: "LogbookInterfaceController", context: nil)
        }
        else if(nextUp == 5){
            if(session!.isReachable){
                do{
                    try session!.updateApplicationContext(["ChangeScreens": "Account"])
                }catch{
                    print("Error sending application context")
                }
            }
            
            pushController(withName: "AccountInterfaceController", context: nil)
        }
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
                //print("wcSession has been activated on iWatch - MainInterfaceController")
            }
        
        
        nextUp = 0 //reset nextUp everytime the view loads
        setupLayoutItems()
    }
    
    public override func willDisappear() {
        
    }
    
    private func setupLayoutItems(){
        pickerData.removeAll() //clear at the start
        
        let nothingItem = WKPickerItem()
        nothingItem.title = "Select Option"
        pickerData.append(nothingItem)
        let connectItem = WKPickerItem()
        connectItem.title = "Find Device"
        pickerData.append(connectItem)
        let testItem = WKPickerItem()
        testItem.title = "Run Test"
        pickerData.append(testItem)
        let settingsItem = WKPickerItem()
        settingsItem.title = "Settings"
        pickerData.append(settingsItem)
        let logbookItem = WKPickerItem()
        logbookItem.title = "Logbook"
        pickerData.append(logbookItem)
        let accountItem = WKPickerItem()
        accountItem.title = "Account"
        pickerData.append(accountItem)
        
        optionsPicker.setItems(pickerData)
        optionsPicker.setSelectedItemIndex(0)
        optionsPicker.focus()
        
        
    }
    
    
    override public func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("session did deactivate on iWatch")
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //fill out
        //print("SESSION DID COMPLETE ACTIVATION")
        //session.sendMessage(["Message" : "FIND DEVICE BUTTON WAS PRESSED"], replyHandler: nil, errorHandler: nil)

    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    
    }
    
    private func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
    }
    
    //getters/setters
    
    public func getFindDeviceIC() -> FindDeviceInterfaceController{
        return findDeviceIC
    }
    
    public func getRunTestIC() -> RunTestInterfaceController{
        return runTestIC
    }
    
    public func getSettingsIC() -> SettingsInterfaceController{
        return settingsIC
    }

}
