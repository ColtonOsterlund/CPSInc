//
//  FindDeviceInterfaceController.swift
//  CPSInc. watchOS Application Extension
//
//  Created by Colton on 2019-06-07.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreBluetooth

public class FindDeviceInterfaceController: WKInterfaceController, WKCrownDelegate, WCSessionDelegate{

    private var mainIC: MainInterfaceController? = nil
    private var session: WCSession? = nil
    
    
    @IBOutlet weak var optionsPicker: WKInterfacePicker!
     private var optionsPickerData = [WKPickerItem]()
    private var optionsPickerIndex: Int = 0
    
    
    @IBOutlet weak var deviceNamePicker: WKInterfacePicker!
    var deviceNamePickerData = [WKPickerItem]()
    
    @IBOutlet weak var connectedDeviceLabel: WKInterfaceLabel!
    
    
    
    
    @IBAction func optionsPickerValueChanged(_ value: Int) {
        optionsPickerIndex = value
    }
    
    
    
    public override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if(picker == optionsPicker){
            if(optionsPickerIndex == 0){
                //do nothing
            }
            else if(optionsPickerIndex == 1){
                //search
                if(session!.isReachable){
                    do{
                        try session!.updateApplicationContext(["Search": "Search"])
                    }catch{
                        print("Error sending application context")
                    }
                }
            }
            else if(optionsPickerIndex == 2){
                //connect
                if(session!.isReachable){
                    do{
                        try session!.updateApplicationContext(["Connect": "Connect"])
                    }catch{
                        print("Error sending application context")
                    }
                }
                
                //popToRootController() - instead do this when connectedLabel changes
            }
            else if(optionsPickerIndex == 3){
                //disconnect
                if(session!.isReachable){
                    do{ 
                        try session!.updateApplicationContext(["Disconnect": "Disconnect"])
                    }catch{
                        print("Error sending application context")
                    }
                }
                
                //popToRootController()
            }
            else{
                popToRootController()
            }
        }
    }
    
    
    
    
    
    @IBAction func deviceNamePickerChanged(_ value: Int) {
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
            
                print("wcSession has been activated on iWatch - FindDeviceInterfaceController")
            }
        
        
        
        
       setupItems()
        
    }
    
    
    private func setupItems(){
        optionsPickerData.removeAll()
        
        let nothingOption = WKPickerItem()
        nothingOption.title = "Select Option"
        optionsPickerData.append(nothingOption)
        
        let searchOption = WKPickerItem()
        searchOption.title = "Search"
        optionsPickerData.append(searchOption)
        
        let connectOption = WKPickerItem()
        connectOption.title = "Connect"
        optionsPickerData.append(connectOption)
        
        let disconnectOption = WKPickerItem()
        disconnectOption.title = "Disconnect"
        optionsPickerData.append(disconnectOption)
        
        let backOption = WKPickerItem()
        backOption.title = "Back to Main"
        optionsPickerData.append(backOption)
        
        optionsPicker.setItems(optionsPickerData)
        optionsPicker.focus()
    }
    
    
    public override func willDisappear() {
        if(session!.isReachable){
            do{ //one of the dumbest things ive ever seen for error checking, good job apple
                try session!.updateApplicationContext(["ChangeScreens": "Main"])
            }catch{
                print("Error sending application context")
            }
        }
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //fill out
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if(applicationContext["ConnectedDeviceLabelFindDevice"] != nil){
            DispatchQueue.main.async {
               self.connectedDeviceLabel.setText(applicationContext["ConnectedDeviceLabelFindDevice"] as? String)
                self.mainIC?.getRunTestIC().setConnectedDevicesLabel(label: applicationContext["ConnectedDeviceLabelFindDevice"] as? String)
                
                //self.popToRootController() happens too fast here
            }
            
            //popToRootController() happens too fast here
        }
        
    }
    
    
    //getters/setters
    public func getConnectedDeviceLabel() -> String{
        //apparently you cannot yet retrieve the text from WKInterfaceLabels... cmon apple
        return "Error - see calling function"
    }
}
