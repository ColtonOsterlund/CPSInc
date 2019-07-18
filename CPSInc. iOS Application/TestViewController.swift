//
//  TestView.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-05-24.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import CoreBluetooth
import Charts //using the Charts framework - done using the tutorial https://www.appcoda.com/ios-charts-api-tutorial/
import WatchConnectivity
import UserNotifications

public class TestViewController: UIViewController, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate, WCSessionDelegate{

    //Bluetooth Data
    private var centralManager: CBCentralManager? = nil
    private var peripheralDevice: CBPeripheral? = nil
    private var stripDetectVoltageCharacteristic: CBCharacteristic? = nil
    private var integratedVoltageCharacteristic: CBCharacteristic? = nil
    private var differentialVoltageCharacterisitc: CBCharacteristic? = nil
    private var startTestCharacteristic: CBCharacteristic? = nil
    private var stripDetectVoltageValue: Int? = nil
    private var integratedVoltageValue: Int? = nil
    private var differentialVoltageValue: Int? = nil
    
    //UITableView
    private let glucoseResultTable = UITableView()
    private let herdListTable = UITableView()
    private let cowListTable = UITableView()
    
    //View Controllers
    private var menuView: MenuViewController? = nil
    private var appDelegate: AppDelegate? = nil
//    private var connectView: ConnectViewController? = nil
//    private var settingsView: SettingsViewController? = nil
    
    //UIButtons
    private let startTestBtn = UIButton()
    private let resetTestBtn = UIButton()
    private let saveTestBtn = UIButton()
    
    //UILabels
    private let connectedDeviceLabel = UILabel()
    private let testDurationLabel = UILabel()
    private let testTypeLabel = UILabel()
    private let actualTestTypeLabel = UILabel()
    private let testResultLabel = UILabel()
    
    //UIProgressView
    private let testProgressView = UIProgressView(progressViewStyle: UIProgressView.Style.default)
    private let testResultProgressBar = UIProgressView(progressViewStyle: UIProgressView.Style.default)
    
    private var peripheralData = [Float]()
    
    private let lineChartView = LineChartView()
    private var dataEntries = [ChartDataEntry]()
    //var dataXEntry: Int = 0
    
    
    //incubation timer
    private var incubationTimeLabel = UILabel()
    private let incubationLabel = UILabel()
    private var incubationTimer: Timer? = nil
    private let cancelTestBtn = UIButton()
    
    //Test Settings - technically dont need these we can access them straight through settingsView
//    var testDurationSeconds: Int? = nil //how long to run the test for before taking final value
//    var isFinalValueTest: Bool? = nil //if true - final value test, if false - continuous value test
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    private var testResultToSave: Float? = nil
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(menuView: MenuViewController, appDelegate: AppDelegate?) {
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

        self.title = "Run a Test"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        createLayoutItems()
        setLayoutConstraints()
        setButtonListeners()
        
        // *** perhapse start the test here - then restart it after pressing resetBtn and stopping it - this might fix the issue with the values not being ready in time. Try this when you have the device back to check ***
        
//        if (WCSession.isSupported()) {
//            wcSession = WCSession.default
//            wcSession!.delegate = self
//            wcSession!.activate()
//            print("wcSession has been activated on mobile - TestViewController")
//        }
        
//        if(wcSession!.isReachable){
//            wcSession!.sendMessage(["TestTypeLabel":testTypeLabel], replyHandler: nil, errorHandler: nil)
//            wcSession!.sendMessage(["TestDurationLabel":testDurationLabel], replyHandler: nil, errorHandler: nil)
//        }
    }
    
    private func createLayoutItems(){
        //connectedDeviceLabel
//        if(peripheralDevice == nil){
//            connectedDeviceLabel.text = "Connected Device: None"
//        }
//        else{
//            connectedDeviceLabel.text = "Connected to: " + (peripheralDevice?.name)!
//        }
        connectedDeviceLabel.textColor = .black
        connectedDeviceLabel.textAlignment = .center
        view.addSubview(connectedDeviceLabel)
        
        //durationLabel
       // testDurationLabel.text = "Test Duration: " + String((menuView!.getSettingsView().getTestDuration())) + " seconds"
        testDurationLabel.textColor = .black
        testDurationLabel.textAlignment = .center
        view.addSubview(testDurationLabel)
        
        //testTypeLabel
//        if(menuView!.getSettingsView().getFinalContinuous() == true){
//            testTypeLabel.text = "Test Type: Final Value Test"
//        }
//        else{
//            testTypeLabel.text = "Test Type: Continuous Value Test"
//        }
        testTypeLabel.textColor = .black
        testTypeLabel.textAlignment = .center
        view.addSubview(testTypeLabel)
        
        
        //actualTestTypeLabel
//        if(menuView?.getSettingsView().getTestType() == 0){
//            actualTestTypeLabel.text = "Test Type: Immunoglobulins"
//        }
//        else if(menuView?.getSettingsView().getTestType() == 1){
//            actualTestTypeLabel.text = "Test Type: Lactoferrin"
//        }
//        else if(menuView?.getSettingsView().getTestType() == 2){
//            actualTestTypeLabel.text = "Test Type: Blood Calcium"
//        }
//        else{
//            actualTestTypeLabel.text = "Test Type: Glucose"
//        }
        actualTestTypeLabel.textColor = .black
        actualTestTypeLabel.textAlignment = .center
        view.addSubview(actualTestTypeLabel)
        
        
        //startTestBtn
        startTestBtn.backgroundColor = .blue
        startTestBtn.setTitle("Start Test", for: .normal)
        startTestBtn.setTitleColor(.white, for: .normal)
        startTestBtn.layer.borderWidth = 2
        startTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(startTestBtn)
        
        //testResultLabel
        testResultLabel.text = "" //will be filled out with the test result
        testResultLabel.textColor = .green //will be set based on test results
        testResultLabel.font = testResultLabel.font.withSize(50) //adjust font size
        testResultLabel.textAlignment = .center
        view.addSubview(testResultLabel)
        testResultLabel.isHidden = true
        
        //resetTestButton
        resetTestBtn.backgroundColor = .blue
        resetTestBtn.setTitle("Reset Test", for: .normal)
        resetTestBtn.setTitleColor(.white, for: .normal)
        resetTestBtn.layer.borderWidth = 2
        resetTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(resetTestBtn)
        resetTestBtn.isEnabled = false
        resetTestBtn.isHidden = true
        
        //saveTestButton
        saveTestBtn.backgroundColor = .blue
        saveTestBtn.setTitle("Save Test Results", for: .normal)
        saveTestBtn.setTitleColor(.white, for: .normal)
        saveTestBtn.layer.borderWidth = 2
        saveTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(saveTestBtn)
        saveTestBtn.isEnabled = false
        saveTestBtn.isHidden = true
        
        glucoseResultTable.tag = 0
        glucoseResultTable.dataSource = self
        glucoseResultTable.delegate = self
        glucoseResultTable.register(UITableViewCell.self, forCellReuseIdentifier: "glucoseResultTableViewCell")
        view.addSubview(glucoseResultTable)
        glucoseResultTable.isHidden = true
        
        lineChartView.noDataText = "Error While Loading Chart"
        lineChartView.noDataFont = lineChartView.noDataFont.withSize(20)
        lineChartView.noDataTextColor = .red
        lineChartView.backgroundColor = .white
        view.addSubview(lineChartView)
        lineChartView.isHidden = true
        
        
        incubationTimeLabel.text = "00:10"
        incubationTimeLabel.font = incubationTimeLabel.font.withSize(50)
        incubationTimeLabel.textColor = .white
        incubationTimeLabel.textAlignment = .center
        view.addSubview(incubationTimeLabel)
        incubationTimeLabel.isHidden = true
        
        incubationLabel.text = "Incubation Timer:"
        incubationLabel.font = incubationLabel.font.withSize(25)
        incubationLabel.textColor = .white
        incubationLabel.textAlignment = .center
        view.addSubview(incubationLabel)
        incubationLabel.isHidden = true
        
        //cancelTestButton
        cancelTestBtn.backgroundColor = .blue
        cancelTestBtn.setTitle("Cancel Test", for: .normal)
        cancelTestBtn.setTitleColor(.white, for: .normal)
        cancelTestBtn.layer.borderWidth = 2
        cancelTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(cancelTestBtn)
        cancelTestBtn.isEnabled = false
        cancelTestBtn.isHidden = true
    }
    
    private func setLayoutConstraints(){
        //startTestBtn
        startTestBtn.translatesAutoresizingMaskIntoConstraints = false
        startTestBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        startTestBtn.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        startTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        //connectedDevicesLabel
        connectedDeviceLabel.translatesAutoresizingMaskIntoConstraints = false
        connectedDeviceLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        connectedDeviceLabel.topAnchor.constraint(equalTo: startTestBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
        //not too necesary for a bottom anchor since the label and button are the only things in the middle of the screen so it will never be too dangerously out of place
        
        //durationLabel
        testDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        testDurationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testDurationLabel.topAnchor.constraint(equalTo: connectedDeviceLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
        //not too necesary for a bottom anchor since the label and button are the only things in the middle of the screen so it will never be too dangerously out of place
        
        //testTypeLabel
        testTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        testTypeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testTypeLabel.topAnchor.constraint(equalTo: testDurationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
        //not too necesary for a bottom anchor since the label and button are the only things in the middle of the screen so it will never be too dangerously out of place
        
        
        //actualTestTypeLabel
        actualTestTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        actualTestTypeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        actualTestTypeLabel.topAnchor.constraint(equalTo: testTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
        
        //testResultLabel
        testResultLabel.translatesAutoresizingMaskIntoConstraints = false
        testResultLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testResultLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        

        //resetTestBtn
        resetTestBtn.translatesAutoresizingMaskIntoConstraints = false
        resetTestBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetTestBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.05)).isActive = true
        resetTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        //saveTestBtn
        saveTestBtn.translatesAutoresizingMaskIntoConstraints = false
        saveTestBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveTestBtn.bottomAnchor.constraint(equalTo: resetTestBtn.topAnchor, constant: -(UIScreen.main.bounds.height * 0.05)).isActive = true
        saveTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        //glucoseResultTable
        glucoseResultTable.translatesAutoresizingMaskIntoConstraints = false
        glucoseResultTable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        glucoseResultTable.bottomAnchor.constraint(equalTo: saveTestBtn.topAnchor, constant: -(UIScreen.main.bounds.width * 0.05)).isActive = true
        glucoseResultTable.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        glucoseResultTable.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        //lineChartView
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        lineChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: glucoseResultTable.topAnchor, constant: -(UIScreen.main.bounds.height * 0.02)).isActive = true
        lineChartView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        
        incubationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        incubationTimeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        incubationTimeLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        incubationLabel.translatesAutoresizingMaskIntoConstraints = false
        incubationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        incubationLabel.bottomAnchor.constraint(equalTo: incubationTimeLabel.topAnchor, constant: -(UIScreen.main.bounds.height * 0.05)).isActive = true
        
        cancelTestBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelTestBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        cancelTestBtn.topAnchor.constraint(equalTo: incubationTimeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        cancelTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
    }
    
    private func setButtonListeners(){
        startTestBtn.addTarget(self, action: #selector(startTestBtnPressed), for: .touchUpInside)
        resetTestBtn.addTarget(self, action: #selector(resetTestBtnPressed), for: .touchUpInside)
        saveTestBtn.addTarget(self, action: #selector(saveTestBtnPressed), for: .touchUpInside)
        cancelTestBtn.addTarget(self, action: #selector(cancelTestBtnPressed), for: .touchUpInside)
    }
    
    @objc private func saveTestBtnPressed(){
        
        //save test results w CoreData
        
        saveTestBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.saveTestBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        
        let selectSavingMethodAlert = UIAlertController(title: "Save Test Results", message: "Please Select Method of Saving", preferredStyle: .actionSheet) //actionSheet shows on the bottom of the screen while alert comes up in the middle
        
        selectSavingMethodAlert.addAction(UIAlertAction(title: "Manually Enter Herd/Cow ID", style: .default, handler: { action in
            //manually enter herd and cow id to save test to
            self.selectHerdToSaveManually()
            
        }))
        
        selectSavingMethodAlert.addAction(UIAlertAction(title: "Select Herd/Cow from List", style: .default, handler: { action in
            //select herd and cow from list to save test to
            self.selectHerdToSaveFromList()
            
        }))
        selectSavingMethodAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        
        self.present(selectSavingMethodAlert, animated: true)
    }
    
    
    
    private func selectHerdToSaveManually(){
        //create herd id alert
        let herdIDTextAlert = UIAlertController(title: "Herd ID", message: "Enter Herd ID", preferredStyle: .alert)
        
        //add text field to herd id alert
        herdIDTextAlert.addTextField{ (textField) in
            textField.keyboardType = .numberPad
            textField.text = ""
        }
        
        //add cancel action to herd id alert
        herdIDTextAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            return
        }))
        
        //add ok action to herd id alert
        var herdID: String? = nil
        herdIDTextAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak herdIDTextAlert] (_) in
            herdID = herdIDTextAlert?.textFields![0].text
            
            var match: Int = 0
            for herd in (self.menuView?.getHerdLogbookView().getHerdList())!{
                if(herdID == herd.id){
                    self.menuView?.getHerdLogbookView().getCowLogbookView().setSelectedHerd(herd: herd) //set selected herd to have access to the correct cow list
                    match = 1
                }
            }
            
            if(match == 0){ //check if no match was made
                let errorAlert = UIAlertController(title: "Herd ID", message: "Herd Does Not Exist With That ID", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    return
                }))
                self.present(errorAlert, animated: true)
            }
            else{
                self.selectCowToSaveManually()
            }
        }))
        
        //present herdIDTextAlert
        self.present(herdIDTextAlert, animated: true)
        
    }
    
    
    private func selectCowToSaveManually(){
        //create herd id alert
        let cowIDTextAlert = UIAlertController(title: "Cow ID", message: "Enter Cow ID", preferredStyle: .alert)
        
        //add text field to herd id alert
        cowIDTextAlert.addTextField{ (textField) in
            textField.keyboardType = .numberPad
            textField.text = ""
        }
        
        //add cancel action to herd id alert
        cowIDTextAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            return
        }))
        
        //add ok action to herd id alert
        var cowID: String? = nil
        cowIDTextAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak cowIDTextAlert] (_) in
            cowID = cowIDTextAlert?.textFields![0].text
            
            var match: Int = 0
            for cow in (self.menuView?.getHerdLogbookView().getCowLogbookView().getCowList())!{
                if(cowID == cow.id){
                    self.menuView?.getHerdLogbookView().getCowLogbookView().getTestLogbookView().setSelectedCow(cow: cow)
                    match = 1
                }
            }
            
            if(match == 0){
                let errorAlert = UIAlertController(title: "Cow ID", message: "Cow Does Not Exist With That ID", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    return
                }))
                self.present(errorAlert, animated: true)
            }
            else{
                self.saveTestToCow()
            }
            
        }))
        
        //present herdIDTextAlert
        self.present(cowIDTextAlert, animated: true)
    }
    
    
    
    
    
    
    
    
    private func selectHerdToSaveFromList(){
        
        //FILL OUT
        
        showToast(controller: self, message: "Feature not yet supported in this version", seconds: 1)
    }
    
    
    private func selectCowToSaveFromList(){
        
        //FILL OUT
        
    }
    
    
    private func saveTestToCow(){
        print("save test")
        
        let testToSave = Test(context: (appDelegate?.persistentContainer.viewContext)!)
        testToSave.date = Date() as NSDate //gives current date
        if(menuView!.getSettingsView().getFinalContinuous() == true){
            testToSave.dataType = "Final"
        }
        else{
            testToSave.dataType = "Continuous"
        }
        
       testToSave.runtime = (menuView?.getSettingsView().getTestDuration())! as NSNumber

        
        switch(menuView?.getSettingsView().getTestType()){
            case 0:
                testToSave.testType = "Immunoglobulins"
            case 1:
                testToSave.testType = "Lactoferrin"
            case 2:
                testToSave.testType = "Blood Calcium"
            case 3:
                testToSave.testType = "Glucose"
            default:
                break
        }
        
        testToSave.value = testResultToSave!
        
        testToSave.units = "mmol/L"
        
        testToSave.cow = menuView?.getHerdLogbookView().getCowLogbookView().getTestLogbookView().getSelectedCow()
        
        appDelegate?.saveContext() //save w core data
        
        showToast(controller: self, message: "Test Result Has Been Saved", seconds: 1)
        
        self.resetTestBtnPressed()
    }
    
    
    
    
    @objc private func resetTestBtnPressed(){
        
        resetTestBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.resetTestBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        let stopTestString = "00"
        let stopTestData = Data(hexString: stopTestString)
        self.peripheralDevice?.writeValue(stopTestData!, for: self.startTestCharacteristic!, type: .withResponse) //discharge capacitor
            
        testResultProgressBar.isHidden = true
        testResultLabel.isHidden = true
    
        glucoseResultTable.isHidden = true
        peripheralData.removeAll()
    
        lineChartView.isHidden = true
        dataEntries.removeAll()
        //dataXEntry = 0
        
        herdListTable.isHidden = true
        cowListTable.isHidden = true
        
        resetTestBtn.isEnabled = false
        resetTestBtn.isHidden = true
        self.saveTestBtn.isEnabled = false
        self.saveTestBtn.isHidden = true
        
        startTestBtn.isEnabled = true
        startTestBtn.isHidden = false
        
        connectedDeviceLabel.isHidden = false
        
        testDurationLabel.isHidden = false
        
        testTypeLabel.isHidden = false
        
        actualTestTypeLabel.isHidden = false
        
        //resets voltage values to nil so that the start of the next test is not affected by the previous test
        integratedVoltageValue = nil
        differentialVoltageValue = nil
        
    }
    
    @objc private func startTestBtnPressed(){
        
        startTestBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.startTestBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        if(peripheralDevice == nil){
            showToast(controller: self, message: "No device connected", seconds: 1)
            return
        }
        else if(stripDetectVoltageValue! <= 750){ //set proper value for testing, for now this works
            showToast(controller: self, message: "Strips not detected", seconds: 1)
            return
        }
        else{
            //disable and hide startTestBtn
            startTestBtn.isEnabled = false
            startTestBtn.isHidden = true
            
            //hide connectedDeviceLabel
            connectedDeviceLabel.isHidden = true
            
            //hide testDurationLabel
            testDurationLabel.isHidden = true
            
            //hide testTypeLabel
            testTypeLabel.isHidden = true
            
            //hide actualTestTypeLabel
            actualTestTypeLabel.isHidden = true
            
            //Set test settings - technically dont need these we can access them straight through settingsView
//            testDurationSeconds = settingsView?.testDurationSeconds
//            isFinalValueTest = settingsView?.isFinalValueTest
            
            incubationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("updateIncubationTimeString")), userInfo: nil, repeats: true)
            
            //send notification if app is in background
            self.appDelegate!.getNotificationCenter().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = "Timer Almost Done"
                    content.body = "Your Have 5 Seconds Before the Incubation Timer is Done"
                    content.sound = UNNotificationSound.default
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //set value to send notification however long before the test is over that you want to receive that notification
                    
                    let identifier = "Local Timer Almost Done Notification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    self.appDelegate?.getNotificationCenter().add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                }
            }
            
            //run and display incubation timer here - send notification when there is 60 seconds left
            incubationLabel.isHidden = false
            incubationTimeLabel.isHidden = false
            cancelTestBtn.isHidden = false
            cancelTestBtn.isEnabled = true
            
            
//            if(menuView!.getSettingsView().getFinalContinuous() == true){
//                runFinalValueTest()
//            }
//            else{
//                runContinuousTest()
//            }
        }
    }
    
    
    @objc private func cancelTestBtnPressed(){
        
        cancelTestBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.cancelTestBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        
        incubationTimer?.invalidate() //stops timer from firing
        incubationTimer = nil //resets incubation timer to nil
    
        incubationTimeLabel.text = "00:10" //resets incubation timer label
        incubationTimeLabel.isHidden = true
        incubationLabel.isHidden = true
        cancelTestBtn.isHidden = true
        cancelTestBtn.isEnabled = true
        
        resetTestBtnPressed()
    }
    
    
    @objc private func updateIncubationTimeString(){
        let timerTextArray = incubationTimeLabel.text!.components(separatedBy: ":")
        
        var minutes = Int(timerTextArray[0])
        var seconds = Int(timerTextArray[1])
        
        if(seconds == 0 && minutes != 0){
            seconds! = 59
            minutes! -= 1
        }
        
        else if(seconds == 0 && minutes == 0){
            
            incubationTimer?.invalidate() //stops timer from firing
            incubationTimer = nil //resets incubation timer to nil
            
            seconds = 10 //resets seconds
            minutes = 0 //resets minutes
            incubationTimeLabel.isHidden = true
            incubationLabel.isHidden = true
            cancelTestBtn.isHidden = true
            cancelTestBtn.isEnabled = true
            
            if(menuView!.getSettingsView().getFinalContinuous() == true){
                runFinalValueTest()
            }
            else{
                runContinuousTest()
            }
        }
       
        else{
            seconds! -= 1
        }
        
        
        incubationTimeLabel.text = String(minutes!) + ":" + String(seconds!) //resets incubation timer label
    }
    
    
    private func runFinalValueTest(){
        //run final value test
        
        if(wcSession!.isReachable){
            do{
                try wcSession?.updateApplicationContext(["BeganRunningTest":"FinalValue"])
            }catch{
                print("error while updating application context")
            }
        }
        
        let startTestString = "01"
        let stopTestString = "00"
        
        let startTestData = Data(hexString: startTestString)
        let stopTestData = Data(hexString: stopTestString)
        
        self.peripheralDevice?.writeValue(stopTestData!, for: self.startTestCharacteristic!, type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
        peripheralDevice?.writeValue(startTestData!, for: startTestCharacteristic!, type: .withResponse) //start test
        
        //not sure why i need to do this here - look into this
        //testProgressView
        testProgressView.trackTintColor = .white
        testProgressView.tintColor = .black
        view.addSubview(testProgressView)
        testProgressView.isHidden = true
        //testProgressView
        testProgressView.translatesAutoresizingMaskIntoConstraints = false
        testProgressView.setProgress(1, animated: true)
        testProgressView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testProgressView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        testProgressView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.5)).isActive = true
        testProgressView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        //testProgressView.isHidden = true
        testProgressView.isHidden = false
        
        testProgressView.setProgress(0, animated: true)
        
        //not sure if this is the best method to delay - look into this
        let currentTime = DispatchTime.now()
        
        DispatchQueue.main.asyncAfter(deadline: currentTime + .seconds(menuView!.getSettingsView().getTestDuration() * 1/4)){
            self.testProgressView.setProgress(0.25, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: currentTime + .seconds(menuView!.getSettingsView().getTestDuration() * 1/2 )){
            self.testProgressView.setProgress(0.5, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: currentTime + .seconds(menuView!.getSettingsView().getTestDuration() * 3/4)){
            self.testProgressView.setProgress(0.75, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: currentTime + .seconds(menuView!.getSettingsView().getTestDuration())){
            self.testProgressView.setProgress(1, animated: true)
            
            self.testProgressView.isHidden = true
            
            
            var glucoseResult: Float?
            
            //display integratedVoltageValue before stopping the test, or else integratedVoltageValue will be reset to 0 before being displayed when the capacitor is discharged upon stopping the test
            if(self.integratedVoltageValue == nil){
                glucoseResult = nil
            }
            else if(self.integratedVoltageValue! != 0){
                let testType = self.menuView?.getSettingsView().getTestType()
                
                switch testType{
                case 0: //Immunoglobulins
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
                    
                case 1: //Lactoferrin
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
                    
                case 2: //Blood Calcium
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109//this is measured/based off the integrated voltage after 10s
                    
                case 3: //Generic Glucose
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
                    
                default:
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
                }
            }
            else{
                glucoseResult = 0.00 //change this to 0.00 after the demo
            }
            
            
            if(glucoseResult != nil){
                //not sure why this needs to be done here - look into this
                self.testResultProgressBar.trackTintColor = .white
                //self.testResultProgressBar.tintColor = .red //will be set based on test results
                self.view.addSubview(self.testResultProgressBar)
                self.testResultProgressBar.isHidden = true
                
                self.testResultProgressBar.translatesAutoresizingMaskIntoConstraints = false
                //testResultProgressBar.center = view.center
                self.testProgressView.setProgress(1, animated: true)
                self.testResultProgressBar.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
                self.testResultProgressBar.topAnchor.constraint(equalTo: self.testResultLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
                self.testResultProgressBar.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.75)).isActive = true
                self.testResultProgressBar.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
                
                if(glucoseResult! < Float(3.0)){
                    self.testResultLabel.textColor = .red
                    self.testResultProgressBar.tintColor = .red
                }
                else if(glucoseResult! >= Float(3.0) && glucoseResult! < Float(4.0)){
                    self.testResultLabel.textColor = .yellow
                    self.testResultProgressBar.tintColor = .yellow
                }
                else if(glucoseResult! >= Float(4.0) && glucoseResult! < Float(8.0)){
                    self.testResultLabel.textColor = .green
                    self.testResultProgressBar.tintColor = .green
                }
                else if(glucoseResult! >= Float(8.0) && glucoseResult! < Float(12.0)){
                    self.testResultLabel.textColor = .yellow
                    self.testResultProgressBar.tintColor = .yellow
                }
                else{
                    self.testResultLabel.textColor = .red
                    self.testResultProgressBar.tintColor = .red
                }
                
                self.testResultLabel.text = String(format: "%.2f", glucoseResult!) + " mmol/L"
                self.testResultLabel.isHidden = false
                
                self.testResultProgressBar.isHidden = false
                self.testResultProgressBar.setProgress(Float(glucoseResult! / Float(30)), animated: true)
                
                self.testResultToSave = glucoseResult
                
                self.saveTestBtn.isEnabled = true
                self.saveTestBtn.isHidden = false
                
            }
            else{ //if glucoseResult == nil
                self.showToast(controller: self, message: "Error Occured While Testing", seconds: 1)
            }
            
            //self.peripheralDevice?.writeValue(stopTestData!, for: self.startTestCharacteristic!, type: .withResponse) //discharge capacitor - probably better to discharge after pressing resetTestButton
            
            if(self.wcSession!.isReachable){
                do{
                    try self.wcSession?.updateApplicationContext(["FinalValueTestResult":glucoseResult!])
                }catch{
                    print("error while updating application context")
                }
            }
            
            self.resetTestBtn.isEnabled = true
            self.resetTestBtn.isHidden = false
            
            //send notification if app is in background
            self.appDelegate!.getNotificationCenter().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = "Test Complete"
                    content.body = "Your Test is Complete"
                    content.sound = UNNotificationSound.default
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
                    let identifier = "Local Test Finished Notification"
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
    
    private func runContinuousTest(){
        
        if(wcSession!.isReachable){
            do{
                try wcSession?.updateApplicationContext(["BeganRunningTest":"ContinuousValue"])
            }catch{
                print("error while updating application context")
            }
        }
        
        let startTestString = "01"
        let stopTestString = "00"
        
        let startTestData = Data(hexString: startTestString)
        let stopTestData = Data(hexString: stopTestString)
        
        self.peripheralDevice?.writeValue(stopTestData!, for: self.startTestCharacteristic!, type: .withResponse) //discharge capacitor in case strips were left in after previous test and charge built up
        peripheralDevice?.writeValue(startTestData!, for: startTestCharacteristic!, type: .withResponse)
        
        //not sure why i need to do this here - look into this
        //testProgressView
        testProgressView.trackTintColor = .white
        testProgressView.tintColor = .black
        view.addSubview(testProgressView)
        testProgressView.isHidden = true
        //testProgressView
        testProgressView.translatesAutoresizingMaskIntoConstraints = false
        testProgressView.setProgress(1, animated: true)
        testProgressView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testProgressView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        testProgressView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.5)).isActive = true
        testProgressView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        //testProgressView.isHidden = true
        testProgressView.isHidden = false
        
        testProgressView.setProgress(0, animated: true)
        
        //print(integratedVoltageValue)
        
        readNewContinuousData() //read data at 0s first
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("readNewContinuousData")), userInfo: nil, repeats: true) //fires every 1 second - readNewContinuousData runs every second starting at 1s
        
        //testing purposes
        print("\n\nstarting test")
        var testTimer = Timer()
        testTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: Selector(("readNewVoltage")), userInfo: nil, repeats: true)
        
        //not sure if this is the best method to delay - look into this
        let currentTime = DispatchTime.now()
        
        DispatchQueue.main.asyncAfter(deadline: currentTime + .seconds(menuView!.getSettingsView().getTestDuration() * 1/4)){
            self.testProgressView.setProgress(0.25, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: currentTime + .seconds(menuView!.getSettingsView().getTestDuration() * 1/2 )){
            self.testProgressView.setProgress(0.5, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: currentTime + .seconds(menuView!.getSettingsView().getTestDuration() * 3/4)){
            self.testProgressView.setProgress(0.75, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: currentTime + .seconds(menuView!.getSettingsView().getTestDuration())){
            timer.invalidate() //stops timer from running/firing
            
            //testing purposes
            print("end of test\n\n")
            testTimer.invalidate()
            
            self.testProgressView.setProgress(1, animated: true)
            
            self.testProgressView.isHidden = true
            
            //make the graph from peripheralDevice here
            self.glucoseResultTable.reloadData()
            self.glucoseResultTable.isHidden = false
            
            //populate the graph data
            for i in 0...self.menuView!.getSettingsView().getTestDuration(){ //should only happen 0 - testDuration times
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(self.peripheralData[i]))
                self.dataEntries.append(dataEntry)
                
            }
            
            //print graph of results here
            self.lineChartView.isHidden = false
            let lineChartDataSet = LineChartDataSet(entries: self.dataEntries, label: "Glucose Results")
            let lineChartData = LineChartData(dataSet: lineChartDataSet)
            self.lineChartView.data = lineChartData
            self.lineChartView.xAxis.granularity = 1
            self.lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
            self.lineChartView.setVisibleXRangeMaximum(5.0) //causes you to have to scroll to see the rest of the values
            self.lineChartView.moveViewToX(0.0) //initially display the graph starting at index of 0
            self.lineChartView.isHidden = false
            
            self.peripheralDevice?.writeValue(stopTestData!, for: self.startTestCharacteristic!, type: .withResponse) //discharge capacitor
            
            //sending the final value of the result set
            if(self.wcSession!.isReachable){
                do{
                    try self.wcSession?.updateApplicationContext(["ContinuousValueFinalTestResult":self.peripheralData.last!])
                }catch{
                    print("error while updating application context")
                }
            }
            
            self.testResultToSave = self.peripheralData.last
            
            
            self.resetTestBtn.isEnabled = true
            self.resetTestBtn.isHidden = false
            self.saveTestBtn.isEnabled = true
            self.saveTestBtn.isHidden = false
            
            //send notifiation if app is in background
            self.appDelegate!.getNotificationCenter().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = "Test Complete"
                    content.body = "Your Test is Complete"
                    content.sound = UNNotificationSound.default
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
                    let identifier = "Local Test Finished Notification"
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

    @objc private func readNewContinuousData(){
        var glucoseResult: Float?
        
        //print(integratedVoltageValue)
        
        if(self.integratedVoltageValue == nil){
            glucoseResult = nil
        }
        else if(self.integratedVoltageValue! != 0){ //will give positive value of glucose (depends which strip is used)
            
            //print(Float(Float(self.integratedVoltageValue!) / Float(1000)))
            let testType = self.menuView?.getSettingsView().getTestType()
            
            switch testType{
                case 0: //Immunoglobulins
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
                
                case 1: //Lactoferrin
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
                
                case 2: //Blood Calcium
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
                
                case 3: //Generic Glucose
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
                
                default:
                    glucoseResult = Float(Float(self.integratedVoltageValue!) / Float(1000)) / 33.109 //this is measured/based off the integrated voltage after 10s
            }
        
        }
        else{
            glucoseResult = 0.00 //change this to 0.00 after the demo
        }
        
        
        if(glucoseResult == nil){
            //print("failed")
            
            self.peripheralData.append(0.01) //list will contain 0.01 if glucoseResult was nil - debugging purposes
            
//            let dataEntry = ChartDataEntry(x: Double(dataXEntry), y: Double(0.01))
//            dataEntries.append(dataEntry)
        }
        else{
            self.peripheralData.append(glucoseResult!)
        
//            let dataEntry = ChartDataEntry(x: Double(dataXEntry), y: Double(glucoseResult!))
//            dataEntries.append(dataEntry)
        }
        
        //dataXEntry += 1 //corresponds to the amount of seconds into the test that its been
    }
    
    //testing purposes
    @objc private func readNewVoltage(){
        if(integratedVoltageValue == nil){
            print("nil")
        }
        else{
            print(integratedVoltageValue!)
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
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        //print("discovering servies")
        
        for service in peripheral.services! {
            
            //print("Service found with UUID: " + service.uuid.uuidString)
            
            //device information service
            if (service.uuid.uuidString == "180A") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //GAP (Generic Access Profile) for Device Name
            // This replaces the deprecated CBUUIDGenericAccessProfileString
            if (service.uuid.uuidString == "1800") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //Custom Service
            if (service.uuid.uuidString == "FE283188-48DF-4A0C-8A52-8F05AEC9E4C1") { //this is the CBUUID for our custom GATT Votlage service
                
                print("discovered custom service")
                
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            if (service.uuid.uuidString == "1D14D6EE-FD63-4FA1-BFA4-8F47B42119F0") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //get device name
        
        //print("discovering characteristics")
        
        if (service.uuid.uuidString == "1800") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A00") {
                    peripheral.readValue(for: characteristic)
                    //print("Found Device Name Characteristic")
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == "180A") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A29") {
                    peripheral.readValue(for: characteristic)
                   // print("Found a Device Manufacturer Name Characteristic")
                } else if (characteristic.uuid.uuidString == "2A23") {
                    peripheral.readValue(for: characteristic)
                    //print("Found System ID")
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == "FE283188-48DF-4A0C-8A52-8F05AEC9E4C1") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "646B19C6-F66D-4CC2-B2FE-8EFDC1E2CC1F") { //stripDetectVoltageCharacteristic
                    //we'll save the reference, we need it to write data
                    stripDetectVoltageCharacteristic = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("found strip detect voltage charac")
                }
                
                if (characteristic.uuid.uuidString == "57D8F270-B6DC-4AE7-B23D-D15C36B6ED5D") { //integratedVoltageCharacteristic
                    //we'll save the reference, we need it to write data
                    integratedVoltageCharacteristic = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("found integrated voltage charac")
                }
                
                if (characteristic.uuid.uuidString == "215CBB55-C71C-42A8-BB41-066696B1AFF1") { //differentialVoltageCharacteristic
                    //we'll save the reference, we need it to write data
                    differentialVoltageCharacterisitc = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("found differential voltage charac")
                }
                
                if (characteristic.uuid.uuidString == "3DC78DC9-AEB6-4596-8D1B-FA76D76D5EA1") { //capacitorDischargeCharacteristic
                    //we'll save the reference, we need it to write data
                    startTestCharacteristic = characteristic
                    
                    print("found capacitor discharge charac")
                }
                
            }
            
        }
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (characteristic.uuid.uuidString == "646B19C6-F66D-4CC2-B2FE-8EFDC1E2CC1F") { //strip detect voltage
            if(characteristic.value != nil) {
                let stringValue = characteristic.value!.hexEncodedString()
                stripDetectVoltageValue = Int(exactly: Int(stringValue, radix: 16)!)
                //print(stripDetectVoltageValue!)
            }
        }
        else if(characteristic.uuid.uuidString == "57D8F270-B6DC-4AE7-B23D-D15C36B6ED5D"){ //integrated voltage
            if(characteristic.value != nil) {
                let stringValue = characteristic.value!.hexEncodedString()
                integratedVoltageValue = Int(exactly: Int(stringValue, radix: 16)!)
                //print("integrated vol = " + integratedVoltageValue!)
            }
        }
        else if(characteristic.uuid.uuidString == "215CBB55-C71C-42A8-BB41-066696B1AFF1"){ //differential voltage
            if(characteristic.value != nil) {
                let stringValue = characteristic.value!.hexEncodedString()
                differentialVoltageValue = Int(exactly: Int(stringValue, radix: 16)!)
                //print("differential vol = " + differentialVoltageValue!)
            }
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if(peripheralDevice == nil){
            connectedDeviceLabel.text = "Connected Device: None"
        }
        else{
            connectedDeviceLabel.text = "Connected to: " + (peripheralDevice?.name)!
        }
        
        if(menuView!.getSettingsView().getFinalContinuous() == true){
            testTypeLabel.text = "Test Type: Final Value Test"
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestTypeLabelRunTest":"Final"])
                }catch{
                    print("error while updating application context")
                }
            }
        }
        else{
            testTypeLabel.text = "Test Type: Continuous Test"
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestTypeLabelRunTest":"Continuous"])
                }catch{
                    print("error while updating application context")
                }
            }
        }
        
        testDurationLabel.text = "Test Duration: " + String(menuView!.getSettingsView().getTestDuration()) + " seconds"
        
        if(wcSession!.isReachable){
            //print("Sending test duration label")
            
            do{
                try wcSession?.updateApplicationContext(["TestDurationLabelRunTest":String(menuView!.getSettingsView().getTestDuration()) + "s"])
            }catch{
                print("error while updating application context")
            }
        }
        
        
        
        if(menuView?.getSettingsView().getTestType() == 0){
            actualTestTypeLabel.text = "Test Type: Immunoglobulins"
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestSampleLabelRunTest":"Immunoglobulins"])
                }catch{
                    print("error while updating application context")
                }
            }
        }
        else if(menuView?.getSettingsView().getTestType() == 1){
            actualTestTypeLabel.text = "Test Type: Lactoferrin"
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestSampleLabelRunTest":"Lactoferrin"])
                }catch{
                    print("error while updating application context")
                }
            }
        }
        else if(menuView?.getSettingsView().getTestType() == 2){
            actualTestTypeLabel.text = "Test Type: Blood Calcium"
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestSampleLabelRunTest":"Blood Calcium"])
                }catch{
                    print("error while updating application context")
                }
            }
        }
        else{
            actualTestTypeLabel.text = "Test Type: Glucose"
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestSampleLabelRunTest":"Glucose"])
                }catch{
                    print("error while updating application context")
                }
            }
        }
//        if(wcSession!.isReachable){
//            wcSession!.sendMessage(["TestTypeLabel":testTypeLabel.text], replyHandler: nil, errorHandler: nil)
//            wcSession!.sendMessage(["TestDurationLabel":testDurationLabel.text], replyHandler: nil, errorHandler: nil)
//        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "glucoseResultTableViewCell", for: indexPath)
        let data = peripheralData[indexPath.row]
        cell.textLabel?.text = String(indexPath.row) + " second(s):    " + String(data) + "mmol/L"
        
        return cell
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
        //for messages with reply handlers
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //for messages without reply handlers
        
        let messageRequest = message["Msg"] as? String
        
        switch(messageRequest){
        case "RunTestPrompt":
            DispatchQueue.main.async {
                self.startTestBtnPressed()
            }
            
        default:
            break
        }
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
                DispatchQueue.main.async {
                    self.menuView?.setInQueueView(flag: 1)
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
        
        else if(applicationContext["ResetTest"] != nil){
            DispatchQueue.main.async {
                self.resetTestBtnPressed()
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if(applicationContext["SaveTest"] != nil){
            DispatchQueue.main.async {
                self.saveTestBtnPressed()
            }
        }
    }
    
    //GETTERS/SETTERS
    
    public func getWCSession() -> WCSession{
        return wcSession!
    }
    
    public func setWCSession(session: WCSession?){
        wcSession = session
    }
    
    public func setCentralManager(centralManager: CBCentralManager){
        self.centralManager = centralManager
    }
    
    public func setPeripheralDevice(periphDevice: CBPeripheral?){
        self.peripheralDevice = periphDevice
    }
    
    public func getConnectedDeviceLabel() -> UILabel{
        return connectedDeviceLabel
    }
    
    public func getStripDetectVoltageValue() -> Int?{
        return stripDetectVoltageValue
    }
    
    public func getIntegratedVoltageValue() -> Int?{
        return integratedVoltageValue
    }
    
    public func getDifferentialVoltageValue() -> Int?{
        return differentialVoltageValue
    }
    
    public func setStripDetectVoltageValue(value: Int?){
        self.stripDetectVoltageValue = value
    }
    
    public func setIntegratedVoltageValue(value: Int?){
        self.integratedVoltageValue = value
    }
    
    public func setDifferentialVoltageValue(value: Int?){
        self.differentialVoltageValue = value
    }

}

extension Data {
    //DATA TO HEX STRING
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let hexDigits = Array((options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef").utf16)
        var chars: [unichar] = []
        chars.reserveCapacity(2 * count)
        for byte in self {
            chars.append(hexDigits[Int(byte / 16)])
            chars.append(hexDigits[Int(byte % 16)])
        }
        
        return String(utf16CodeUnits: chars, count: chars.count)
    }
    
    //HEX STRING TO DATA
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
}
