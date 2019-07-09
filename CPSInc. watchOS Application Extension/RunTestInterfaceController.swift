//
//  RunTestInterfaceController.swift
//  CPSInc. watchOS Application Extension
//
//  Created by Colton on 2019-06-07.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

public class RunTestInterfaceController: WKInterfaceController, WKCrownDelegate, WCSessionDelegate{
    
    private var mainIC: MainInterfaceController? = nil
    private var session: WCSession? = nil
    
    
    private var backToMain: Bool = true
    
    
    
    @IBOutlet weak var optionsPicker: WKInterfacePicker!
    private var optionsPickerData = [WKPickerItem]()
    private var optionsPickerIndex: Int = 0
    
    
    @IBOutlet weak var connectedDeviceLabel: WKInterfaceLabel!
    
    @IBOutlet weak var finalVsContLabel: WKInterfaceLabel!
    
    @IBOutlet weak var testDurationLabel: WKInterfaceLabel!
    
    @IBOutlet weak var testTypeLabel: WKInterfaceLabel!
    
    
    
    @IBAction func optionsPickerValueChanged(_ value: Int) {
        optionsPickerIndex = value
    }
    
    public override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if(optionsPickerIndex == 1){
            session?.sendMessage(["Msg":"RunTestPrompt"], replyHandler: nil, errorHandler: nil)
        }
        else{
            popToRootController()
        }
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
            
                print("wcSession has been activated on iWatch - RunTestInterfaceController")
            }
        
        
        //connectedDeviceLabel.setText(mainIC?.getRunTestIC().getConnectedDeviceLabel()) - i would do it this way but you cannot retrieve the text from WKInterfaceLabels
        
        setupItems()
        
    }
    
    
    private func setupItems(){
        optionsPickerData.removeAll()
        
        let nothingOption = WKPickerItem()
        nothingOption.title = "Select Option"
        optionsPickerData.append(nothingOption)
        
        let startTestOption = WKPickerItem()
        startTestOption.title = "Start Test"
        optionsPickerData.append(startTestOption)
        
        let backOption = WKPickerItem()
        backOption.title = "Back to Main"
        optionsPickerData.append(backOption)
        
        optionsPicker.setItems(optionsPickerData)
        optionsPicker.focus()
    }
    
    
    public override func willDisappear() {
        if(backToMain == true){
            if(session!.isReachable){
                do{
                    try session!.updateApplicationContext(["ChangeScreens": "Main"])
                }catch{
                    print("Error sending application context")
                }
            }
        }
        
        backToMain = true
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if(applicationContext["TestTypeLabelRunTest"] != nil){
            DispatchQueue.main.async {
                self.finalVsContLabel.setText(applicationContext["TestTypeLabelRunTest"] as? String)
            }
        }
        else if(applicationContext["TestDurationLabelRunTest"] != nil){
            DispatchQueue.main.async {
                self.testDurationLabel.setText(applicationContext["TestDurationLabelRunTest"] as? String)
            }
        }
        else if(applicationContext["TestSampleLabelRunTest"] != nil){
            DispatchQueue.main.async {
                self.testTypeLabel.setText(applicationContext["TestSampleLabelRunTest"] as? String)
            }
        }
        else if(applicationContext["BeganRunningTest"] != nil){
            DispatchQueue.main.async {
                if(applicationContext["BeganRunningTest"] as? String == "FinalValue"){
                    self.backToMain = false
                    self.pushController(withName: "FinalValueResultInterfaceController", context: nil)
                }
                else{
                    self.backToMain = false
                    self.pushController(withName: "ContinuousValueResultInterfaceController", context: nil)
                }
            }
        }
    }
    
    //getters/setters
    
    public func setConnectedDevicesLabel(label: String!){
        connectedDeviceLabel.setText(label)
    }
    
    public func setFinalVsContLabel(label: String!){
        finalVsContLabel.setText(label)
    }
    
    public func settestDurationLabel(label: String!){
        testDurationLabel.setText(label)
    }
    
    public func setTestTypeLabel(label: String!){
        testTypeLabel.setText(label)
    }
    
}
