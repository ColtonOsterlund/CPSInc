
//  TestView.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-05-24.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE RUN TEST SCREEN SEEN AFTER PRESSING THE "RUN TEST" BUTTON FROM THE MAIN MENU SCREEN

import UIKit
import CoreBluetooth
import Charts //using the Charts framework - done using the tutorial https://www.appcoda.com/ios-charts-api-tutorial/
import WatchConnectivity
import UserNotifications
import CoreData
import IntentsUI

public class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WCSessionDelegate{

    
    
    
    //FOR YONG - CHANGE THESE TO CHANGE THE INCUBATION TIMER AND THE NOTIFICATION TIME TO WARN THE END OF TEST
    private let incubationTimeMinutes = "00"
    private let incubationTimeSeconds = "20"
    private let notificationTimeMinutes = "00"
    private let notificationTimeSeconds = "10"
    
    //FOR YONG - CHANGE THIS (NUMBER OF SECONDS) FOR HOW LONG TO WAIT BEFORE NEW TEST STARTED
    private let timeBetweenTests = 2
    
    
    
    
    
    
    
    
    
    
    
    
    //set to true if device did disconnect during the test - checked at the end of test to display if the test would be an erronous result
    private var disconnectedDevice = false
    
    //UITableView
    private let glucoseResultTable = UITableView()
    private let herdListTable = UITableView()
    private let cowListTable = UITableView()
    
    //pageID
    private var pageID: Int? = nil
    
    //View Controllers
    private var menuView: MenuViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var testPageController: TestPageViewController? = nil
//    private var connectView: ConnectViewController? = nil
//    private var settingsView: SettingsViewController? = nil
    
    //UIButtons
    private let startTestBtn = UIButton()
    private let resetTestBtn = UIButton()
    private let saveTestBtn = UIButton()
    private var addTestBtn = UIButton()
    
    //UILabels
    private let connectedDeviceLabel = UILabel()
    private let testDurationLabel = UILabel()
    private let testTypeLabel = UILabel()
    private let actualTestTypeLabel = UILabel()
    private let testResultLabel = UILabel()
    private let testDateLabel = UILabel()
    private let testHerdIDLabel = UILabel()
    private let testCowIDLabel = UILabel()
    
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
    private var testCancelled = false
    
    
    private var testType: Int? = nil
    
    private var testQueue: DispatchQueue? = nil
    private var alertQueue: DispatchQueue? = nil
    private var finalValueTestQueue: DispatchQueue? = nil
    private var continuousValueTestQueue: DispatchQueue? = nil
    
    //Test Settings - technically dont need these we can access them straight through settingsView
//    var testDurationSeconds: Int? = nil //how long to run the test for before taking final value
//    var isFinalValueTest: Bool? = nil //if true - final value test, if false - continuous value test
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    private var testResultToSave: Float? = nil
    
    private var herdToSave: Herd? = nil
    
    private var cowToSave: Cow? = nil
    
    private var testDate: Date? = nil 
    
    private var chooseCowAtBeginning: Bool? = nil
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(menuView: MenuViewController, appDelegate: AppDelegate?, testPageController: TestPageViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.menuView = menuView
        self.appDelegate = appDelegate
        self.testPageController = testPageController
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
        
        testType = menuView!.getSettingsView().getTestType() //set test type every time view will load
        
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
        actualTestTypeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
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
        
        //testDateLabel
        testDateLabel.text = ""
        testDateLabel.textColor = .black
        testDateLabel.font = testDateLabel.font.withSize(30)
        testDateLabel.textAlignment = .center
        view.addSubview(testDateLabel)
        testDateLabel.isHidden = true
        
        //testHerdIDLabel
        testHerdIDLabel.text = ""
        testHerdIDLabel.textColor = .black
        testHerdIDLabel.font = testDateLabel.font.withSize(30)
        testHerdIDLabel.textAlignment = .center
        view.addSubview(testHerdIDLabel)
        testHerdIDLabel.isHidden = true
        
        //testCowIDLabel
        testCowIDLabel.text = ""
        testCowIDLabel.textColor = .black
        testCowIDLabel.font = testDateLabel.font.withSize(30)
        testCowIDLabel.textAlignment = .center
        view.addSubview(testCowIDLabel)
        testCowIDLabel.isHidden = true

        
        
        //resetTestButton
        resetTestBtn.backgroundColor = .blue
        resetTestBtn.setTitle("Discard Test", for: .normal)
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
        
        
        incubationTimeLabel.text = incubationTimeMinutes + ":" + incubationTimeSeconds
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
        
        
        addTestBtn.backgroundColor = .blue
        addTestBtn.setTitle("New Test", for: .normal)
        addTestBtn.setTitleColor(.white, for: .normal)
        addTestBtn.layer.borderWidth = 2
        addTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(addTestBtn)
        addTestBtn.isEnabled = false
        addTestBtn.isHidden = true
        
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
        
        addTestBtn.translatesAutoresizingMaskIntoConstraints = false
        addTestBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addTestBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.025)).isActive = true
        addTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.6)).isActive = true
        
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
        
        testDateLabel.translatesAutoresizingMaskIntoConstraints = false
        testDateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testDateLabel.topAnchor.constraint(equalTo: addTestBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        
        testHerdIDLabel.translatesAutoresizingMaskIntoConstraints = false
        testHerdIDLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testHerdIDLabel.topAnchor.constraint(equalTo: testDateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        
        testCowIDLabel.translatesAutoresizingMaskIntoConstraints = false
        testCowIDLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testCowIDLabel.topAnchor.constraint(equalTo: testHerdIDLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        
    }
    
    private func setButtonListeners(){
        startTestBtn.addTarget(self, action: #selector(startTestBtnPressed), for: .touchUpInside)
        resetTestBtn.addTarget(self, action: #selector(resetTestBtnPressed), for: .touchUpInside)
        saveTestBtn.addTarget(self, action: #selector(saveTestBtnPressed), for: .touchUpInside)
        cancelTestBtn.addTarget(self, action: #selector(cancelTestBtnPressed), for: .touchUpInside)
        addTestBtn.addTarget(self, action: #selector(addTestBtnPressed), for: .touchUpInside)
        
        
        if #available(iOS 12.0, *) { //all of these steps have to be done together within this code block for scope reasons - this is why its done here
            let addToSiriBtn = INUIAddVoiceShortcutButton(style: .blackOutline)
            view.addSubview(addToSiriBtn)
            addToSiriBtn.translatesAutoresizingMaskIntoConstraints = false
            addToSiriBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            addToSiriBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
        
        if(chooseCowAtBeginning == true){ //cow was already chosen at beginning of test
            self.saveTestToCow()
            return
        }
        
        
        let selectSavingMethodAlert = UIAlertController(title: "Save Test Results", message: "Please Select Method of Saving", preferredStyle: .actionSheet) //actionSheet shows on the bottom of the screen while alert comes up in the middle
        
        selectSavingMethodAlert.addAction(UIAlertAction(title: "Manually Enter Herd/Cow ID", style: .default, handler: { action in
            //manually enter herd and cow id to save test to
            self.selectHerdToSaveManually()
            
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
            self.chooseCowAtBeginning = false
            return
        }))
        
        //add ok action to herd id alert
        var herdID: String? = nil
        herdIDTextAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak herdIDTextAlert] (_) in
            herdID = herdIDTextAlert?.textFields![0].text
            
            var match: Int = 0
            for herd in (self.menuView?.getHerdLogbookView().getHerdList())!{
                if(herdID == herd.id){
                    self.menuView?.getHerdLogbookView().getCowLogbookView().setSelectedHerd(herd: herd) //set selected herd to have access to the correct cow list - DONT NEED TO SET HERD TO SAVE, YOU ONLY ENTER THE HERD SO THAT YOU CAN GET THE RIGHT COW. THIS CAN BE OVERWRITTEN DOESNT MATTER
                    match = 1
                    
                    self.herdToSave = herd
                    
                    self.testHerdIDLabel.text = "Herd ID: " + herd.id!
                }
            }
            
            if(match == 0){ //check if no match was made
                let errorAlert = UIAlertController(title: "Herd ID", message: "Herd Does Not Exist With That ID", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    self.chooseCowAtBeginning = false
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
            self.chooseCowAtBeginning = false
            return
        }))
        
        //add ok action to herd id alert
        var cowID: String? = nil
        cowIDTextAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak cowIDTextAlert] (_) in
            cowID = cowIDTextAlert?.textFields![0].text
            
            
            
            let fetchRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "herd == %@", self.herdToSave!) //list the cows from the selected herd
            var savedCowArray: [Cow]? = nil
            
            do{
                savedCowArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
            } catch{
                print("Error during fetch request")
            }
            
            
            
            
            var match: Int = 0
            
            if(savedCowArray != nil){
                for cow in savedCowArray!{
                    if(cowID == cow.id){
                        //self.menuView?.getHerdLogbookView().getCowLogbookView().getTestLogbookView().setSelectedCow(cow: cow)
                        self.cowToSave = cow
                        match = 1
                        
                        self.testCowIDLabel.text = "Cow ID: " + cow.id!
                    }
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
                if(self.chooseCowAtBeginning == false){ //else: it will call saveTestToCow() itself
                    self.saveTestToCow()
                }
                else{
                    self.startTestProcess()
                }
            }
            
        }))
        
        //present herdIDTextAlert
        self.present(cowIDTextAlert, animated: true)
    }
    
    
    
    
    
    
    
    
    private func selectHerdToSaveFromList(){ //this was never implemented
        
        //FILL OUT
        
        showToast(controller: self, message: "Feature not yet supported in this version", seconds: 1)
    }
    
    
    private func selectCowToSaveFromList(){ //this was never implemented
        
        //FILL OUT
        
    }
    
    
    private func saveTestToCow(){ //save test to the cow that was chosen
        print("save test")
        
        let testToSave = Test(context: (appDelegate?.persistentContainer.viewContext)!)
        testToSave.date = testDate as NSDate?
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
        
        //testToSave.cow = menuView?.getHerdLogbookView().getCowLogbookView().getTestLogbookView().getSelectedCow()
        testToSave.cow = cowToSave
        appDelegate?.saveContext() //save w core data
        
        showToast(controller: self, message: "Test Result Has Been Saved", seconds: 1)
        
        self.resetTestBtnPressed()
    }
    
    
    
    
    @objc private func resetTestBtnPressed(){ //resets everything at the end of a test to re-run a test from the same testing screen
        
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
        
        disconnectedDevice = false
        
        let stopTestString = "00"
        let stopTestData = Data(hexString: stopTestString)
        self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor
            
        testResultProgressBar.isHidden = true
        testResultLabel.isHidden = true
        self.testResultLabel.font = self.testResultLabel.font.withSize(50) //adjust font size
    
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
        
        self.chooseCowAtBeginning = nil
        
        self.cowToSave = nil
        
        self.addTestBtn.isEnabled = false
        self.addTestBtn.isHidden = true
        
        self.testDateLabel.text = ""
        self.testDateLabel.isHidden = true
        
        self.testHerdIDLabel.text = ""
        self.testHerdIDLabel.isHidden = true
        
        self.testCowIDLabel.text = ""
        self.testCowIDLabel.isHidden = true
        
        if((testPageController?.getTestPages().count)! > 1){
            var currentPageIndex = 0
            for page in (testPageController?.getTestPages())!{
                if(page == self){
                    break
                }
                currentPageIndex += 1
            }
            
            if(currentPageIndex == 0){
                //go to the new test page
                self.testPageController?.setViewControllers([(self.testPageController?.getTestPages()[currentPageIndex + 1])!], direction: .forward, animated: true, completion: nil)
                self.testPageController?.pageControl.currentPage = currentPageIndex + 1
                
                self.testPageController!.removePage(pageIndexToRemove: currentPageIndex)
            }
            
            else{
                //go to the new test page
                self.testPageController?.setViewControllers([(self.testPageController?.getTestPages()[currentPageIndex - 1])!], direction: .forward, animated: true, completion: nil)
                self.testPageController?.pageControl.currentPage = currentPageIndex - 1
                
                self.testPageController!.removePage(pageIndexToRemove: currentPageIndex)
            }
            
        }
        
        //resets voltage values to nil so that the start of the next test is not affected by the previous test
//        integratedVoltageValue = nil
//        differentialVoltageValue = nil
        
    }
    
    
    
    
    //THIS SETS UP ALL THE PARAMETERS TO START THE ACTUAL TEST PROCESS
    
    @objc public func startTestBtnPressed(){ //set to public so that it can be started from a seperate test - as well as started from app delegate from siri 
        //starts the testing process
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
        
        

        
        
        let herdFetchRequest: NSFetchRequest<Herd> = Herd.fetchRequest()
        var savedHerdArray: [Herd]? = nil
        do{
            savedHerdArray = try appDelegate?.persistentContainer.viewContext.fetch(herdFetchRequest)
            
        } catch{
            print("Error during fetch request")
        }
        
        let cowFetchRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
        var savedCowArray: [Cow]? = nil
        do{
            savedCowArray = try appDelegate?.persistentContainer.viewContext.fetch(cowFetchRequest)
            
        } catch{
            print("Error during fetch request")
        }
        
        print(testPageController!.getStripDetectVoltageValue() as! Int)
        
        if(testPageController!.getPeripheralDevice() == nil){
            showToast(controller: self, message: "No device connected", seconds: 1)
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["NoDevice":"Error"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
            
            return
        }
        else if(testPageController!.getStripDetectVoltageValue()! <= 750){ //set proper value for testing, for now this works
            //this is set to 750 since one of the devices only has a strip detect voltage of 1/2 VDD, the other has a strip detect voltage of VDD. 75O gives a lot of room for any noise at the bottom end and also is low enough to detect when a strip is inserted (essentially 1/4 VDD)
            showToast(controller: self, message: "Strips not detected", seconds: 1)
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["NoStrips":"Error"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
            
            return
        }
        else if(savedHerdArray!.isEmpty){
            showToast(controller: self, message: "No Herd in Logbook to Save Results", seconds: 1)
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["NoHerd":"Error"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
            
            return
        }
        else if(savedCowArray!.isEmpty){
            showToast(controller: self, message: "No Cow in Logbook to Save Results", seconds: 1)
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["NoCow":"Error"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
            
            return
        }
        else{
            if(chooseCowAtBeginning == nil){ //if started from apple watch, this will be pre set to false
                let alert = UIAlertController(title: "Choose Herd/Cow", message: "Would you like to select the Herd/Cow for this test now or later?", preferredStyle: .alert)
        
                alert.addAction(UIAlertAction(title: "Now", style: .default, handler: { action in
                    self.chooseCowAtBeginning = true
                    self.selectHerdToSaveManually()
                }))
        
                alert.addAction(UIAlertAction(title: "Later", style: .cancel, handler: { action in
                    self.chooseCowAtBeginning = false
                    self.startTestProcess()
                }))
        
                self.present(alert, animated: true)
            }
            else{
                self.startTestProcess()
            }
        }
    }
    
    
    
    
    
    
    //THIS IS THE ACTUAL TEST PROCESS
    
    private func startTestProcess(){ //AFTER EVERYTHING IS SET UP FOR A TEST THIS IS RUN WHICH STARTS THE TESTING PROCESS
        
        testDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        
        testDateLabel.text = dateformatter.string(from: testDate!)
        testDateLabel.isHidden = false
        
        if(chooseCowAtBeginning == true){
            testHerdIDLabel.isHidden = false
            testCowIDLabel.isHidden = false
        }
        
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
            
        testCancelled = false
        
        //FROM HERE THE TEST PROCESS WILL BE SLIGHTLY DIFFERENT WITH NEW DEVICE - THIS WILL BE FIGURED OUT ONCE WE HAVE THE DEVICE
            
            
//        incubationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateIncubationTimeString), userInfo: nil, repeats: true)
//
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.timeBetweenTests)){
//            if((self.testPageController?.getTestPages().count)! < 10){
//                self.addTestBtn.isEnabled = true
//                self.addTestBtn.isHidden = false
//            }
//
//            self.cancelTestBtn.isHidden = false
//            self.cancelTestBtn.isEnabled = true
//
//
//
//            if(self.disconnectedDevice == true){
//                self.cancelTestBtnPressed()
//            }
//        }
//
//
//        var herdID: String? = nil
//        var cowID: String? = nil
//        var timeString: String? = nil
//
//        DispatchQueue.main.async{
//            herdID = self.testHerdIDLabel.text
//            cowID = self.testCowIDLabel.text
//            timeString = self.testDateLabel.text
//        }
//
//        //send notification that incubation timer is almost complete
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(((Int(incubationTimeMinutes)! * 60) + Int(incubationTimeSeconds)!) - ((Int(notificationTimeMinutes)! * 60) + Int(notificationTimeSeconds)!))){
//            if(self.testCancelled == false){
//                //send notification if app is in background
//                self.appDelegate!.getNotificationCenter().getNotificationSettings { (settings) in
//                    if settings.authorizationStatus == .authorized {
//                        let content = UNMutableNotificationContent()
//                        content.title = "Timer Almost Done"
//                        if(self.chooseCowAtBeginning == false){
//                            var bodyString = "Your Have "
//                            bodyString += self.notificationTimeMinutes
//                            bodyString += " Minutes and "
//                            bodyString += self.notificationTimeSeconds
//                            bodyString += " Seconds Before the Incubation Timer is Done for Test Date: "
//                            bodyString += timeString!
//
//                            content.body = bodyString
//                        }
//                        else{
//                            var bodyString = "Your Have "
//                            bodyString += self.notificationTimeMinutes
//                            bodyString += " Minutes and "
//                            bodyString += self.notificationTimeSeconds
//                            bodyString += " Seconds Before the Incubation Timer is Done for "
//                            bodyString += herdID!
//                            bodyString += ", "
//                            bodyString += cowID!
//                            bodyString += ", Test Date: "
//                            bodyString += timeString!
//
//                            content.body = bodyString
//                        }
//                        content.sound = UNNotificationSound.default
//                        content.badge = 1
//
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) //set value to send notification however long before the test is over that you want to receive that notification
//
//                        let identifier = "Local Timer Almost Done Notification" + String(self.pageID!)
//                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//                        self.appDelegate?.getNotificationCenter().add(request) { (error) in
//                            if let error = error {
//                                print("Error \(error.localizedDescription)")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//
//        //run and display incubation timer here - send notification when there is 60 seconds left
//        incubationLabel.isHidden = false
//        incubationTimeLabel.isHidden = false
//
//
//        //            if(menuView!.getSettingsView().getFinalContinuous() == true){
//        //                runFinalValueTest()
//        //            }
//        //            else{
//        //                runContinuousTest()
//        //            }
    }
    
    
    @objc private func cancelTestBtnPressed(){ //this is used to cancel the test during the incubation timer stage
        
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
        
        testCancelled = true
        disconnectedDevice = false
        
        incubationTimer?.invalidate() //stops timer from firing
        incubationTimer = nil //resets incubation timer to nil
        
        addTestBtn.isEnabled = false
        addTestBtn.isHidden = true
    
        incubationTimeLabel.text = incubationTimeMinutes + ":" + incubationTimeSeconds //resets incubation timer label
        incubationTimeLabel.isHidden = true
        incubationLabel.isHidden = true
        cancelTestBtn.isHidden = true
        cancelTestBtn.isEnabled = true
        
        resetTestBtnPressed()
    }
    
    
    @objc private func updateIncubationTimeString(){ //this is used to update the string dealing with the incubation timer to give the look that the timer is counting down. It also reads the string to deal with the specific cases (what is suppose to happen at what times)
        let timerTextArray = incubationTimeLabel.text!.components(separatedBy: ":")
        
        var minutes = Int(timerTextArray[0])
        var seconds = Int(timerTextArray[1])
        
        if(seconds == 0 && minutes != 0){
            seconds! = 59
            minutes! -= 1
        }
        
        else if(seconds == 0 && minutes == 0){

            self.incubationTimer?.invalidate() //stops timer from firing
            self.incubationTimer = nil //resets incubation timer to nil
                
            seconds = Int(self.incubationTimeSeconds)!
            minutes = Int(self.incubationTimeMinutes)!
            self.incubationTimeLabel.isHidden = true
            self.incubationLabel.isHidden = true
            self.cancelTestBtn.isHidden = true
            self.cancelTestBtn.isEnabled = false

            
            if(menuView!.getSettingsView().getFinalContinuous() == true){
                print(incubationTimeLabel.isHidden)
                self.runFinalValueTest()
            }
            else{
                self.runContinuousTest()
            }
        }
       
        else{
            seconds! -= 1
        }
        
        
        incubationTimeLabel.text = String(format: "%02d", minutes!) + ":" + String(format: "%02d", seconds!) //resets incubation timer label
    }
    
    
    
    
    @objc private func addTestBtnPressed(){ //this adds a page to the testPageViewController where you can start another test
        //FILL OUT
        
        self.addTestBtn.isHidden = true
        self.addTestBtn.isEnabled = false
        
        let newTestView = TestViewController(menuView: self.menuView!, appDelegate: self.appDelegate, testPageController: self.testPageController)
        if(wcSession != nil){
        wcSession!.delegate = newTestView
        newTestView.setWCSession(session: wcSession!)
        }
        self.testPageController?.addPage(pageToAdd: newTestView)
        
        //switch to added test
        self.testPageController?.setViewControllers([(self.testPageController?.getTestPages().last)!], direction: .forward, animated: true, completion: nil)
        self.testPageController?.pageControl.currentPage = (self.testPageController?.getTestPages().count)! - 1
    }
    
    
    
    
    private func runFinalValueTest(){ //if final value test is set in settings this testing process will run
        //run final value test
        finalValueTestQueue = DispatchQueue(label: "Final Value Test Queue", attributes: .concurrent) //runs on a background thread so that you can run multiple tests at once - also has to pause for 10 seconds at one point and this would cause the UI to pause if it were running on the main thread
            
        finalValueTestQueue!.async {
            if(self.wcSession != nil){
                if(self.wcSession!.isReachable){
                    do{
                        try self.wcSession?.updateApplicationContext(["BeganRunningTest":"FinalValue"])
                    }catch{
                        print("error while updating application context")
                    }
                }
            }
        
                let startTestString = "01"
                let stopTestString = "00"
        
                let startTestData = Data(hexString: startTestString)
                let stopTestData = Data(hexString: stopTestString)
        
                self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
                self.testPageController!.getPeripheralDevice()?.writeValue(startTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
        
            
            DispatchQueue.main.sync {
       
                //not sure why i need to do this here - look into this
                //testProgressView
                self.testProgressView.trackTintColor = .white
                self.testProgressView.tintColor = .black
                self.view.addSubview(self.testProgressView)
                self.testProgressView.isHidden = true
                //testProgressView
                self.testProgressView.translatesAutoresizingMaskIntoConstraints = false
                self.testProgressView.setProgress(1, animated: true)
                self.testProgressView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
                self.testProgressView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
                self.testProgressView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.5)).isActive = true
                self.testProgressView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.02)).isActive = true
                //testProgressView.isHidden = true
                self.testProgressView.isHidden = false
                
                self.testProgressView.setProgress(0, animated: true)
            
                self.addTestBtn.isHidden = true //hide this button before the test starts - cannot press it when test is running as the ui will be paused anyways
                self.addTestBtn.isEnabled = false
            
                self.showToast(controller: self, message: "Fill Strip With Sample", seconds: 2)
           
            }
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)){ //need to wait one extra three seconds before pausing until not nil/pausing until not 0 for the ui to update and display the progress bar and for the "Insert Strip" toast to display
                
            var timeElapsed: Int? = nil
            
            self.testQueue = DispatchQueue(label: "Test Queue", attributes: .concurrent)
            
            let group = DispatchGroup() //allows you to pause execution until value is not nil and non-zero
            group.enter()
            
            self.testQueue!.sync {
                self.pauseUntilNotNil()

                if(self.testType == 0){ //this line is accessing the pickerview in settings so it has to be called on the main thread
                    timeElapsed = self.pauseUntilNonZero()
                    
                    print("elapsed time : " + String(timeElapsed!))
                }
                
                group.leave()
            
            }
           
            group.wait() //this is where the execution is paused
            
            self.testQueue = nil
            
            if(self.testType == 0){
                print("PRINT AFTER 10 SECONDS !!!!!!!!!!") //this is just a check to see if it paused syncronously
            }
        
                
                var zeroAfterTen: Bool? = nil
                
                if(self.testPageController!.getIntegratedVoltageValue()! > 0){ //find whether integratedVoltageValue is 0 after 10 seconds
                    zeroAfterTen = false
                }
                else{
                    zeroAfterTen = true
                }
        
                //not sure if this is the best method to delay - look into this
                let currentTime = DispatchTime.now()
                
                var testDuration = 0
                DispatchQueue.main.sync{
                    testDuration = self.menuView!.getSettingsView().getTestDuration() //this must be done on the ui thread because it is pulling from the pickerView in settingsView
                }
        
            //upadte the progress bar - make it appear that test is running
                self.finalValueTestQueue!.asyncAfter(deadline: currentTime + .seconds(testDuration * 1/4)){
                    DispatchQueue.main.sync {
                        self.testProgressView.setProgress(0.25, animated: true)
                    }
                }
                self.finalValueTestQueue!.asyncAfter(deadline: currentTime + .seconds(testDuration * 1/2 )){
                    DispatchQueue.main.sync {
                        self.testProgressView.setProgress(0.5, animated: true)
                    }
                }
                self.finalValueTestQueue!.asyncAfter(deadline: currentTime + .seconds(testDuration * 3/4)){
                    DispatchQueue.main.sync {
                         self.testProgressView.setProgress(0.75, animated: true)
                    }
                }
                self.finalValueTestQueue!.asyncAfter(deadline: currentTime + .seconds(testDuration)){
                    
                    var isManualCalibration = false
                    var manualMVal: Float = 0.0
                    var manualBVal: Float = 0.0
                    var testType = 0
                    
                    DispatchQueue.main.sync { //getting things from settings deals with reading from UIPickers which needs to be done on the UIThread (main thread)
                        self.testProgressView.setProgress(1, animated: true)
                        
                        self.testProgressView.isHidden = true
                        
                        isManualCalibration = (self.menuView?.getSettingsView().getManualCalibrationSwitchValue())! //check if manual calibration is set in the settings
                        
                        if(isManualCalibration){
                            manualMVal = (self.menuView?.getSettingsView().getManCalMVal())! //if manual calibration is set in the settings then get the proper slope value
                            manualBVal = (self.menuView?.getSettingsView().getManCalBVal())! //if manual calibration is set in the settings then get the proper origin value
                        }
                        
                        testType = (self.menuView?.getSettingsView().getTestType())!
                    }
            
            
                    var glucoseResult: Float? //this should in fact say "FINAL result" instead of "glucose result" - this will be the final result after conversion from mV to whichever unit being measured (immunoglobulins, lactoferrin, blood calcium or glucose)
            
                    //display integratedVoltageValue before stopping the test, or else integratedVoltageValue will be reset to 0 before being displayed when the capacitor is discharged upon stopping the test
//                    if(self.integratedVoltageValue == nil){ //will never happen now since it waits until integratedVoltageValue is not 0 to start the test
//                        glucoseResult = nil
//                    }
                    if(self.testPageController!.getIntegratedVoltageValue()! != 0){ //these equations will convert the value from a voltage to an interpreted result for the user
                        switch testType{
                        case 0: //Immunoglobulins
                            if(isManualCalibration){//if manual calibration set it will use the manual m and b values
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!) * manualMVal) + manualBVal
                            }
                            else{ //if manual calibration not set it will use this equation
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!) * 2.3345) - 46.107
                            }
                    
                        case 1: //Lactoferrin
                            if(isManualCalibration){
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!) * manualMVal) + manualBVal
                            }
                            else{
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109
                            }
                    
                        case 2: //Blood Calcium
                            if(isManualCalibration){
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!) * manualMVal) + manualBVal
                            }
                            else{
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109
                            }
                    
                        case 3: //Generic Glucose
                            if(isManualCalibration){
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!) * manualMVal) + manualBVal
                            }
                            else{
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109
                            }
                            
                        default:
                            if(isManualCalibration){
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!) * manualMVal) + manualBVal
                            }
                            else{
                                glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109
                            }
                        }
                    }
                    else if(self.testPageController!.getIntegratedVoltageValue()! == 0 && zeroAfterTen == true){ //if it was zero for the entire length of the test - proper 0 result
                        glucoseResult = 0.00 //change this to 0.00 after the demo
                    }
                    else{ //if it was 0 after 10s but not zero after 20 - too late to push in strip - give error message
                        glucoseResult = nil
                    }
            
            
            if(glucoseResult != nil){ //if it is nil it will show that there was an error - if not nil then probably not an error unless disconnectedDevice is set to true which it will check for
                
                    //fix negative glucose results from the voltage being too low to satisfy the equation accurately (just assume 0 in this case)
                    if(glucoseResult! < Float(0.0)){
                        glucoseResult = 0.00
                    }
                
                
                DispatchQueue.main.sync {
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
                }

                
                if(glucoseResult! < Float(3.0)){
                    DispatchQueue.main.sync {
                        self.testResultLabel.textColor = .red
                        self.testResultProgressBar.tintColor = .red
                    }
                    
                }
                else if(glucoseResult! >= Float(3.0) && glucoseResult! < Float(4.0)){
                    DispatchQueue.main.sync {
                        self.testResultLabel.textColor = .yellow
                        self.testResultProgressBar.tintColor = .yellow
                    }
                    
                }
                else if(glucoseResult! >= Float(4.0) && glucoseResult! < Float(8.0)){
                    DispatchQueue.main.sync{
                        self.testResultLabel.textColor = .green
                        self.testResultProgressBar.tintColor = .green
                    }
                    
                }
                else if(glucoseResult! >= Float(8.0) && glucoseResult! < Float(12.0)){
                    DispatchQueue.main.sync{
                        self.testResultLabel.textColor = .yellow
                        self.testResultProgressBar.tintColor = .yellow
                    }
                }
                else{
                    DispatchQueue.main.sync {
                        self.testResultLabel.textColor = .red
                        self.testResultProgressBar.tintColor = .red
                    }
                }
                
                
                    if(glucoseResult! == 0.0 && self.testType == 0){ //glucoseResult == 0 and immunoglobulins test
                        DispatchQueue.main.sync{
                        self.testResultLabel.font = self.testResultLabel.font.withSize(30) //adjust font size
                        self.testResultLabel.text = String(format: "%.2f", glucoseResult!) + "-20.00 mg/mL"
                        }
                    }
                    else if(self.testType == 0){ //immunoglobulins test (changes units)
                        DispatchQueue.main.sync{
                            self.testResultLabel.text = String(format: "%.2f", glucoseResult!) + "mg/mL"
                        }
                    }
                    else{
                        DispatchQueue.main.sync {
                            self.testResultLabel.text = String(format: "%.2f", glucoseResult!) + "mmol/L"
                        }
                    }
                
                DispatchQueue.main.sync {
                    self.testResultLabel.isHidden = false
                    
                    self.testResultProgressBar.isHidden = false
                    self.testResultProgressBar.setProgress(Float(glucoseResult! / Float(30)), animated: true)
                    
                    self.testResultToSave = glucoseResult
                    
                    self.saveTestBtn.isEnabled = true
                    self.saveTestBtn.isHidden = false
                    
                    if(self.disconnectedDevice == true){
                        self.showToast(controller: self, message: "Device Disconnected During Test. This Could be a False Result", seconds: 3)
                    }
                    
                }
        
                
            }
            else{ //if glucoseResult == nil
                DispatchQueue.main.sync{
                    self.showToast(controller: self, message: "Error Occured While Testing. Strip May Have Been Filled With Sample Too Late After Timer Finished.", seconds: 3)
                }
            }
            
            //self.peripheralDevice?.writeValue(stopTestData!, for: self.startTestCharacteristic!, type: .withResponse) //discharge capacitor - probably better to discharge after pressing resetTestButton
                    if(self.wcSession != nil){
            if(self.wcSession!.isReachable){
                do{
                    try self.wcSession?.updateApplicationContext(["FinalValueTestResult":glucoseResult!])
                }catch{
                    print("error while updating application context")
                }
            }
            }
            
                    DispatchQueue.main.sync {
                        self.resetTestBtn.isEnabled = true
                        self.resetTestBtn.isHidden = false
                    }
                    
                    var herdID: String? = nil
                    var cowID: String? = nil
                    var timeString: String? = nil
                    
                    
                    DispatchQueue.main.async{
                        herdID = self.testHerdIDLabel.text
                        cowID = self.testCowIDLabel.text
                        timeString = self.testDateLabel.text
                    }
            
            
            //send notification if app is in background
            self.appDelegate!.getNotificationCenter().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = "Test Complete"
                    if(self.chooseCowAtBeginning == false){
                        var bodyString = "Your test is complete for Test Date: "
                        bodyString += timeString!
                        content.body = bodyString
                    }
                    else{
                        var bodyString = "Your test is compelte for "
                        bodyString += herdID!
                        bodyString += ", "
                        bodyString += cowID!
                        bodyString += ", Test Date: "
                        bodyString += timeString!
                        
                        content.body = bodyString
                    }
                    content.sound = UNNotificationSound.default
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
                    let identifier = "Local Test Finished Notification" + String(self.pageID!)
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
        
        
        
    }
    
    
    
    //will puase execution of the test until it reads a non-nil value from the device
    private func pauseUntilNotNil(){
        while(true){
            if(self.testPageController!.getIntegratedVoltageValue() != nil){
                break
            }
        }
        
        return
    }
    
    
    
    //will pause execution of the test until it reads a non-zero value from the device
    private func pauseUntilNonZero() -> Int{
        let startingTime = DispatchTime.now()
        var endingTime = DispatchTime.now()
        

        while(Int((endingTime.uptimeNanoseconds - startingTime.uptimeNanoseconds) / 1000000000) <= 10){
            print(Int((endingTime.uptimeNanoseconds - startingTime.uptimeNanoseconds) / 1000000000))
            //print("integrating voltage: " + String(self.integratedVoltageValue!))
            if(self.testPageController!.getIntegratedVoltageValue()! > 15){ //if bigger than 15mV, start test
                break //break out of the loop once the integrated voltage value is not equal to 0
            }
            endingTime = DispatchTime.now()
                
        }
        
        
        return Int((endingTime.uptimeNanoseconds - startingTime.uptimeNanoseconds) / 1000000000) //returns difference in time in seconds
        
    }
    
    
    
    
    //if continuous test is set in settings this testing process will run
    private func runContinuousTest(){
        
        continuousValueTestQueue = DispatchQueue(label: "Continuous Value Test Queue", attributes: .concurrent)
        
        continuousValueTestQueue?.async {
        
            if(self.wcSession != nil){
                if(self.wcSession!.isReachable){
                    do{
                        try self.wcSession?.updateApplicationContext(["BeganRunningTest":"ContinuousValue"])
                    }catch{
                        print("error while updating application context")
                    }
                }
            }
        
            let startTestString = "01"
            let stopTestString = "00"
        
            let startTestData = Data(hexString: startTestString)
            let stopTestData = Data(hexString: stopTestString)
        
            self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
            self.testPageController!.getPeripheralDevice()?.writeValue(startTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
        
            DispatchQueue.main.sync {
                //not sure why i need to do this here - look into this
                //testProgressView
                self.testProgressView.trackTintColor = .white
                self.testProgressView.tintColor = .black
                self.view.addSubview(self.testProgressView)
                self.testProgressView.isHidden = true
                //testProgressView
                self.testProgressView.translatesAutoresizingMaskIntoConstraints = false
                self.testProgressView.setProgress(1, animated: true)
                self.testProgressView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
                self.testProgressView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
                self.testProgressView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.5)).isActive = true
                self.testProgressView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.02)).isActive = true
                //testProgressView.isHidden = true
                self.testProgressView.isHidden = false
                
                self.addTestBtn.isHidden = true //hide this button before the test starts - cannot press it when test is running as the ui will be paused anyways
                self.addTestBtn.isEnabled = false
                
                self.testProgressView.setProgress(0, animated: true)
                
            }
        
            
            self.testQueue = DispatchQueue(label: "Test Queue", attributes: .concurrent)
            
            let group = DispatchGroup() //allows you to pause execution until value is not nil and non-zero
            group.enter()

            self.testQueue!.sync{ //SINCE YOU ARE RUNNING SYNC HERE YOU DONT NEED THE DISPATCH GROUP TO WAIT - YOU CAN REMOVE IT
                self.pauseUntilNotNil()
                
                group.leave()
            }
       
            group.wait()
        
            //print(integratedVoltageValue)
        
            DispatchQueue.main.sync {
                self.readNewContinuousData() 
            }
            
            
            var timer = Timer()
            DispatchQueue.main.sync{ //reads new continuous value data from the device
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.readNewContinuousData), userInfo: nil, repeats: true) //fires every 1 second - readNewContinuousData runs every second starting at 1s
            }
            
            //testing purposes
            print("\n\nstarting test")
            
            var testTimer = Timer()
            DispatchQueue.main.sync{ //reads new voltage value from the device - this is for testing purposes (printing the voltage values to the debug panel)
                testTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.readNewVoltage), userInfo: nil, repeats: true)
            }
            
            
        
            //not sure if this is the best method to delay - look into this
            let currentTime = DispatchTime.now()
            var testDuration: Int? = nil
            DispatchQueue.main.sync{
                testDuration = self.menuView!.getSettingsView().getTestDuration()
            }
        
            //update progress bar to show that test is running
            self.continuousValueTestQueue!.asyncAfter(deadline: currentTime + .seconds(testDuration! * 1/4)){
                DispatchQueue.main.sync {
                    self.testProgressView.setProgress(0.25, animated: true)
                }
            }
            self.continuousValueTestQueue!.asyncAfter(deadline: currentTime + .seconds(testDuration! * 1/2 )){
                DispatchQueue.main.sync {
                    self.testProgressView.setProgress(0.5, animated: true)
                }
            }
            self.continuousValueTestQueue!.asyncAfter(deadline: currentTime + .seconds(testDuration! * 3/4)){
                DispatchQueue.main.sync {
                    self.testProgressView.setProgress(0.75, animated: true)
                }
            }
            self.continuousValueTestQueue!.asyncAfter(deadline: currentTime + .seconds(testDuration!)){
                timer.invalidate() //stops timer from running/firing
            
                //testing purposes
                print("end of test\n\n")
                testTimer.invalidate()
            
                DispatchQueue.main.sync {
                    self.testProgressView.setProgress(1, animated: true)
                    
                    self.testProgressView.isHidden = true
                    
                   
                    self.glucoseResultTable.reloadData()
                    self.glucoseResultTable.isHidden = false
                }
            
                print(self.peripheralData.count)
                
                //populate the graph data
                for i in 0...testDuration!{ //should only happen 0 - testDuration times
                    let dataEntry = ChartDataEntry(x: Double(i), y: Double(self.peripheralData[i]))
                    self.dataEntries.append(dataEntry)
                }
            
                DispatchQueue.main.sync {
                    //print graph of results here
                    self.lineChartView.isHidden = false
                    let lineChartDataSet = LineChartDataSet(entries: self.dataEntries, label: "Glucose Results")
                    let lineChartData = LineChartData(dataSet: lineChartDataSet)
                    self.lineChartView.data = lineChartData
                    self.lineChartView.xAxis.granularity = 1
                    self.lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
                    self.lineChartView.setVisibleXRangeMaximum(5.0) //causes you to have to scroll to see the rest of the values
                    self.lineChartView.setVisibleYRangeMaximum(32.0, axis: self.lineChartView.leftAxis.axisDependency) //causes you to have to scroll to see the rest of the values
                    //self.lineChartView.setVisibleYRangeMaximum(32.0, axis: self.lineChartView.rightAxis.axisDependency) //causes you to have to scroll to see the rest of the values
                    
                    self.lineChartView.rightAxis.drawAxisLineEnabled = false
                    self.lineChartView.rightAxis.drawLabelsEnabled = false
                    
                    self.lineChartView.moveViewToX(0.0) //initially display the graph starting at index of 0
                    self.lineChartView.moveViewToY(0.0, axis: self.lineChartView.leftAxis.axisDependency)
                    //self.lineChartView.moveViewToY(0.0, axis: self.lineChartView.rightAxis.axisDependency)
                    self.lineChartView.isHidden = false
                }
            
                self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
            
                //sending the final value of the result set
                if(self.wcSession != nil){
                    if(self.wcSession!.isReachable){
                        do{
                            try self.wcSession?.updateApplicationContext(["ContinuousValueFinalTestResult":self.peripheralData.last!])
                        }catch{
                            print("error while updating application context")
                        }
                    }
                }
            
                self.testResultToSave = self.peripheralData.last
            
                DispatchQueue.main.sync {
                    self.resetTestBtn.isEnabled = true
                    self.resetTestBtn.isHidden = false
                    self.saveTestBtn.isEnabled = true
                    self.saveTestBtn.isHidden = false
                    
                    
                    if(self.disconnectedDevice == true){
                        self.showToast(controller: self, message: "Device Disconnected During Test. This Could be a False Result", seconds: 3)
                    }
                }
            
                var herdID: String? = nil
                var cowID: String? = nil
                var timeString: String? = nil
            
                DispatchQueue.main.async{
                    herdID = self.testHerdIDLabel.text
                    cowID = self.testCowIDLabel.text
                    timeString = self.testDateLabel.text
                }
            
                //send notifiation if app is in background
                self.appDelegate!.getNotificationCenter().getNotificationSettings { (settings) in
                    if settings.authorizationStatus == .authorized {
                        let content = UNMutableNotificationContent()
                        content.title = "Test Complete"
                        if(self.chooseCowAtBeginning == false){
                            var bodyString = "Your test is complete for Test Date: "
                            bodyString += timeString!
                            content.body = bodyString
                        }
                        else{
                            var bodyString = "Your test is compelte for "
                            bodyString += herdID!
                            bodyString += ", "
                            bodyString += cowID!
                            bodyString += ", Test Date: "
                            bodyString += timeString!
                        
                            content.body = bodyString
                        }
                        content.sound = UNNotificationSound.default
                        content.badge = 1
                    
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
                        let identifier = "Local Test Finished Notification" + String(self.pageID!)
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
    }
    
    

    @objc private func readNewContinuousData(){
    
        var glucoseResult: Float?
        
        //print(integratedVoltageValue)
        
        var intVoltageValue: Int? = nil
        //DispatchQueue.main.sync {
            intVoltageValue = self.testPageController!.getIntegratedVoltageValue()!
        //}
        
        if(intVoltageValue == nil){
            glucoseResult = nil
        }
        else if(intVoltageValue! != 0){ //will give positive value of glucose (depends which strip is used)
            
            //print(Float(Float(self.integratedVoltageValue!) / Float(1000)))
            var testType: Int? = nil
            
           // DispatchQueue.main.sync {
                testType = self.menuView?.getSettingsView().getTestType()
            //}
            
            switch testType{ //continuous results will not use the manual calibration - only final results will. Continuous will always use the equations that are hardcoded in here
                case 0: //Immunoglobulins
                    //DispatchQueue.main.sync {
                        glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109 //this is measured/based off the integrated voltage after 10s
                    //}
                
                case 1: //Lactoferrin
                    //DispatchQueue.main.sync {
                        glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109 //this is measured/based off the integrated voltage after 10s
                    //}
                
                case 2: //Blood Calcium
                    //DispatchQueue.main.sync {
                        glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109 //this is measured/based off the integrated voltage after 10s
                    //}
                
                case 3: //Generic Glucose
                    //DispatchQueue.main.sync {
                        glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109 //this is measured/based off the integrated voltage after 10s
                    //}
                
                default:
                    //DispatchQueue.main.sync {
                        glucoseResult = Float(Float(self.testPageController!.getIntegratedVoltageValue()!)) / 33.109 //this is measured/based off the integrated voltage after 10s
                    //}
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
    
    //testing purposes - will print voltage values to the screen
    @objc private func readNewVoltage(){
        
        var intVoltageValue: Int? = nil
        //DispatchQueue.main.sync {
            intVoltageValue = self.testPageController!.getIntegratedVoltageValue()
        //}
        
        if(intVoltageValue == nil){
            print("nil")
        }
        else{
            print(intVoltageValue!)
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
    
    
    override public func viewWillAppear(_ animated: Bool) {
        if(self.testPageController!.getPeripheralDevice() == nil){
            connectedDeviceLabel.text = "Connected Device: None"
        }
        else{
            connectedDeviceLabel.text = "Connected to: " + ((self.testPageController!.getPeripheralDevice()?.name)!)
        }
        
        if(menuView!.getSettingsView().getFinalContinuous() == true){
            testTypeLabel.text = "Test Type: Final Value Test"
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestTypeLabelRunTest":"Final"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
        }
        else{
            testTypeLabel.text = "Test Type: Continuous Test"
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestTypeLabelRunTest":"Continuous"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
        }
        
        testDurationLabel.text = "Test Duration: " + String(menuView!.getSettingsView().getTestDuration()) + " seconds"
        if(wcSession != nil){
        if(wcSession!.isReachable){
            //print("Sending test duration label")
            
            do{
                try wcSession?.updateApplicationContext(["TestDurationLabelRunTest":String(menuView!.getSettingsView().getTestDuration()) + "s"])
            }catch{
                print("error while updating application context")
            }
        }
        }
        
        
        
        if(menuView?.getSettingsView().getTestType() == 0){
            actualTestTypeLabel.text = "Test Type: Immunoglobulins"
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestSampleLabelRunTest":"Immunoglobulins"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
        }
        else if(menuView?.getSettingsView().getTestType() == 1){
            actualTestTypeLabel.text = "Test Type: Lactoferrin"
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestSampleLabelRunTest":"Lactoferrin"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
        }
        else if(menuView?.getSettingsView().getTestType() == 2){
            actualTestTypeLabel.text = "Test Type: Blood Calcium"
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestSampleLabelRunTest":"Blood Calcium"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
        }
        else{
            actualTestTypeLabel.text = "Test Type: Glucose"
            if(wcSession != nil){
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestSampleLabelRunTest":"Glucose"])
                }catch{
                    print("error while updating application context")
                }
            }
            }
        }
//        if(wcSession!.isReachable){
//            wcSession!.sendMessage(["TestTypeLabel":testTypeLabel.text], replyHandler: nil, errorHandler: nil)
//            wcSession!.sendMessage(["TestDurationLabel":testDurationLabel.text], replyHandler: nil, errorHandler: nil)
//        }
        
        
        testType = menuView!.getSettingsView().getTestType() //set test type every time view will load
        
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
        case "RunTestPrompt": //NEED TO CHANGE THIS SO THAT IT OPENS A NEW TEST WINDOW AND STARTS THE NEW TEST ON THIS TEST WINDOW
            DispatchQueue.main.async {
                if(self.startTestBtn.isEnabled){
                    self.setChooseCowAtBeginning(bool: false)
                    self.startTestBtnPressed()
                }
                    
                else if(self.addTestBtn.isEnabled){
                    self.addTestBtnPressed() //add test page
                    self.testPageController?.getTestPages().last!.setChooseCowAtBeginning(bool: false) //set chooseCowAtBeginning for the test page that was added
                    self.testPageController?.getTestPages().last!.startTestBtnPressed() //start test on the new test page that was added
                    
                    //go to the new test page
                    self.testPageController?.setViewControllers([(self.testPageController?.getTestPages().last)!], direction: .forward, animated: true, completion: nil)
                    self.testPageController?.pageControl.currentPage = (self.testPageController?.getTestPages().count)! - 1
                    
                }
                    
                else if (self.resetTestBtn.isEnabled){
                    self.addTestBtnPressed() //add test page
                    self.testPageController?.getTestPages().last!.setChooseCowAtBeginning(bool: false) //set chooseCowAtBeginning for the test page that was added
                    self.testPageController?.getTestPages().last!.startTestBtnPressed() //start test on the new test page that was added
                    
                    //go to the new test page
                    self.testPageController?.setViewControllers([(self.testPageController?.getTestPages().last)!], direction: .forward, animated: true, completion: nil)
                    self.testPageController?.pageControl.currentPage = (self.testPageController?.getTestPages().count)! - 1
                    
                }
                    
                else{ //some point during the test where you cannot add another test
                    if(self.wcSession != nil){
                    if(self.wcSession!.isReachable){
                        do{
                            try self.wcSession?.updateApplicationContext(["CannotStartNewTest":"Error"])
                        }catch{
                            print("error while updating application context")
                        }
                    }
                    }
                }
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
    
    public func getConnectedDeviceLabel() -> UILabel{
        return connectedDeviceLabel
    }
    
    public func setChooseCowAtBeginning(bool: Bool){
        chooseCowAtBeginning = bool
    }
    
    public func setPageID(id: Int?){
        pageID = id
    }
    
    public func getPageID() -> Int?{
        return pageID
    }
    
    
    
    public func deviceDisconnected(){
        self.disconnectedDevice = true
        
        if(self.cancelTestBtn.isHidden == false){
            self.cancelTestBtnPressed()
        }
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

@available(iOS 12.0, *)
extension TestViewController {

    func activateActivity(){
        userActivity = NSUserActivity(activityType: "RunATest")
        let title = "Run a CPS Test"
        userActivity?.title = title
        userActivity?.userInfo = ["id": title]
        userActivity?.suggestedInvocationPhrase = "Run a CPS Test"
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
extension TestViewController: INUIAddVoiceShortcutViewControllerDelegate {
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
