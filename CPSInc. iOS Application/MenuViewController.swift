//
//  MenuView.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-05-24.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import CoreBluetooth
import WatchConnectivity

public class MenuViewController: UIViewController, CBCentralManagerDelegate, WCSessionDelegate{
    
    //Views
    private var connectView: ConnectViewController? = nil
    private var testView: TestViewController? = nil
    private var settingsView: SettingsViewController? = nil
    private var logbookView: HerdLogbookViewController? = nil
    private var appDelegate: AppDelegate? = nil
    
    //UIButtons
    private let findDeviceBtn = UIButton()
    private let testBtn = UIButton()
    private let settingsBtn = UIButton()
    private let logbookBtn = UIButton()
    
    //UIImages
    private let findDeviceBtnImage = UIImage(named: "device")
    private let testBtnImage = UIImage(named: "bloodDropCartoonImage")
    private let settingsBtnImage = UIImage(named: "settingsWheel")
    private let logbookBtnImage = UIImage(named: "logbook")
    
    //UILabels
    private let findDeviceLabel = UILabel()
    private let testLabel = UILabel()
    private let settingsLabel = UILabel()
    private let logbookLabel = UILabel()
    
    //Bluetooth Data
    private var centralManager: CBCentralManager? = nil
    private var peripheralDevice: CBPeripheral? = nil
    private var stripDetectVoltageCharacteristic: CBCharacteristic? = nil
    private var differentialVoltageCharacteristic: CBCharacteristic? = nil
    private var integratedVoltageCharacteristic: CBCharacteristic? = nil
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    private var inQueueView = 0
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        //think these have to be here because it said the property initialization (global vars) are initialized before this init() function so self is not ready yet at that point
        connectView = ConnectViewController(menuView: self, appDelegate: appDelegate)
        testView = TestViewController(menuView: self, appDelegate: appDelegate)
        settingsView = SettingsViewController(menuView: self, appDelegate: appDelegate)
        logbookView = HerdLogbookViewController(menuView: self, appDelegate: appDelegate)
        self.appDelegate = appDelegate
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        //if WCSession is supported by the device set up wcSession - when both sessions are open, they can communicate, when only one session is open - it may still send updates and transfer files, but those transferes happen opportunistically in the background (open the session on the phone side when the phone app is initially started)
        
        connectView!.setWCSession(session: self.wcSession!)
        testView!.setWCSession(session: self.wcSession!)
        settingsView!.setWCSession(session: self.wcSession!)
        logbookView!.setWCSession(session: self.wcSession!)
        
        createLayoutItems()
        setLayoutConstraints()
        setButtonListeners()
    
        //let bluetoothQueue: DispatchQueue = DispatchQueue(label: "bluetooth queue", attributes: .concurrent) //apparently cannot use a dispatch queue since UITableView MUST be updated from the main thread
        centralManager = CBCentralManager(delegate: self, queue: nil) //central manager for bluetooth connectivity
        
        
        if(inQueueView == 0){
            //do nothing
        }
        else if(inQueueView == 1){
            DispatchQueue.main.async{
                self.findDeviceBtnPressed()
            }
            
            inQueueView = 0
        }
        else if(inQueueView == 2){
            DispatchQueue.main.async{
                self.testBtnPressed()
            }
            
            inQueueView = 0
        }
        else{
            DispatchQueue.main.async{
                self.settingsBtnPressed()
            }
            
            inQueueView = 0
        }
        
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var docsDir = dirPaths[0]
        
        print(docsDir)
        
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //complete this - called when central device updates bluetooth state
    }
    
    private func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        //complete this - called when peripheral device updates bluetooth state
    }
    
    private func createLayoutItems(){ //play with layout of buttons
        findDeviceBtn.setBackgroundImage(findDeviceBtnImage, for: .normal)
        view.addSubview(findDeviceBtn)
        
        findDeviceLabel.text = "Find a Device"
        findDeviceLabel.textColor = .black
        findDeviceLabel.textAlignment = .center
        view.addSubview(findDeviceLabel)
        
        testBtn.setBackgroundImage(testBtnImage, for: .normal)
        view.addSubview(testBtn)
        
        testLabel.text = "Run a Test"
        testLabel.textColor = .black
        testLabel.textAlignment = .center
        view.addSubview(testLabel)
        
        settingsBtn.setBackgroundImage(settingsBtnImage, for: .normal)
        view.addSubview(settingsBtn)
        
        settingsLabel.text = "Configure Settings"
        settingsLabel.textColor = .black
        settingsLabel.textAlignment = .center
        view.addSubview(settingsLabel)
        
        logbookBtn.setBackgroundImage(logbookBtnImage, for: .normal)
        view.addSubview(logbookBtn)
        
        logbookLabel.text = "Logbook"
        logbookLabel.textColor = .black
        logbookLabel.textAlignment = .center
        view.addSubview(logbookLabel)
    
    }
    
    private func setLayoutConstraints(){ //might not need constraints if everything is done in relation to screen size
        //view.translatesAutoresizingMaskIntoConstraints = false //need to do this individually for every component instead
        
        //findDeviceBtn
        findDeviceBtn.translatesAutoresizingMaskIntoConstraints = false
        findDeviceBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
        //findDeviceBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true //this constant value is dependant on the screen resolution
        findDeviceBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.25) - ((UIScreen.main.bounds.height * 0.15) / 2)).isActive = true //this constant value is dependant on the screen resolution
        findDeviceBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        findDeviceBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        //findDeviceLabel
        findDeviceLabel.translatesAutoresizingMaskIntoConstraints = false
        findDeviceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
        findDeviceLabel.topAnchor.constraint(equalTo: findDeviceBtn.bottomAnchor, constant: 10).isActive = true
        
        //testBtn
        testBtn.translatesAutoresizingMaskIntoConstraints = false
        testBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25) ).isActive = true
        //testBtn.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
         testBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.25) - ((UIScreen.main.bounds.height * 0.15) / 2)).isActive = true //this
        testBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        testBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        //testLabel
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25) ).isActive = true
        testLabel.topAnchor.constraint(equalTo: testBtn.bottomAnchor, constant: 10).isActive = true
        
        
        //settingsBtn
        settingsBtn.translatesAutoresizingMaskIntoConstraints = false
        settingsBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25) ).isActive = true
        //settingsBtn.topAnchor.constraint(equalTo: testBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.15)).isActive = true //this constant value is dependant on the screen resolution
        //settingsBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -75).isActive = true //this constant value is dependant on the screen resolution
        settingsBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.25) + ((UIScreen.main.bounds.height * 0.15) / 2)).isActive = true //this
        settingsBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        settingsBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        //settingsLabel
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25)).isActive = true
        settingsLabel.topAnchor.constraint(equalTo: settingsBtn.bottomAnchor, constant: 10).isActive = true
        
        
        logbookBtn.translatesAutoresizingMaskIntoConstraints = false
        logbookBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
        logbookBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.25) + ((UIScreen.main.bounds.height * 0.15) / 2)).isActive = true //this
        logbookBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        logbookBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        logbookLabel.translatesAutoresizingMaskIntoConstraints = false
        logbookLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25)).isActive = true
        logbookLabel.topAnchor.constraint(equalTo: logbookBtn.bottomAnchor, constant: 10).isActive = true
    }
    
    private func setButtonListeners(){
        findDeviceBtn.addTarget(self, action: #selector(findDeviceBtnPressed), for: .touchUpInside) //see if you can put the action function in a seperate class like a listener class
        testBtn.addTarget(self, action: #selector(testBtnPressed), for: .touchUpInside) //see if you can put the action function in a seperate class like a listener class
        settingsBtn.addTarget(self, action: #selector(settingsBtnPressed), for: .touchUpInside) //see if you can put the action function in a seperate class like a listener class
        logbookBtn.addTarget(self, action: #selector(logbookBtnPressed), for: .touchUpInside)
    }
    
    @objc private func findDeviceBtnPressed(){ //see if you can put this in a seperate class like a listener class
        
        
        
        
        findDeviceBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.findDeviceBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    
        
        
        
        navigationController?.pushViewController(connectView!, animated: true) //pushes connectView onto the navigationController stack
    
        centralManager?.delegate = connectView //make connectView the delegate for centralManager
        connectView!.setCentralManager(centralManager: self.centralManager!)
        //connectView.menuView = self
        //connectView.testView = self.testView
        //connectView.settingsView = self.settingsView
        
        wcSession!.delegate = connectView
        connectView?.setWCSession(session: wcSession)
    }
    
    @objc private func testBtnPressed(){ //see if you can put this in a seperate class like a listener class
        
        
        testBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.testBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        
        navigationController?.pushViewController(testView!, animated: true) //pushes testView onto the navigationController stack
        
        testView!.setCentralManager(centralManager: self.centralManager!)
        //peripheralDevice!.delegate = testView
        //testView.menuView = self
        //testView.connectView = self.connectView
        //testView.settingsView = self.settingsView
        
        wcSession!.delegate = testView
        testView?.setWCSession(session: wcSession)
        
    }

    @objc private func settingsBtnPressed(){ //see if you can put this in a seperate class like a listener class
        
        settingsBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.settingsBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        navigationController?.pushViewController(settingsView!, animated: true) //pushes settingsView onto the navigationController stack
        
        //settingsView.menuView = self
        //settingsView.connectView = self.connectView
        //settingsView.testView = self.testView
        
        wcSession!.delegate = settingsView
        settingsView?.setWCSession(session: wcSession)
        
    }
    
    @objc private func logbookBtnPressed(){
        
        logbookBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.logbookBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        navigationController?.pushViewController(logbookView!, animated: true)
        
        wcSession!.delegate = logbookView
        logbookView?.setWCSession(session: wcSession)
    
    }
    
    private func showToast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //fill in
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //fill in
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        //fill in
        //print("wcSession did deactivate on mobile")
    }
    
    //func to receive message
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void){ //needs to throw
        
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if(applicationContext["ChangeScreens"] != nil){
            switch(applicationContext["ChangeScreens"] as! String){
            case "Main":
                    //do nothing
                print("do nothing case")
            case "FindDevice":
                DispatchQueue.main.async {
                    self.findDeviceBtnPressed()
                }
            case "RunTest":
                DispatchQueue.main.async {
                    self.testBtnPressed()
                }
            case "Settings":
                DispatchQueue.main.async {
                    self.settingsBtnPressed()
                }
            case "Logbook":
                DispatchQueue.main.async {
                    self.logbookBtnPressed()
                }
            default:
                print("Default case - do nothing")
            }
        }
    }
    
    //GETTERS/SETTERS
    public func getTestView() -> TestViewController{
        return testView!
    }
    
    public func getConnectView() -> ConnectViewController{
        return connectView!
    }
    
    public func getSettingsView() -> SettingsViewController{
        return settingsView!
    }
    
    public func getHerdLogbookView() -> HerdLogbookViewController{
        return logbookView!
    }
    
    public func setPeripheralDevice(periphDevice: CBPeripheral?){
        self.peripheralDevice = periphDevice
    }
    
    public func setWCSession(session: WCSession?){
        self.wcSession = session
    }
    
    public func setInQueueView(flag: Int){
        inQueueView = flag
    }
    
}
