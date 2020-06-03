//
//  ConnectView.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-05-24.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE CONNECT TO DEVICE SCREEN SEEN AFTER PRESSING THE "FIND DEVICE" BUTTON FROM THE MAIN MENU SCREEN

import UIKit
import CoreBluetooth
import WatchConnectivity
import UserNotifications
import UIKit
import IntentsUI


public class ConnectViewController: UIViewController, CBCentralManagerDelegate, UITableViewDataSource, UITableViewDelegate, WCSessionDelegate{
    
    
    //Bluetooth Data
    private var centralManager: CBCentralManager? = nil
    private var peripheralDevice: CBPeripheral? = nil
    private var peripheralDevices: [CBPeripheral] = [] //array of peripheral devices to connect to
    private let voltageServiceCBUUID = String("fe283188-48df-4a0c-8a52-8f05aec9e4c1") //I think this is the right CBUUID but this might need to be changed
    
    //ViewControllers
    private var menuView: MenuViewController? = nil
    private var appDelegate: AppDelegate? = nil
//    private var testView: TestViewController? = nil
//    private var settingsView: SettingsViewController? = nil
    
    //UIButtons
    private let searchForDevicesBtn = UIButton()
    private let disconnectFromDeviceBtn = UIButton()
    
    //UILabels
    private let connectedDeviceLabel = UILabel()
    
    //UITableViews
    private let peripheralTableView = UITableView()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    //User Defaults
    private let defaults = UserDefaults.standard
    
    private var searchForKnowBluetoothDevicesFlag: Bool = true //set as true by default so that it starts searching upon the app opening up
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(menuView: MenuViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.menuView = menuView
        self.appDelegate = appDelegate
        
        defaults.register(defaults: ["BluetoothPeripheralWhitelist": [Any]()])
        
        //start scanning for known bluetooth peripherals here - this will happen when app opens and this page is created
        //create background thread that searches and connects if found
        self.scanForKnownDevices()
        
    }

    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        searchForKnowBluetoothDevicesFlag = false //when view appears, it stops auto searching
    }

    override public func viewDidDisappear(_ animated: Bool) {
        if(menuView?.getTestPageView().getPeripheralDevice() == nil){ //only rescan if not connected when leaving
            searchForKnowBluetoothDevicesFlag = true //when view dissapears, it starts auto searching again
            scanForKnownDevices()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Find a Device"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        createLayoutItems()
        setLayoutConstraints()
        setButtonListeners()

        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.searchForDevicesBtnPressed), name: NSNotification.Name("SearchForDevices"), object: nil)
        
        //self.setSearchForKnownBluetoothDevicesFlag(flag: false) //turn off automatic bluetooth searching/connecting in appDelegate
        
        if(centralManager?.state == .poweredOn){
            //AUTOMATICALLY SCAN FOR DEVICES ONCE VIEW LOADS
            centralManager?.scanForPeripherals(withServices: [CBUUID(string: voltageServiceCBUUID)]) //change to CBUUID for our custom GATT Service
            //print("post scanning")
            scanningIndicator.startAnimating()
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ //run code after 3 seconds - causes to scan for 3 seconds
                self.scanningIndicator.stopAnimating()
                self.centralManager?.stopScan() //stops scanning after 3 seconds so that it is not scanning forever wasting battery if nothing is found
            }
        }
        else{
            showToast(controller: self, message: "Turn on Bluetooth", seconds: 1)
        }
        
//        if (WCSession.isSupported()) {
//            wcSession = WCSession.default
//            wcSession!.delegate = self
//            wcSession!.activate()
//            print("wcSession has been activated on mobile - ConnectViewController")
//        }
    }
    
//    // This allows you to initialise your custom UIViewController without a nib or bundle.
//    convenience init() {
//        self.init(nibName:nil, bundle:nil)
//    }
//
//    // This extends the superclass.
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        createLayoutItems()
//        setLayoutConstraints()
//        setButtonListeners()
//    }
//
//    // This is also necessary when extending the superclass.
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
//    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //fill out
    }
    
    private func createLayoutItems(){
        
//        searchForDevicesBtn.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 100, y: (UIScreen.main.bounds.height / 7) - 20, width: 200, height: 40)
        searchForDevicesBtn.backgroundColor = .blue
        searchForDevicesBtn.setTitle("Search for Devices", for: .normal)
        searchForDevicesBtn.setTitleColor(.white, for: .normal)
        searchForDevicesBtn.layer.borderWidth = 2
        searchForDevicesBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(searchForDevicesBtn)
        
        
        //CHANGE THIS SO THAT IT ONLY DISPLAYS WHEN centralManager HAS AN ESTABLISHED CONNECTION
//        disconnectFromDeviceBtn.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 100, y: ((UIScreen.main.bounds.height / 7) * 6) - 20, width: 200, height: 40)
        disconnectFromDeviceBtn.backgroundColor = .blue
        disconnectFromDeviceBtn.setTitle("Disconnect from Device", for: .normal)
        disconnectFromDeviceBtn.setTitleColor(.white, for: .normal)
        disconnectFromDeviceBtn.layer.borderWidth = 2
        disconnectFromDeviceBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(disconnectFromDeviceBtn)
        
        
        //setup UITableView
//        peripheralTableView.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 150, y: ((UIScreen.main.bounds.height / 7) * 1.5) - 20, width: 300, height: 500)
        peripheralTableView.dataSource = self
        peripheralTableView.delegate = self
        self.peripheralTableView.register(UITableViewCell.self, forCellReuseIdentifier: "peripheralTableViewCell") //not sure what this is for - look into this
        view.addSubview(peripheralTableView)
        
        
        //setup UILabels
        if(peripheralDevice == nil){
            connectedDeviceLabel.text = "Connected Device: None"
        }
        else{
            connectedDeviceLabel.text = "Connected to: " + (peripheralDevice?.name)!
        }
        connectedDeviceLabel.textColor = .black
//        connectedDeviceLabel.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 250, y: ((UIScreen.main.bounds.height / 7) * 5.5) + 10, width: 500, height: 20)
        connectedDeviceLabel.textAlignment = .center
        view.addSubview(connectedDeviceLabel)
        
        //setup UIActivityIndicatorView
//        scanningIndicator.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 25, y: (UIScreen.main.bounds.height / 2)  - 25, width: 50, height: 50)
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator)
        
    }
    
    private func setLayoutConstraints(){
        //searchForDevicesBtn
        searchForDevicesBtn.translatesAutoresizingMaskIntoConstraints = false
        searchForDevicesBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.275)).isActive = true
        searchForDevicesBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true //this constant value is dependant on the screen resolution
        //searchForDevicesBtn.bottomAnchor.constraint(equalTo: peripheralTableView.topAnchor, constant: -35).isActive = true //this constant value is dependant on the screen resolution
        searchForDevicesBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        searchForDevicesBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.45)).isActive = true
        
        
        //disconnectFromDeviceBtn
        disconnectFromDeviceBtn.translatesAutoresizingMaskIntoConstraints = false
        disconnectFromDeviceBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        //disconnectFromDeviceBtn.topAnchor.constraint(equalTo: peripheralTableView.bottomAnchor, constant: 35).isActive = true //this constant value is dependant on the screen resolution
        disconnectFromDeviceBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.025)).isActive = true //this constant value is dependant on the screen resolution
        disconnectFromDeviceBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        disconnectFromDeviceBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        
        
        //peripheralTableView
        peripheralTableView.translatesAutoresizingMaskIntoConstraints = false
        peripheralTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        peripheralTableView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        peripheralTableView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        peripheralTableView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.6)).isActive = true
        
        
        //connectedDeviceLabel
        connectedDeviceLabel.translatesAutoresizingMaskIntoConstraints = false
        connectedDeviceLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        connectedDeviceLabel.topAnchor.constraint(equalTo: peripheralTableView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true //this constant value is dependant on the screen resolution
        //connectedDeviceLabel.bottomAnchor.constraint(equalTo: disconnectFromDeviceBtn.topAnchor, constant: -6).isActive = true //this constant value is dependant on the screen resolution
        
        
        //scanningIndicator
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scanningIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        scanningIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
        
                
    }
    
    private func setButtonListeners(){
        searchForDevicesBtn.addTarget(self, action: #selector(searchForDevicesBtnPressed), for: .touchUpInside) //see if you can put the action function in a seperate class like a listener class
        disconnectFromDeviceBtn.addTarget(self, action: #selector(disconnectFromDevicesBtnPressed), for: .touchUpInside) //see if you can put the action function in a seperate class like a listener class
        
        if #available(iOS 12.0, *) { //all of these steps have to be done together within this code block for scope reasons - this is why its done here
            let addToSiriBtn = INUIAddVoiceShortcutButton(style: .blackOutline)
            view.addSubview(addToSiriBtn)
            addToSiriBtn.translatesAutoresizingMaskIntoConstraints = false
            addToSiriBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.275)).isActive = true
            addToSiriBtn.centerYAnchor.constraint(equalTo: searchForDevicesBtn.centerYAnchor).isActive = true
            addToSiriBtn.addTarget(self, action: #selector(addToSiriBtnPressed), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    @objc private func addToSiriBtnPressed(){
        if #available(iOS 12.0, *) {
            activateActivity()
            presentAddToSiriViewController()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc public func searchForDevicesBtnPressed(){ //has to be public so that it can be called from AppDelegate when accessed through Siri
        
        searchForDevicesBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.searchForDevicesBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        
        //print("scanning")
        peripheralDevices.removeAll()
        
        self.peripheralTableView.reloadData()
        
        if(centralManager?.state == .poweredOn){
            centralManager?.scanForPeripherals(withServices: [CBUUID(string: voltageServiceCBUUID)]) //change to CBUUID for our custom GATT Service
            //print("post scanning")
            scanningIndicator.startAnimating()
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ //run code after 3 seconds - causes to scan for 3 seconds
                self.scanningIndicator.stopAnimating()
                self.centralManager?.stopScan() //stops scanning after 3 seconds so that it is not scanning forever wasting battery if nothing is found
            }
            
        }
        else{
            showToast(controller: self, message: "Turn on Bluetooth", seconds: 1)
        }
    }
    
    @objc private func disconnectFromDevicesBtnPressed(){
        
        disconnectFromDeviceBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.disconnectFromDeviceBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        if(peripheralDevice != nil){
            centralManager?.cancelPeripheralConnection(peripheralDevice!)
            showToast(controller: self, message: "Disconnected", seconds: 1)
            connectedDeviceLabel.text = "Connected Device: None"
            menuView?.setPeripheralDevice(periphDevice: nil)
            menuView?.getTestPageView().setPeripheralDevice(periphDevice: nil)
        }
        else{
            showToast(controller: self, message: "No device connected", seconds: 1)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralDevices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peripheralTableViewCell", for: indexPath)
        let peripheral = peripheralDevices[indexPath.row]
        cell.textLabel?.text = peripheral.name! + " " + peripheral.identifier.uuidString
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripheralDevices[indexPath.row]
        
        centralManager?.connect(peripheral, options: nil) //centralManager will connect to device when clicked on in the tableView
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        DispatchQueue.main.async{
        

            print(peripheral.name!)
                   
            if(!self.peripheralDevices.contains(peripheral)) {
                self.peripheralDevices.append(peripheral)
            }
                   
            self.peripheralTableView.reloadData()
                   
            self.appDelegate!.getNotificationCenter().getNotificationSettings { (settings) in //send notificaiton that device was discovered
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = "Device Discovered"
                    content.body = "A New Device Was Discovered"
                    content.sound = UNNotificationSound.default
                    content.badge = 1
                           
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                           
                    let identifier = "Local Device Discovered Notification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                           
                    self.appDelegate?.getNotificationCenter().add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                }
            }
            if(self.wcSession != nil){
                if(self.wcSession!.isReachable){
                           do{
                            try self.wcSession?.updateApplicationContext(["DeviceDiscovered":"Update"])
                           }catch{
                               print("error while updating application context")
                           }
                       }
                   }
        
        }
        
        if(searchForKnowBluetoothDevicesFlag){
            
            let bluetoothPeripheralModelNumberWhitelist:[Any] = self.defaults.array(forKey: "BluetoothPeripheralWhitelist")!

            //check that value isn't already in the whitelist
            for value in bluetoothPeripheralModelNumberWhitelist{
                if(peripheral.identifier.uuidString == value as! String){ //device ID matches that stored in the whitelist
                    //connect to this device
                    //self.peripheralDevice = peripheral //you need to keep a reference to the peripheral object to satisfy the API
                    //it is keeping a reference in the tableView now
                    self.centralManager?.connect(peripheral, options: nil) //centralManager will connect to device
                    searchForKnowBluetoothDevicesFlag = false
                }
            }
            
        }
        
    }
    
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        DispatchQueue.main.async {
            
            self.searchForKnowBluetoothDevicesFlag = false //if connected no matter what dont search
            
        
            self.peripheralDevice = peripheral
            self.showToast(controller: self, message: "Connected", seconds: 1)
            self.connectedDeviceLabel.text = "Connected to: " + peripheral.name!
            self.menuView?.setPeripheralDevice(periphDevice: peripheral)
            self.menuView?.getTestPageView().setPeripheralDevice(periphDevice: peripheral)
            peripheral.delegate = self.menuView?.getTestPageView()
            peripheral.discoverServices(nil)
            
            for view in (self.menuView?.getTestPageView().getTestPages())!{
                view.getConnectedDeviceLabel().text = "Connected to: " + peripheral.name! //if testView is visible connectedDeviceLabel will not be changed right away - manually change it
            }
            
            if(self.wcSession != nil){
                if(self.wcSession!.isReachable){
                do{
                    try self.wcSession?.updateApplicationContext(["ConnectedDeviceLabelFindDevice":peripheral.name!])
                }catch{
                    print("error while updating application context")
                }
            }
            }
         
            //save peripheral UUID to whitelist (if not already saved) - this will allow you to reconnect later without having to go into the app to connect
            self.addToPeripheralWhitelist(modelNumberToAdd: peripheral.identifier.uuidString) //add Model Number to bluetooth peripheral whitelist
            
            
            
            self.appDelegate!.getNotificationCenter().getNotificationSettings { (settings) in //send notificaiton that device was discovered
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = "Device Connected"
                    content.body = peripheral.name! + " " + peripheral.identifier.uuidString + " Connected"
                    content.sound = UNNotificationSound.default
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
                    let identifier = "Local Device Connected Notification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    self.appDelegate?.getNotificationCenter().add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                }
            }
            
            
            
        }
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        DispatchQueue.main.async{
        
            self.peripheralDevice = nil
            self.menuView?.setPeripheralDevice(periphDevice: nil)
            self.menuView?.getTestPageView().setPeripheralDevice(periphDevice: nil)
            
            
            if(self.menuView?.navigationController?.visibleViewController == self){
                self.showToast(controller: self, message: "Device Disconnected", seconds: 1)
                self.connectedDeviceLabel.text = "Connected to: None" //if connectView is visible connectedDeviceLabel will not be changed right away - manually change it
            }
            else if(self.menuView?.navigationController?.visibleViewController == self.menuView){
                self.showToast(controller: self.menuView!, message: "Device Disconnected", seconds: 1)
            }
            else if(self.menuView?.navigationController?.visibleViewController == self.menuView?.getTestPageView()){
                self.showToast(controller: (self.menuView?.getTestPageView())!, message: "Device Disconnected", seconds: 1)
                
                for view in (self.menuView?.getTestPageView().getTestPages())!{
                    view.getConnectedDeviceLabel().text = "Connected to: None" //if testView is visible connectedDeviceLabel will not be changed right away - manually change it
                }
                
                self.menuView?.getTestPageView().setStripDetectVoltageValue(value: nil)
                for test in (self.menuView?.getTestPageView().getTestPages())!{
                    test.deviceDisconnected()
                }
    //            menuView?.getTestPageView().setIntegratedVoltageValue(value: nil)
    //            menuView?.getTestPageView().setDifferentialVoltageValue(value: nil)

            }
            else if(self.menuView?.navigationController?.visibleViewController == self.menuView?.getSettingsView()){
                self.showToast(controller: (self.menuView?.getSettingsView())!, message: "Device Disconnected", seconds: 1)
            }
        
            if(self.wcSession != nil){
                if(self.wcSession!.isReachable){
                do{
                    try self.wcSession?.updateApplicationContext(["ConnectedDeviceLabelFindDevice":"None"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
            
            if(!self.isBeingPresented){ //if disconnected but still on screen dont search
                self.searchForKnowBluetoothDevicesFlag = true
                self.scanForKnownDevices()
            }
        }
        
    }
    
    private func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: NSError?) {
        
        DispatchQueue.main.async {
                
            self.showToast(controller: self, message: "Failed to Connect", seconds: 1)
            if(self.wcSession != nil){
                if(self.wcSession!.isReachable){
                do{
                    try self.wcSession?.updateApplicationContext(["FailConnect":"Error"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
            
            self.searchForKnowBluetoothDevicesFlag = true
            self.scanForKnownDevices()
        }
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
    
    override public func viewWillDisappear(_ animated: Bool) { //will be called when the app is closed from this view or the back button is pressed
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent { //check that it is being called because the back button was pressed
            //set the manager's delegate view to parent so it can call relevant disconnect methods
            //centralManager?.delegate = menuView
        }
        
        peripheralDevices.removeAll()
        self.peripheralTableView.reloadData()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if(centralManager?.state == .poweredOn){
            //AUTOMATICALLY SCAN FOR DEVICES ONCE VIEW APPEARS
            centralManager?.scanForPeripherals(withServices: [CBUUID(string: voltageServiceCBUUID)]) //change to CBUUID for our custom GATT Service
            //print("post scanning")
            scanningIndicator.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ //run code after 3 seconds - causes to scan for 3 seconds
                self.scanningIndicator.stopAnimating()
                self.centralManager?.stopScan() //stops scanning after 3 seconds so that it is not scanning forever wasting battery if nothing is found
            }
        }
        else{
            showToast(controller: self, message: "Turn on Bluetooth", seconds: 1)
        }
        
        if(peripheralDevice == nil){
            connectedDeviceLabel.text = "Connected Device: None"
        }
        else{
            connectedDeviceLabel.text = "Connected to: " + (peripheralDevice?.name)!
        }
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //fill out
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //fill out
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        //fill out
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
       
        
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if(applicationContext["ChangeScreens"] != nil){
            switch(applicationContext["ChangeScreens"] as! String){
            case "Main":
                DispatchQueue.main.async {
                    self.wcSession!.delegate = self.menuView
                    self.menuView?.setWCSession(session: self.wcSession)
                    
                    self.menuView?.setInQueueView(flag: 0)
                    self.navigationController?.popViewController(animated: true)
                }
            case "FindDevice":
                    //do nothing
                print("do nothing case")
            case "RunTest":
                DispatchQueue.main.async {
                    self.menuView?.setInQueueView(flag: 2)
                    self.navigationController?.popViewController(animated: true)
                }
            case "Settings":
                DispatchQueue.main.async {
                    self.menuView?.setInQueueView(flag: 3)
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                print("Default case - do nothing")
            }
        }
        else if(applicationContext["Search"] != nil){
            DispatchQueue.main.async {
                self.searchForDevicesBtnPressed()
            }
        }
        else if(applicationContext["Connect"] != nil){
            tableView(peripheralTableView, didSelectRowAt: IndexPath(row: 0, section: 0)) //should connect to the first peripehral device listed in the table
        }
        else if(applicationContext["Disconnect"] != nil){
            DispatchQueue.main.async {
                self.disconnectFromDevicesBtnPressed()
            }
        }
    }
    
    //GETTERS/SETTERS
    
    public func getWCSession() -> WCSession{
        return wcSession!
    }
    
    public func setWCSession(session: WCSession?){
        self.wcSession = session
    }
    
    public func setCentralManager(centralManager: CBCentralManager){
        self.centralManager = centralManager
    }
    
    public func getPeripheralDevice() -> CBPeripheral?{
        return peripheralDevice
    }
    
    public func getConnectedDeviceLabel() -> UILabel{
        return connectedDeviceLabel
    }
    
    
    
    
    
    //MARK: - CoreBluetooth from AppDelegate
    
    public func addToPeripheralWhitelist(modelNumberToAdd: String){
        var bluetoothPeripheralModelNumberWhitelist:[Any] = defaults.array(forKey: "BluetoothPeripheralWhitelist")!
        
        //check that value isn't already in the whitelist
        for value in bluetoothPeripheralModelNumberWhitelist{
            if(modelNumberToAdd == value as! String){
                print(modelNumberToAdd + " already exists in whitelist")
                return
            }
        }
        
        bluetoothPeripheralModelNumberWhitelist.append(modelNumberToAdd) //append modelNumber of paired peripheral to the whitelist to reconnect upon opening the app
        print("saved: " + modelNumberToAdd + " to whitelist\n")
        
        defaults.set(bluetoothPeripheralModelNumberWhitelist, forKey: "BluetoothPeripheralWhitelist")
        print("saved whitelist to UserDefaults")
        
    }
    
    public func setSearchForKnownBluetoothDevicesFlag(flag: Bool){ //if this flag is set to 1: search for bluetooth devices. If set to 0: do not search for bluetooth devices
        self.searchForKnowBluetoothDevicesFlag = flag
        if(flag){
            self.scanForKnownDevices()
        }
    }
    
    public func scanForKnownDevices(){
        
        let dispatchQueue = DispatchQueue(label: "BluetoothScanKnownDevicesBackgroundThread", qos: .background)
        dispatchQueue.async{
            
            while(self.searchForKnowBluetoothDevicesFlag){
                //scan for bluetooth devices
                if(self.centralManager?.state == .poweredOn){
                    self.centralManager?.scanForPeripherals(withServices: [CBUUID(string: self.voltageServiceCBUUID)]) //change to CBUUID for our custom GATT Service
                }
                
            }
            
        }
    }
    
    
    
    
    
    //MARK: -Siri
    
}




@available(iOS 12.0, *)
extension ConnectViewController {

    func activateActivity(){
        userActivity = NSUserActivity(activityType: "SearchForDevices")
        let title = "Search For CPS Devices"
        userActivity?.title = title
        userActivity?.userInfo = ["id": title]
        userActivity?.suggestedInvocationPhrase = "Search For CPS Devices"
        userActivity?.isEligibleForPrediction = true
        userActivity?.persistentIdentifier = title
        
        userActivity?.isEligibleForSearch = true
        userActivity?.isEligibleForPrediction = true
        
        self.userActivity = userActivity
        userActivity?.becomeCurrent()
    }
    
    func presentAddToSiriViewController() {
        guard let userActivity = self.userActivity else { return }
        let shortcut = INShortcut(userActivity: userActivity)
        let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        viewController.modalPresentationStyle = .formSheet
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}


@available(iOS 12.0, *)
extension ConnectViewController: INUIAddVoiceShortcutViewControllerDelegate {
    public func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}




