//
//  LogbookInterfaceController.swift
//  CPSInc. watchOS Application Extension
//
//  Created by Colton on 2019-06-26.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS WKINTERFACECONTROLLER DEALS WITH THE LOGBOOK SCREEN OF THE WATCH APP

import Foundation
import WatchKit
import WatchConnectivity

public class LogbookInterfaceController: WKInterfaceController, WKCrownDelegate, WCSessionDelegate{
    
    private var mainIC: MainInterfaceController? = nil
    private var session: WCSession? = nil

    
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
            
            print("wcSession has been activated on iWatch - LogbookInterfaceController")
        }
        
        let action = WKAlertAction.init(title: "Dismiss", style:.default) {
            if(self.session!.isReachable){
                do{
                    try self.session!.updateApplicationContext(["ChangeScreens": "Main"])
                }catch{
                    print("Error sending application context")
                }
            }
            self.popToRootController()

        }
        
        presentAlert(withTitle: "Logbook", message: "Please See iPhone to View Logbook Data", preferredStyle:.actionSheet, actions: [action])
        
    }
    
    
    public override func willDisappear() { //cannot do this because this will be activated when the alert is presented
        //        if(session!.isReachable){
        //            do{
        //                try session!.updateApplicationContext(["ChangeScreens": "Main"])
        //            }catch{
        //                print("Error sending application context")
        //            }
        //        }
    }
    
    
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //fill out
    }
    

}
