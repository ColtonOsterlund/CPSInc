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
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(menuView: MenuViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.menuView = menuView
        self.appDelegate = appDelegate
    }

    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Find a Device"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        createLayoutItems()
        setLayoutConstraints()
        setButtonListeners()
        
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
        searchForDevicesBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        searchForDevicesBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true //this constant value is dependant on the screen resolution
        //searchForDevicesBtn.bottomAnchor.constraint(equalTo: peripheralTableView.topAnchor, constant: -35).isActive = true //this constant value is dependant on the screen resolution
        searchForDevicesBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        searchForDevicesBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        
        
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
    }
    
    @objc private func searchForDevicesBtnPressed(){
        
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
        cell.textLabel?.text = peripheral.name
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripheralDevices[indexPath.row]
        
        centralManager?.connect(peripheral, options: nil) //centralManager will connect to device when clicked on in the tableView
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print(peripheral.name!)
        
        if(!peripheralDevices.contains(peripheral)) {
            peripheralDevices.append(peripheral)
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
        if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["DeviceDiscovered":"Update"])
                }catch{
                    print("error while updating application context")
                }
            }
        }
        
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralDevice = peripheral
        showToast(controller: self, message: "Connected", seconds: 1)
        connectedDeviceLabel.text = "Connected to: " + peripheral.name!
        menuView?.setPeripheralDevice(periphDevice: peripheral)
        menuView?.getTestPageView().setPeripheralDevice(periphDevice: peripheral)
        peripheral.delegate = menuView?.getTestPageView()
        peripheral.discoverServices(nil)
        if(wcSession != nil){
        if(wcSession!.isReachable){
            do{
                try wcSession?.updateApplicationContext(["ConnectedDeviceLabelFindDevice":peripheral.name!])
            }catch{
                print("error while updating application context")
            }
        }
        }
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripheralDevice = nil
        menuView?.setPeripheralDevice(periphDevice: nil)
        menuView?.getTestPageView().setPeripheralDevice(periphDevice: nil)
        
        
        if(menuView?.navigationController?.visibleViewController == self){
            showToast(controller: self, message: "Device Disconnected", seconds: 1)
            connectedDeviceLabel.text = "Connected to: None" //if connectView is visible connectedDeviceLabel will not be changed right away - manually change it
        }
        else if(menuView?.navigationController?.visibleViewController == menuView){
            showToast(controller: menuView!, message: "Device Disconnected", seconds: 1)
        }
        else if(menuView?.navigationController?.visibleViewController == menuView?.getTestPageView()){
            showToast(controller: (menuView?.getTestPageView())!, message: "Device Disconnected", seconds: 1)
            
            for view in (menuView?.getTestPageView().getTestPages())!{
                view.getConnectedDeviceLabel().text = "Connected to: None" //if testView is visible connectedDeviceLabel will not be changed right away - manually change it
            }
            
            menuView?.getTestPageView().setStripDetectVoltageValue(value: nil)
            for test in (menuView?.getTestPageView().getTestPages())!{
                test.deviceDisconnected()
            }
//            menuView?.getTestPageView().setIntegratedVoltageValue(value: nil)
//            menuView?.getTestPageView().setDifferentialVoltageValue(value: nil)

        }
        else if(menuView?.navigationController?.visibleViewController == menuView?.getSettingsView()){
            showToast(controller: (menuView?.getSettingsView())!, message: "Device Disconnected", seconds: 1)
        }
    
        if(wcSession != nil){
        if(wcSession!.isReachable){
            do{
                try wcSession?.updateApplicationContext(["ConnectedDeviceLabelFindDevice":"None"])
            }catch{
                print("error while updating application context")
            }
        }
        }
        
        
    }
    
    private func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: NSError?) {
        showToast(controller: self, message: "Failed to Connect", seconds: 1)
        if(wcSession != nil){
        if(wcSession!.isReachable){
            do{
                try wcSession?.updateApplicationContext(["FailConnect":"Error"])
            }catch{
                print("error while updating application context")
            }
        }
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
    
}
