//
//  BloodCalciumTestViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-07-06.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//
import UIKit
import CoreBluetooth
import Charts //using the Charts framework - done using the tutorial https://www.appcoda.com/ios-charts-api-tutorial/
import WatchConnectivity
import UserNotifications
import CoreData
import IntentsUI
import GradientProgressBar
import MessageUI

public class SingleStripTestViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    //global vars
    var testDate: Date? = nil
    var herdToSave: Herd? = nil
    var cowToSave: Cow? = nil
    var testResultToSave: Float? = nil
    var testFollowUpNumberToSave: NSNumber? = nil
    var signsOfMilkFever: Bool? = nil
    var followUpTestArray: [Test] = []
    var cancelTestFlag: Bool = false
    var units: String? = nil
    var selectingHerdCowFromList: Bool = false
    var savableTest: Bool = true
    
    var battLevel: Double = 0
    var tempLevel: Double = 0
    
    var tempVoltageLabelKeepHidden = false
    var batteryVoltageLabelKeepHidden = false
    
    var url: URL? = nil
    
    let group = DispatchGroup()
    
    var testTimer = Timer()
    var tempBatTimer = Timer()
    
    //views
    private var appDelegate: AppDelegate? = nil
    private var menuView: MenuViewController? = nil
    private var testPageController: SingleStripTestPageViewController? = nil
    private var recommendationView: RecommendationViewController? = nil
    
    //buttons
    private var startTestBtn = UIButton()
    private var saveTestBtn = UIButton()
    private var discardTestBtn = UIButton()
    private var cancelTestBtn = UIButton()
    private var recommendationBtn = UIButton()
    private var severeHypocalcemiaRecommendationBtn = UIButton()
    private var subClinicalHypocalcemiaRecommendationBtn = UIButton()
    private var normalCalcemiaRecommendationBtn = UIButton()
    private var retestBtn = UIButton()
    
    //labels
    private var connectedDeviceLabel = UILabel()
    private var tempVoltageLabel = UILabel()
    private var batteryVoltageLabel = UILabel()
    private var testResultLabel = UILabel()
    private var testDateLabel = UILabel()
    private var zoneSpecificRecommendationLabel = UILabel()
    private var waitingLabel = UILabel()
    
    //UIProgressView
    private let testProgressView = UIProgressView(progressViewStyle: UIProgressView.Style.default)
    private let testResultProgressBar = UIProgressView(progressViewStyle: UIProgressView.Style.default)
    private let testProgressIndicator = UIImageView()
    
    //recommendationBoxes
    private let recommendationBoxLeft = UIImageView()
    private let recommendationBoxMiddle = UIImageView()
    private let recommendationBoxRight = UIImageView()
    
    //pageID
    private var pageID: Int? = nil
    
    private var disconnectedDevice = false
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(appDelegate: AppDelegate?, menuView: MenuViewController?, testPageController: SingleStripTestPageViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.appDelegate = appDelegate
        self.menuView = menuView
        self.testPageController = testPageController
        self.recommendationView = RecommendationViewController(appDelegate: appDelegate, menuView: menuView)
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Single Strip Test"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupLayoutComponents()
        setupLayoutConstraints()
        setupButtonListeners()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        
        print("VIEW DID APPEAR")
        
        if(selectingHerdCowFromList){
            if(herdToSave == nil || cowToSave == nil){
                self.showToast(controller: self, message: "Did Not Select Either a Herd, a Cow or Both", seconds: 2)
                return
            }
            else{
                self.setSignsOfMilkFever()
            }
        }
        
    }
    
    
    private func setupLayoutComponents(){
        
        //startTestBtn
        startTestBtn.backgroundColor = .blue
        startTestBtn.setTitle("Start Test", for: .normal)
        startTestBtn.setTitleColor(.white, for: .normal)
        startTestBtn.layer.borderWidth = 2
        startTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(startTestBtn)
        
        //saveTestBtn
        saveTestBtn.backgroundColor = .blue
        saveTestBtn.setTitle("Save Test", for: .normal)
        saveTestBtn.setTitleColor(.white, for: .normal)
        saveTestBtn.layer.borderWidth = 2
        saveTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(saveTestBtn)
        saveTestBtn.isHidden = true
        saveTestBtn.isEnabled = false
        
        //discardTestBtn
        discardTestBtn.backgroundColor = .blue
        discardTestBtn.setTitle("Discard Test", for: .normal)
        discardTestBtn.setTitleColor(.white, for: .normal)
        discardTestBtn.layer.borderWidth = 2
        discardTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(discardTestBtn)
        discardTestBtn.isHidden = true
        discardTestBtn.isEnabled = false
        
        //retestBtn
        retestBtn.backgroundColor = .blue
        retestBtn.setTitle("Re-test", for: .normal)
        retestBtn.setTitleColor(.white, for: .normal)
        retestBtn.layer.borderWidth = 2
        retestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(retestBtn)
        retestBtn.isHidden = true
        retestBtn.isEnabled = false
        
        //cancelTestBtn
        cancelTestBtn.backgroundColor = .blue
        cancelTestBtn.setTitle("Cancel Test", for: .normal)
        cancelTestBtn.setTitleColor(.white, for: .normal)
        cancelTestBtn.layer.borderWidth = 2
        cancelTestBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(cancelTestBtn)
        cancelTestBtn.isHidden = true
        cancelTestBtn.isEnabled = false
        
        //recommendationBtn
        recommendationBtn.backgroundColor = .blue
        //recommendationBtn.setTitle("Test-Specific Recommendations", for: .normal)
        recommendationBtn.setTitleColor(.white, for: .normal)
        recommendationBtn.layer.borderWidth = 2
        recommendationBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(recommendationBtn)
        recommendationBtn.isHidden = true
        recommendationBtn.isEnabled = false
        
        
        //connectedDeviceLabel
        if(self.testPageController!.getPeripheralDevice() == nil){
            connectedDeviceLabel.text = "Connected Device: None"
            if(self.testPageController?.getTemperatureVoltageValue() != nil){
                self.tempVoltageLabel.isHidden = false
                self.tempVoltageLabel.text = "Temperature Voltage: " + String((self.testPageController?.getTemperatureVoltageValue())!)
            }
            if(self.testPageController?.getBatteryVoltageValue() != nil){
                self.batteryVoltageLabel.isHidden = false
                self.batteryVoltageLabel.text = "Battery Voltage: " + String((self.testPageController?.getBatteryVoltageValue())!)
            }
        }
        else{
            connectedDeviceLabel.text = "Connected to: " + (self.testPageController!.getPeripheralDevice()?.name)!
            self.tempVoltageLabel.isHidden = true
            self.batteryVoltageLabel.isHidden = true
        }
        connectedDeviceLabel.textColor = .black //will be set based on test results
        connectedDeviceLabel.font = testResultLabel.font.withSize(20) //adjust font size
        connectedDeviceLabel.textAlignment = .center
        view.addSubview(connectedDeviceLabel)
        
        tempVoltageLabel.textColor = .black //will be set based on test results
        tempVoltageLabel.font = testResultLabel.font.withSize(20) //adjust font size
        tempVoltageLabel.textAlignment = .center
        view.addSubview(tempVoltageLabel)
        
        batteryVoltageLabel.textColor = .black //will be set based on test results
        batteryVoltageLabel.font = testResultLabel.font.withSize(20) //adjust font size
        batteryVoltageLabel.textAlignment = .center
        view.addSubview(batteryVoltageLabel)
        
        
        //testResultLabel
        testResultLabel.text = "" //will be filled out with the test result
        testResultLabel.textColor = .green //will be set based on test results
        testResultLabel.font = testResultLabel.font.withSize(50) //adjust font size
        testResultLabel.textAlignment = .center
        view.addSubview(testResultLabel)
        testResultLabel.isHidden = true
        
        waitingLabel.text = "Waiting for strip to be filled..."
        waitingLabel.textColor = .black
        waitingLabel.font = waitingLabel.font.withSize(20) //adjust font size
        waitingLabel.textAlignment = .center
        waitingLabel.numberOfLines = 2
        view.addSubview(waitingLabel)
        waitingLabel.isHidden = true
        
        
        //testDateLabel
        testDateLabel.text = "" //will be filled out with the test result
        testDateLabel.textColor = .black //will be set based on test results
        testDateLabel.font = testResultLabel.font.withSize(20) //adjust font size
        testDateLabel.textAlignment = .center
        view.addSubview(testDateLabel)
        testDateLabel.isHidden = true
        
        //zoneSpecificRecommendationLabel
        zoneSpecificRecommendationLabel.text = "* Click anywhere on the gradient to view CPS's zone-specific recommendations *" //will be filled out with the test result
        zoneSpecificRecommendationLabel.textColor = .black //will be set based on test results
        zoneSpecificRecommendationLabel.font = zoneSpecificRecommendationLabel.font.withSize(15) //adjust font size
        zoneSpecificRecommendationLabel.textAlignment = .center
        zoneSpecificRecommendationLabel.numberOfLines = 2
        view.addSubview(zoneSpecificRecommendationLabel)
        zoneSpecificRecommendationLabel.isHidden = true
        
        
        //testResultProgressBar
        self.testResultProgressBar.progressImage = UIImage(named: "testGradient")
        self.view.addSubview(self.testResultProgressBar)
        self.testResultProgressBar.isHidden = true
        
        //these have to be added to the view after the testResultProgressBar so that they can be pressed on top of it
//        severeHypocalcemiaRecommendationBtn.backgroundColor = .blue
//        severeHypocalcemiaRecommendationBtn.setTitle("Severe Hypo", for: .normal)
//        severeHypocalcemiaRecommendationBtn.setTitleColor(.white, for: .normal)
//        severeHypocalcemiaRecommendationBtn.layer.borderWidth = 2
//        severeHypocalcemiaRecommendationBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(severeHypocalcemiaRecommendationBtn)
        severeHypocalcemiaRecommendationBtn.isHidden = true
        severeHypocalcemiaRecommendationBtn.isEnabled = false
        
//        subClinicalHypocalcemiaRecommendationBtn.backgroundColor = .blue
//        subClinicalHypocalcemiaRecommendationBtn.setTitle("Subclinical Hypo", for: .normal)
//        subClinicalHypocalcemiaRecommendationBtn.setTitleColor(.white, for: .normal)
//        subClinicalHypocalcemiaRecommendationBtn.layer.borderWidth = 2
//        subClinicalHypocalcemiaRecommendationBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(subClinicalHypocalcemiaRecommendationBtn)
        subClinicalHypocalcemiaRecommendationBtn.isHidden = true
        subClinicalHypocalcemiaRecommendationBtn.isEnabled = false
        
//        normalCalcemiaRecommendationBtn.backgroundColor = .blue
//        normalCalcemiaRecommendationBtn.setTitle("Normal Calc", for: .normal)
//        normalCalcemiaRecommendationBtn.setTitleColor(.white, for: .normal)
//        normalCalcemiaRecommendationBtn.layer.borderWidth = 2
        view.addSubview(normalCalcemiaRecommendationBtn)
        normalCalcemiaRecommendationBtn.isHidden = true
        normalCalcemiaRecommendationBtn.isEnabled = false
        
        
        //testProgressIndicator
        testProgressIndicator.image = UIImage(named: "arrowIndicator")
        self.view.addSubview(self.testProgressIndicator)
        testProgressIndicator.isHidden = true
        
        //recommendationBoxLeft
        //recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftNoMilkFever")
        self.view.addSubview(recommendationBoxLeft)
        recommendationBoxLeft.isHidden = true
        
        //recommendationBoxMiddle
        //recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleNoMilkFever")
        self.view.addSubview(recommendationBoxMiddle)
        recommendationBoxMiddle.isHidden = true
        
        //recommendationBoxRight
        //recommendationBoxRight.image = UIImage(named: "recommendationBoxRightNoMilkFever")
        self.view.addSubview(recommendationBoxRight)
        recommendationBoxRight.isHidden = true
        
        
        //testProgressView
        self.testProgressView.trackTintColor = .white
        self.testProgressView.tintColor = .black
        self.view.addSubview(self.testProgressView)
        self.testProgressView.isHidden = true
    }
    
    private func setupLayoutConstraints(){
        //startTestBtn
        startTestBtn.translatesAutoresizingMaskIntoConstraints = false
        startTestBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        startTestBtn.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        startTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        startTestBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        
        //connectedDevicesLabel
        connectedDeviceLabel.translatesAutoresizingMaskIntoConstraints = false
        connectedDeviceLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        connectedDeviceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
        
        tempVoltageLabel.translatesAutoresizingMaskIntoConstraints = false
        tempVoltageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        tempVoltageLabel.topAnchor.constraint(equalTo: connectedDeviceLabel.topAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        
        batteryVoltageLabel.translatesAutoresizingMaskIntoConstraints = false
        batteryVoltageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        batteryVoltageLabel.topAnchor.constraint(equalTo: tempVoltageLabel.topAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        
        
        //testResultLabel
        testResultLabel.translatesAutoresizingMaskIntoConstraints = false
        testResultLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testResultLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        //testDateLabel
        testDateLabel.translatesAutoresizingMaskIntoConstraints = false
        testDateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        testDateLabel.topAnchor.constraint(equalTo: connectedDeviceLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
    
        //discardTestBtn
        discardTestBtn.translatesAutoresizingMaskIntoConstraints = false
        discardTestBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        discardTestBtn.topAnchor.constraint(equalTo: testDateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        discardTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        //saveTestBtn
        saveTestBtn.translatesAutoresizingMaskIntoConstraints = false
        saveTestBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveTestBtn.topAnchor.constraint(equalTo: discardTestBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        saveTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        cancelTestBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelTestBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelTestBtn.topAnchor.constraint(equalTo: saveTestBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        cancelTestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        retestBtn.translatesAutoresizingMaskIntoConstraints = false
        retestBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        retestBtn.topAnchor.constraint(equalTo: saveTestBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        retestBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        waitingLabel.translatesAutoresizingMaskIntoConstraints = false
        waitingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waitingLabel.topAnchor.constraint(equalTo: cancelTestBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        waitingLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        
        self.testResultProgressBar.translatesAutoresizingMaskIntoConstraints = false
        self.testResultProgressBar.setProgress(1, animated: true)
        self.testResultProgressBar.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.testResultProgressBar.topAnchor.constraint(equalTo: self.zoneSpecificRecommendationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        self.testResultProgressBar.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.75)).isActive = true
        self.testResultProgressBar.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        severeHypocalcemiaRecommendationBtn.translatesAutoresizingMaskIntoConstraints = false
        severeHypocalcemiaRecommendationBtn.topAnchor.constraint(equalTo: self.zoneSpecificRecommendationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        severeHypocalcemiaRecommendationBtn.leftAnchor.constraint(equalTo: self.testResultProgressBar.leftAnchor).isActive = true
        severeHypocalcemiaRecommendationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.2925)).isActive = true
        severeHypocalcemiaRecommendationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        subClinicalHypocalcemiaRecommendationBtn.translatesAutoresizingMaskIntoConstraints = false
        subClinicalHypocalcemiaRecommendationBtn.topAnchor.constraint(equalTo: self.zoneSpecificRecommendationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        subClinicalHypocalcemiaRecommendationBtn.leftAnchor.constraint(equalTo: self.severeHypocalcemiaRecommendationBtn.rightAnchor).isActive = true
        subClinicalHypocalcemiaRecommendationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.0975)).isActive = true
        subClinicalHypocalcemiaRecommendationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        normalCalcemiaRecommendationBtn.translatesAutoresizingMaskIntoConstraints = false
        normalCalcemiaRecommendationBtn.topAnchor.constraint(equalTo: self.zoneSpecificRecommendationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        normalCalcemiaRecommendationBtn.leftAnchor.constraint(equalTo: self.subClinicalHypocalcemiaRecommendationBtn.rightAnchor).isActive = true
        normalCalcemiaRecommendationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.36)).isActive = true
        normalCalcemiaRecommendationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        
        recommendationBoxLeft.translatesAutoresizingMaskIntoConstraints = false
        recommendationBoxLeft.bottomAnchor.constraint(equalTo: self.severeHypocalcemiaRecommendationBtn.topAnchor).isActive = true
        recommendationBoxLeft.leftAnchor.constraint(equalTo: self.severeHypocalcemiaRecommendationBtn.leftAnchor, constant: -(UIScreen.main.bounds.width * 0.1)).isActive = true
        recommendationBoxLeft.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.45)).isActive = true
        recommendationBoxLeft.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        
        recommendationBoxMiddle.translatesAutoresizingMaskIntoConstraints = false
        recommendationBoxMiddle.bottomAnchor.constraint(equalTo: self.subClinicalHypocalcemiaRecommendationBtn.topAnchor).isActive = true
        recommendationBoxMiddle.centerXAnchor.constraint(equalTo: self.subClinicalHypocalcemiaRecommendationBtn.centerXAnchor).isActive = true
        recommendationBoxMiddle.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.45)).isActive = true
        recommendationBoxMiddle.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        
        recommendationBoxRight.translatesAutoresizingMaskIntoConstraints = false
        recommendationBoxRight.bottomAnchor.constraint(equalTo: self.normalCalcemiaRecommendationBtn.topAnchor).isActive = true
        recommendationBoxRight.rightAnchor.constraint(equalTo: self.normalCalcemiaRecommendationBtn.rightAnchor, constant: (UIScreen.main.bounds.width * 0.1)).isActive = true
        recommendationBoxRight.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.45)).isActive = true
        recommendationBoxRight.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        
        zoneSpecificRecommendationLabel.translatesAutoresizingMaskIntoConstraints = false
        zoneSpecificRecommendationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        zoneSpecificRecommendationLabel.topAnchor.constraint(equalTo: testResultLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        zoneSpecificRecommendationLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        
        self.recommendationBtn.translatesAutoresizingMaskIntoConstraints = false
        self.recommendationBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.recommendationBtn.topAnchor.constraint(equalTo: self.testProgressIndicator.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        self.recommendationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        
        //testProgressView
        self.testProgressView.translatesAutoresizingMaskIntoConstraints = false
        self.testProgressView.setProgress(1, animated: true)
        self.testProgressView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.testProgressView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        self.testProgressView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.5)).isActive = true
        self.testProgressView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.02)).isActive = true
    }
    
    public func setupButtonListeners(){
        startTestBtn.addTarget(self, action: #selector(startTestBtnListener), for: .touchUpInside)
        saveTestBtn.addTarget(self, action: #selector(saveTestBtnListener), for: .touchUpInside)
        discardTestBtn.addTarget(self, action: #selector(discardTestBtnListener), for: .touchUpInside)
        cancelTestBtn.addTarget(self, action: #selector(cancelTestBtnListener), for: .touchUpInside)
        severeHypocalcemiaRecommendationBtn.addTarget(self, action: #selector(severeHypocalcemiaRecommendationBtnListener), for: .touchUpInside)
        subClinicalHypocalcemiaRecommendationBtn.addTarget(self, action: #selector(subClinicalHypocalcemiaRecommendationBtnListener), for: .touchUpInside)
        normalCalcemiaRecommendationBtn.addTarget(self, action: #selector(normalCalcemiaRecommendationBtnListener), for: .touchUpInside)
        recommendationBtn.addTarget(self, action: #selector(recommendationBtnListener), for: .touchUpInside)
        retestBtn.addTarget(self, action: #selector(retestBtnListener), for: .touchUpInside)
        
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
    
    @objc private func retestBtnListener(){
        //check that it is connected to device
        if(testPageController!.getPeripheralDevice() == nil){
            showToast(controller: self, message: "No device connected", seconds: 1)
            return
        }
        else if(testPageController!.getStripDetectVoltageValue() == nil){ //set proper value for testing, for now this works
            //this is set to 750 since one of the devices only has a strip detect voltage of 1/2 VDD, the other has a strip detect voltage of VDD. 75O gives a lot of room for any noise at the bottom end and also is low enough to detect when a strip is inserted (essentially 1/4 VDD)
            showToast(controller: self, message: "Securing Connection to Device, Please Retry", seconds: 1)
            return
        }
        //check that both strips are entered into the device
        else if(testPageController!.getStripDetectVoltageValue()! <= 750){ //set proper value for testing, for now this works
            //this is set to 750 since one of the devices only has a strip detect voltage of 1/2 VDD, the other has a strip detect voltage of VDD. 75O gives a lot of room for any noise at the bottom end and also is low enough to detect when a strip is inserted (essentially 1/4 VDD)
            showToast(controller: self, message: "Strips not detected", seconds: 1)
            return
        }
        
        
        if(savableTest){
            let alert = UIAlertController(title: "Save Previous Test", message: "Would you like to save or discard the previous test?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in
                self.saveTestBtnListener()
                self.runTest()
                return
            }))
            alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { action in
                self.discardTestBtnListener()
                self.runTest()
                return
            }))

            self.present(alert, animated: true)
        }
        else{
            self.discardTestBtnListener()
            self.runTest()
            return
        }
    }
    
    
    private func setSignsOfMilkFever(){
        let alert = UIAlertController(title: "Is this cow experiencing any of the following symptoms?", message: "Hypersensitivity\nRestlessness\nMuscle tremors\nShifting of body weight\nUnbalanced gait\nDifficulty moving\nReduced body temperature\nDry muzzle\nIncreased heart rate (103+)\nWeak heartbeat\nUnable to stand\nTrouble urinating\nLaying down on its side\nComatose", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.signsOfMilkFever = false
            if(self.menuView?.getSettingsView().getUnitsSwitchValue() == false){ //MGDL
                self.recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftMilkFeverMGDL")
                self.recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleMilkFeverMGDL")
                self.recommendationBoxRight.image = UIImage(named: "recommendationBoxRightMilkFeverMGDL")
            }
            else if(self.menuView?.getSettingsView().getUnitsSwitchValue() == true){ //MGDL
                self.recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftMilkFeverMM")
                self.recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleMilkFeverMM")
                self.recommendationBoxRight.image = UIImage(named: "recommendationBoxRightMilkFeverMM")
            }
            self.runTest()
            return
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            self.signsOfMilkFever = true
            if(self.menuView?.getSettingsView().getUnitsSwitchValue() == false){ //MGDL
                self.recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftNoMilkFeverMGDL")
                self.recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleNoMilkFeverMGDL")
                self.recommendationBoxRight.image = UIImage(named: "recommendationBoxRightNoMilkFeverMGDL")
            }
            else if(self.menuView?.getSettingsView().getUnitsSwitchValue() == true){ //MGDL
                self.recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftNoMilkFeverMM")
                self.recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleNoMilkFeverMM")
                self.recommendationBoxRight.image = UIImage(named: "recommendationBoxRightNoMilkFeverMM")
            }
            self.runTest()
            return
        }))

        self.present(alert, animated: true)
    }
    
    
    private func computeRecommendations(){
        // TODO:
        // find all tests that have been done within 24h of the last recursively - append these to the followUpTest array in recommendationView
        // find followUpTest number from the last test within a 24h span by adding 1 - set to followUpNumber in recommendationView
        // set recommendationString in recommendationView based off result range
        
        let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        //dateformatter.timeStyle = DateFormatter.Style.short
        
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: self.testDate!) //24 hours before the test date
        let endDate = self.testDate
        
        dateformatter.timeStyle = DateFormatter.Style.short
        
        let predicateStartDate = NSPredicate(format: "date >= %@", startDate! as NSDate) //need to add times to these dates
        let predicateEndDate = NSPredicate(format: "date <= %@", endDate! as NSDate)
        let predicateCow = NSPredicate(format: "cow == %@", self.cowToSave!)
        let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateStartDate, predicateEndDate, predicateCow])
            
        fetchRequest.predicate = fetchPredicate
        
        var savedTestArray = [Test]()
        
        do{
            savedTestArray = try (self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest))!
            
            followUpTestArray.append(contentsOf: savedTestArray)

        } catch{
            print("Error during fetch request")
        }
        
//        for test in followUpTestArray{
//            recursivelyFindFollowUpTests(originalTest: test)
//        }
        
        for test in followUpTestArray{
            print(test.date)
        }
    }
    
    
    private func recursivelyFindFollowUpTests(originalTest: Test){
        let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
               
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        //dateformatter.timeStyle = DateFormatter.Style.short
               
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: originalTest.date! as Date) //24 hours before the test date
        let endDate = originalTest.date! as Date
               
        dateformatter.timeStyle = DateFormatter.Style.short
               
        let predicateStartDate = NSPredicate(format: "date >= %@", startDate! as NSDate) //need to add times to these dates
        let predicateEndDate = NSPredicate(format: "date <= %@", endDate as NSDate)
        let predicateCow = NSPredicate(format: "cow == %@", self.cowToSave!)
        let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateStartDate, predicateEndDate, predicateCow])
                   
        fetchRequest.predicate = fetchPredicate
               
        var savedTestArray = [Test]()
               
        do{
            savedTestArray = try (self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest))!
            
            for test in savedTestArray{
                if(!followUpTestArray.contains(test)){
                    followUpTestArray.append(test)
                }
                recursivelyFindFollowUpTests(originalTest: test)
            }
            
            return
            
            } catch{
            print("Error during fetch request")
        }
    }
    
    
    @objc private func recommendationBtnListener(){
        self.menuView?.getHerdLogbookView().getCowLogbookView().getTestLogbookView().setSelectedCow(cow: cowToSave)
        self.menuView?.getHerdLogbookView().getCowLogbookView().getTestLogbookView().setTimeFrame(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()))
        navigationController?.pushViewController((self.menuView?.getHerdLogbookView().getCowLogbookView().getTestLogbookView())!, animated: true)
    }
    
    
    @objc private func startTestBtnListener(){

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
        
        //check that it is connected to device
        if(testPageController!.getPeripheralDevice() == nil){
            showToast(controller: self, message: "No device connected", seconds: 1)
            return
        }
        else if(testPageController!.getStripDetectVoltageValue() == nil){ //set proper value for testing, for now this works
            //this is set to 750 since one of the devices only has a strip detect voltage of 1/2 VDD, the other has a strip detect voltage of VDD. 75O gives a lot of room for any noise at the bottom end and also is low enough to detect when a strip is inserted (essentially 1/4 VDD)
            showToast(controller: self, message: "Securing Connection to Device, Please Retry", seconds: 1)
            return
        }
        //check that both strips are entered into the device
        else if(testPageController!.getStripDetectVoltageValue()! <= 750){ //set proper value for testing, for now this works
            //this is set to 750 since one of the devices only has a strip detect voltage of 1/2 VDD, the other has a strip detect voltage of VDD. 75O gives a lot of room for any noise at the bottom end and also is low enough to detect when a strip is inserted (essentially 1/4 VDD)
            showToast(controller: self, message: "Strips not detected", seconds: 1)
            return
        }
        
        self.setCowHerd()
        
    }
    
    
    
    @objc private func saveTestBtnListener(){
        
        
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
        
        
        let testToSave = Test(context: (self.appDelegate?.persistentContainer.viewContext)!)
        testToSave.date = self.testDate! as NSDate?
                            
        testToSave.testID = UUID().uuidString //create a random UUID for the test identifier
                             
        testToSave.testType = "Blood Calcium"
                             
        testToSave.value = testResultToSave!
                             
        testToSave.units = units!
                             
        //testToSave.cow = menuView?.getHerdLogbookView().getCowLogbookView().getTestLogbookView().getSelectedCow()
        testToSave.cow = self.cowToSave
        
        testToSave.followUpNum = self.testFollowUpNumberToSave
        
        self.appDelegate?.saveContext() //save w core data
                             
        self.showToast(controller: self, message: "Test Result Has Been Saved", seconds: 1)
        
        self.discardTestBtnListener()
                            
        return
                            
        
    }
    
    
    
    @objc private func discardTestBtnListener(){
        
        
        discardTestBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.discardTestBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        let stopTestString = "00"
        let stopTestData = Data(hexString: stopTestString)
        
        self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
        
        //startTestBtn
        startTestBtn.isEnabled = true
        startTestBtn.isHidden = false
        
        
        self.tempVoltageLabelKeepHidden = false
        self.batteryVoltageLabelKeepHidden = false
        
        //saveTestBtn
        saveTestBtn.isEnabled = false
        saveTestBtn.isHidden = true
        
        //discardTestBtn
        discardTestBtn.isEnabled = false
        discardTestBtn.isHidden = true
        
        self.retestBtn.isEnabled = false
        self.retestBtn.isHidden = true
        
        //cancelTestBtn
        cancelTestBtn.isEnabled = false
        cancelTestBtn.isHidden = true
        
        //connectedDeviceLabel
        connectedDeviceLabel.isHidden = false
        
        //testResultLabel
        testResultLabel.text = "" //will be filled out with the test result
        testResultLabel.isHidden = true
        
        
        //testDateLabel
        testDateLabel.text = "" //will be filled out with the test result
        testDateLabel.isHidden = true
        
        testResultProgressBar.isHidden = true
        testProgressIndicator.isHidden = true
        testProgressView.isHidden = true
        
        recommendationBtn.isEnabled = false
        recommendationBtn.isHidden = true
        
        zoneSpecificRecommendationLabel.isHidden = false
        
        severeHypocalcemiaRecommendationBtn.isHidden = true
        severeHypocalcemiaRecommendationBtn.isEnabled = false
                
        subClinicalHypocalcemiaRecommendationBtn.isHidden = true
        subClinicalHypocalcemiaRecommendationBtn.isEnabled = false

        normalCalcemiaRecommendationBtn.isHidden = true
        normalCalcemiaRecommendationBtn.isEnabled = false
        
        zoneSpecificRecommendationLabel.isHidden = true
        
        recommendationBoxLeft.isHidden = true
        recommendationBoxMiddle.isHidden = true
        recommendationBoxRight.isHidden = true
        
        self.cancelTestFlag = false
    }
    
    
    
    @objc private func cancelTestBtnListener(){
        
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
        
        self.cancelTestFlag = true
        
        self.herdToSave = nil
        self.cowToSave = nil
        
        DispatchQueue.main.async {
            self.waitingLabel.isHidden = true
        }
        
        let stopTestString = "00"
        let stopTestData = Data(hexString: stopTestString)
        
        self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
        
        self.testTimer.invalidate()
        
        discardTestBtnListener()
    }
    
    
    public func setCowHerd(){
        
        self.herdToSave = nil
        self.cowToSave = nil
        
//        let herdFetchRequest: NSFetchRequest<Herd> = Herd.fetchRequest()
//        var savedHerdArray: [Herd]? = nil
//        do{
//            savedHerdArray = try appDelegate?.persistentContainer.viewContext.fetch(herdFetchRequest)
//
//        } catch{
//            print("Error during fetch request")
//        }
//
//        let cowFetchRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
//        var savedCowArray: [Cow]? = nil
//        do{
//            savedCowArray = try appDelegate?.persistentContainer.viewContext.fetch(cowFetchRequest)
//
//        } catch{
//            print("Error during fetch request")
//        }
//
//        if(savedHerdArray!.isEmpty){
//            self.showToast(controller: self, message: "There are currently no herds in the logbook", seconds: 2)
//            return
//        }
        
        let alert = UIAlertController(title: "Choose Herd/Cow", message: "Would you like to choose a Herd/Cow to save to or run a blank test?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Blank Test", style: .default, handler: { action in
            self.savableTest = false
            self.runTest()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Herd/Cow", style: .default, handler: { action in
            self.savableTest = true
            self.selectingHerdCowFromList = true
            self.menuView?.getHerdLogbookView().setSelectingHerdFromList(select: true)
            self.navigationController?.pushViewController((self.menuView?.getHerdLogbookView())! , animated: true)
            return
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
    
    private func runTest(){
        
        self.selectingHerdCowFromList = false
        
        self.tempVoltageLabel.isHidden = false
        self.batteryVoltageLabel.isHidden = false
        
        startTestBtn.isEnabled = false
        startTestBtn.isHidden = true
        
        cancelTestBtn.isEnabled = true
        cancelTestBtn.isHidden = false
        
        //set testDateLabel
        testDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        testDateLabel.text = dateformatter.string(from: testDate!)
        testDateLabel.isHidden = false
        
        //run background thread to continuously check that device does not disconnect - or instead check that value does not go to 0 or nil when reading instead?
        //TODO
        
        
        let finalValueTestQueue = DispatchQueue(label: "Final Value Test Queue", attributes: .concurrent) //runs on a background thread so that you can run multiple tests at once - also has to pause for 10 seconds at one point and this would cause the UI to pause if it were running on the main thread
            
        finalValueTestQueue.async {
        
            let startTestString = "01"
            let stopTestString = "00"
        
            let startTestData = Data(hexString: startTestString)
            let stopTestData = Data(hexString: stopTestString)
            
            DispatchQueue.main.sync {
                self.waitingLabel.text = "Waiting for device temperature to reach 27°C..."
                self.waitingLabel.isHidden = false
                //self.waitingLabel.text = "Line 888"
                
                //self.showToast(controller: self, message: "Fill Strip With Sample", seconds: 2)
                
            }
        
            self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
            
            self.testPageController!.getPeripheralDevice()?.writeValue(startTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
            
            
            
            
            //want it to wait here until temperature reaches 27C
            while(true){
                //wait here - see if this makes app unresponsive or if we are on a background thread
                
                if(self.tempLevel >= 27){
                    break;
                }
            }
            
            print("\n\n\n\n\nFINISHED LOOP\n\n\n\n\n");
            
            
            self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
            
            self.testPageController!.getPeripheralDevice()?.writeValue(startTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
            
            
            
            DispatchQueue.main.sync {
                self.waitingLabel.text = "Waiting for strip to be filled..."
                //self.waitingLabel.text = "Line 888"
                
                self.showToast(controller: self, message: "Fill Strip With Sample", seconds: 2)
                
            }
            
            
            
//            DispatchQueue.main.async{
//                self.waitingLabel.text = "Line 900"
//            }
            
            //sleep(1) //kind of a buggy fix - this is to ensure the capacitor discharges
            
            var testDuration = 8 //default test duration = 8s
            
            if(self.menuView?.getSettingsView().getTestingModeDefault() == true){
                testDuration = 30 //testing test duration = 30s
                
                //Write Herd report text file
                self.url = self.getDocumentsDirectory().appendingPathComponent("TestReport.txt")
                    
                //write test report header
                do {
                    try String("Test Report\n").write(to: self.url!, atomically: true, encoding: .utf8)
                    self.appendStringToFile(url: self.url!, string: ("--------------------------------------\n\n"))
                    self.appendStringToFile(url: self.url!, string: ("Device Battery Voltage: " + String(self.battLevel) + "\n"))
                    self.appendStringToFile(url: self.url!, string: ("Device Temperature: " + String(self.tempLevel) + "\n\n"))
                    self.appendStringToFile(url: self.url!, string: ("--------------------------------------\n\n"))
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
//            DispatchQueue.main.async{
//                self.waitingLabel.text = "Line 924"
//            }
            
            DispatchQueue.main.sync {
                self.testTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.readNewVoltage), userInfo: nil, repeats: true)
            }
            
            
            DispatchQueue.main.async{
                self.waitingLabel.text = "Line 933"
            }
            
            
            
            //wait until value is not nil
            var index = 0
            
            while(true){ //this shouldn't pause the UI since its on a background thread
                if(self.testPageController!.getIntegratedVoltageValue() != nil){
                    break
                }
                DispatchQueue.main.async{
                    self.waitingLabel.text = String(index)
                }
                index += 1
            }

            //var index = 0;
            
            DispatchQueue.main.async{
                self.waitingLabel.text = "Line 947"
                self.waitingLabel.text = "Waiting for strips to fill"
            }
            
            
            
            //wait until value reaches a threshold of 250mV
            while(true){ //this shouldn't pause the UI since its on a background thread
                //print(self.testPageController!.getIntegratedVoltageValue())
                if(self.testPageController!.getIntegratedVoltageValue()! >= 150 && self.testPageController!.getIntegratedVoltageValue()! <= 200){
                    break
                }
                else if(self.cancelTestFlag){
                    DispatchQueue.main.async {
                        self.discardTestBtnListener()
                    }
                    return
                }
//                if(index % 1000 == 0){
//                    self.cancelTestBtn.isHidden = !(self.cancelTestBtn.isHidden)
//                }
//                index += 1;
            }
            
            DispatchQueue.main.async{
                self.waitingLabel.text = "Line 971"
            }
            
            DispatchQueue.main.async {
                self.waitingLabel.isHidden = true
                self.tempVoltageLabel.isHidden = true
                self.batteryVoltageLabel.isHidden = true
                
                self.testProgressView.isHidden = false
                self.testProgressView.setProgress(0, animated: true)
                
                self.cancelTestBtn.isEnabled = false
                self.cancelTestBtn.isHidden = true
            }
            
            let currentTime = DispatchTime.now()
            
            //MARK: Normal Test
            finalValueTestQueue.asyncAfter(deadline: currentTime + .seconds(testDuration * 1/4)){
                DispatchQueue.main.sync {
                    self.testProgressView.setProgress(0.25, animated: true)
                }
            }
            finalValueTestQueue.asyncAfter(deadline: currentTime + .seconds(testDuration * 1/2 )){
                DispatchQueue.main.sync {
                    self.testProgressView.setProgress(0.5, animated: true)
                }
            }
            finalValueTestQueue.asyncAfter(deadline: currentTime + .seconds(testDuration * 3/4)){
                DispatchQueue.main.sync {
                     self.testProgressView.setProgress(0.75, animated: true)
                }
            }
            finalValueTestQueue.asyncAfter(deadline: currentTime + .seconds(testDuration)){
                //TODO
                
                var finalResult: Float?
                
                if(self.testPageController!.getIntegratedVoltageValue() != nil){
                    
                    if((self.menuView?.getSettingsView().getManualCalibrationSwitchValue())!){ //if manual calibration on, then it will take the manual calibration equation
                        DispatchQueue.main.async {
                            finalResult = Float((Float(self.testPageController!.getIntegratedVoltageValue()!) - ((self.menuView?.getSettingsView().getManCalBVal())!)) / (self.menuView?.getSettingsView().getManCalMVal())!)
                        }
                        
                    }
                    else{ //if manual calibration off, then it will take the voltage value
                        finalResult = Float((Float(self.testPageController!.getIntegratedVoltageValue()!) - Float(1336.5)) / Float(-79.2))
                        
                    }
                    
                }
                else{
                    finalResult = nil
                }
                
                
                self.testPageController!.getPeripheralDevice()?.writeValue(stopTestData!, for: self.testPageController!.getStartTestCharacteristic(), type: .withResponse) //discharge capacitor - in case strips were left in after previous test and charge built up
                if(self.menuView!.getSettingsView().getUnitsSwitchValue()){
                    finalResult = finalResult! / 4
                    self.units = "mM"
                }
                else{
                    self.units = "mg/dL"
                }
                    
                
                self.testTimer.invalidate()
                
                //MARK: Normal Testing Procedure
                self.testResultToSave = finalResult
                
                DispatchQueue.main.sync {
                    
                    self.testProgressView.setProgress(1, animated: true)
                    self.testProgressView.isHidden = true
                    
                    self.cancelTestBtn.isEnabled = false
                    self.cancelTestBtn.isHidden = true
                    
                    var progressRatio: Float = 0
                    
                    if(self.menuView!.getSettingsView().getUnitsSwitchValue()){
                        progressRatio = finalResult! / 3.5 //our scale goes up to 14mg/dL
                        print(progressRatio)
                    }
                    else{
                        progressRatio = finalResult! / 14.0 //our scale goes up to 14mg/dL
                        print(progressRatio)
                    }
                    
                    
                    
                    self.testProgressIndicator.removeConstraints(self.testProgressIndicator.constraints)
                    self.testProgressIndicator.translatesAutoresizingMaskIntoConstraints = false
                    self.testProgressIndicator.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.05)).isActive = true
                    self.testProgressIndicator.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
                    self.testProgressIndicator.topAnchor.constraint(equalTo: self.testResultProgressBar.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
                    if(progressRatio <= 1 && progressRatio > 0){
                        self.testProgressIndicator.leftAnchor.constraint(equalTo: self.testResultProgressBar.leftAnchor, constant: ((UIScreen.main.bounds.width * 0.75) * CGFloat(progressRatio))).isActive = true
                    }
                    else if(progressRatio <= 0){
                        self.testProgressIndicator.leftAnchor.constraint(equalTo: self.testResultProgressBar.leftAnchor).isActive = true
                    }
                    else{ //if its bigger than 1 then just set it to the very right side of the bar. It will never be smaller than 0 so the lowest it will go is the very left side of the bar
                        self.testProgressIndicator.leftAnchor.constraint(equalTo: self.testResultProgressBar.leftAnchor, constant: ((UIScreen.main.bounds.width * 0.75))).isActive = true
                    }
                    self.testProgressIndicator.isHidden = false
                    
                    if(self.savableTest){
                    self.recommendationBtn.setTitle("Recent Results for Cow: " + (self.cowToSave?.id)!, for: .normal)
                    self.recommendationBtn.isEnabled = true
                    self.recommendationBtn.isHidden = false
                    }
                    
                }
                
                if(self.menuView!.getSettingsView().getUnitsSwitchValue()){
                    if(finalResult! >= Float(1.375) && finalResult! <= Float(2.0)){
                        DispatchQueue.main.sync {
                            self.testResultLabel.textColor = .yellow
                            self.testResultProgressBar.tintColor = .yellow
                        }
                    }
                    else if(finalResult! > Float(2.0)){
                        DispatchQueue.main.sync{
                            self.testResultLabel.textColor = .green
                            self.testResultProgressBar.tintColor = .green
                        }
                    }
                    else{
                        DispatchQueue.main.sync {
                            self.testResultLabel.textColor = .red
                            self.testResultProgressBar.tintColor = .red
                        }
                    }
                }
                else{
                    if(finalResult! >= Float(5.5) && finalResult! <= Float(8.0)){
                        DispatchQueue.main.sync {
                            self.testResultLabel.textColor = .yellow
                            self.testResultProgressBar.tintColor = .yellow
                        }
                    }
                    else if(finalResult! > Float(8.0)){
                        DispatchQueue.main.sync{
                            self.testResultLabel.textColor = .green
                            self.testResultProgressBar.tintColor = .green
                        }
                    }
                    else{
                        DispatchQueue.main.sync {
                            self.testResultLabel.textColor = .red
                            self.testResultProgressBar.tintColor = .red
                        }
                    }
                }
                
                   
                
                
                DispatchQueue.main.sync {
                    self.testResultLabel.text = String(format: "%.2f", finalResult!) + self.units!
                    self.testResultLabel.isHidden = false
                    
                    self.tempVoltageLabelKeepHidden = true
                    self.batteryVoltageLabelKeepHidden = true
                    
                    self.testResultProgressBar.isHidden = false
                    //self.testResultProgressBar.setProgress(Float(finalResult! / Float(15.0)), animated: true)
                    
                    if(self.savableTest){
                        self.saveTestBtn.isEnabled = true
                        self.saveTestBtn.isHidden = false
                        
                        self.retestBtn.setTitle("Re-test Cow", for: .normal)
                    }
                    else{
                        self.retestBtn.setTitle("Re-test Blank Test", for: .normal)
                    }
                    
                    self.retestBtn.isEnabled = true
                    self.retestBtn.isHidden = false
                    
                    self.discardTestBtn.isEnabled = true
                    self.discardTestBtn.isHidden = false

                    if(self.savableTest){
                    self.zoneSpecificRecommendationLabel.isHidden = false
                    
                    self.severeHypocalcemiaRecommendationBtn.isHidden = false
                    self.severeHypocalcemiaRecommendationBtn.isEnabled = true
                            
                    self.subClinicalHypocalcemiaRecommendationBtn.isHidden = false
                    self.subClinicalHypocalcemiaRecommendationBtn.isEnabled = true

                    self.normalCalcemiaRecommendationBtn.isHidden = false
                    self.normalCalcemiaRecommendationBtn.isEnabled = true
                    }
                    
                }
                
                if(self.savableTest){
                self.computeRecommendations()
                }
                
                if(self.menuView?.getSettingsView().getTestingModeDefault() == true){
                    //SEND EMAIL WITH TESTING STUFF
                    
                    DispatchQueue.main.async{
                        let emailAlert = UIAlertController(title: "Testing Voltage Results", message: "Would you like to email yourself the test voltages?", preferredStyle: .alert)

                                           emailAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                                               return
                                           }))
                                           
                                           emailAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
                                            
                                            
                                            
                                            //1. Create the alert controller.
                                            let sampleIDAlert = UIAlertController(title: "Sample ID", message: "Please enter the ID of the sample used for the test", preferredStyle: .alert)

                                            //2. Add the text field. You can configure it however you need.
                                            sampleIDAlert.addTextField { (textField) in
                                                textField.placeholder = "Sample ID"
                                            }

                                            // 3. Grab the value from the text field, and print it when the user clicks OK.
                                            sampleIDAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak sampleIDAlert] (_) in
                                                let sampleID = sampleIDAlert?.textFields![0].text // Force unwrapping because we know it exists.
                                                
                                                
                                                if( MFMailComposeViewController.canSendMail() ) {
                                                        let mailComposer = MFMailComposeViewController()
                                                        mailComposer.mailComposeDelegate = self

                                                        //Set the subject and message of the email
                                                    mailComposer.setSubject("Test Report | Sample ID: " + sampleID! + " | " + self.testDateLabel.text!)
                                                        mailComposer.setMessageBody("", isHTML: false)

                         
                                                        let fileURL = self.getDocumentsDirectory().appendingPathComponent("TestReport.txt")
                                                                        
                                                                        
                                                        do {
                                                        let attachmentData = try Data(contentsOf: fileURL)
                                                            mailComposer.addAttachmentData(attachmentData, mimeType: "text/txt", fileName: "TestReport")
                                                            mailComposer.mailComposeDelegate = self
                                                            self.present(mailComposer, animated: true
                                                                , completion: nil)
                                                        } catch let error {
                                                            print("We have encountered error \(error.localizedDescription)")
                                                        }
                                                                            
                                                        self.present(mailComposer, animated: true, completion: nil)
                                                    }
                                                    else{
                                                        self.showToast(controller: self, message: "Cannot send email - Please make sure you have an email account set up on your device", seconds: 2)
                                                    }
                                            }))
                                            // 4. Present the alert.
                                            self.present(sampleIDAlert, animated: true, completion: nil)

                                                
                                            }))
                                           self.present(emailAlert, animated: true)
                    }
                    
                    
                    
                    
                }
                
            }
            
        }
    }
    
    @objc private func severeHypocalcemiaRecommendationBtnListener(){
        //TODO
        print("Severe hypo")
        
        if(recommendationBoxLeft.isHidden){
            recommendationBoxLeft.isHidden = false
            recommendationBoxMiddle.isHidden = true
            recommendationBoxRight.isHidden = true
        }
        else{
            recommendationBoxLeft.isHidden = true
        }
    }
    
    @objc private func subClinicalHypocalcemiaRecommendationBtnListener(){
        //TODO
        print("subclinical hypo")
        
        if(recommendationBoxMiddle.isHidden){
            recommendationBoxLeft.isHidden = true
            recommendationBoxMiddle.isHidden = false
            recommendationBoxRight.isHidden = true
        }
        else{
            recommendationBoxMiddle.isHidden = true
        }
    }
    
    @objc private func normalCalcemiaRecommendationBtnListener(){
        //TODO
        print("normal calc")
        
        if(recommendationBoxRight.isHidden){
            recommendationBoxLeft.isHidden = true
            recommendationBoxMiddle.isHidden = true
            recommendationBoxRight.isHidden = false
        }
        else{
            recommendationBoxRight.isHidden = true
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
    
    
    public func setPageID(id: Int?){
        pageID = id
    }
    
    public func getPageID() -> Int?{
        return pageID
    }
    
    
    public func getConnectedDeviceLabel() -> UILabel{
        return connectedDeviceLabel
    }
    
    
    public func deviceDisconnected(){
        self.disconnectedDevice = true
        
        if(self.cancelTestBtn.isHidden == false){
            self.cancelTestBtnListener()
        }
    }
    
    public func setPeripheralDevice(periphDevice: CBPeripheral?){
        if(periphDevice == nil){
            self.connectedDeviceLabel.text = "Connected Device: None"
            batteryVoltageLabel.isHidden = true
            tempVoltageLabel.isHidden = true
            self.tempBatTimer.invalidate()
        }
        else{
            self.connectedDeviceLabel.text = "Connected Device: " + periphDevice!.name!
            self.tempBatTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.readNewTempBatVoltages), userInfo: nil, repeats: true)
        }
    }
    
    
    public func setHerd(herd: Herd?){
        herdToSave = herd
    }
    
    public func setCow(cow: Cow?){
        cowToSave = cow
    }
    
    
    
    //MARK: testing purposes - will print voltage values to the screen
    @objc private func readNewVoltage(){
        
        var intVoltageValue: Int? = nil
        //DispatchQueue.main.sync {
            intVoltageValue = self.testPageController!.getIntegratedVoltageValue()
        //}
        
        if(intVoltageValue == nil){
            print("nil")
            if(menuView?.getSettingsView().getTestingModeDefault() == true){
                self.appendStringToFile(url: url!, string: ("nil" + "\n"))
            }
        }
        else{
            print(intVoltageValue!)
            if(menuView?.getSettingsView().getTestingModeDefault() == true){
                self.appendStringToFile(url: url!, string: (String(intVoltageValue!) + "\n"))
            }
        }
    }
    
    
    @objc private func readNewTempBatVoltages(){
        
        
        var tempVoltageValue: Int? = nil
        //DispatchQueue.main.sync {
        tempVoltageValue = self.testPageController!.getTemperatureVoltageValue()
        
        print(tempVoltageValue)
        
        
        //}
        
        if(tempVoltageValue == nil){
            DispatchQueue.main.async{
                self.tempVoltageLabel.isHidden = true
            }
        }
        else{
            //var temp = (-21.11 * log(((3.3 * (40000/(Double(tempVoltageValue!)/1000))) - 40000))) + 219.56
            var temp = (Double(tempVoltageValue!) * 0.0559) - 60.9
            
            self.tempLevel = Double(round(100 * temp)/100)
            
            DispatchQueue.main.async{
                if(self.tempVoltageLabelKeepHidden){
                    self.tempVoltageLabel.isHidden = true
                }
                else{
                    self.tempVoltageLabel.text = "Device Temp: " + String(self.tempLevel) + " C"
                    self.tempVoltageLabel.isHidden = false
                }
                
                if(self.tempLevel < 27){
                    self.startTestBtn.setTitle("Heat Device", for: .normal)
                }
                else{
                    self.startTestBtn.setTitle("Start Test", for: .normal)
                }
            }
        }
        
        var battVoltageValue: Int? = nil
        //DispatchQueue.main.sync {
            battVoltageValue = self.testPageController!.getBatteryVoltageValue()
        
        print(battVoltageValue)
        //}
        
        if(battVoltageValue == nil){
            DispatchQueue.main.async{
                self.batteryVoltageLabel.isHidden = true
            }
        }
        else{
            
            var bat = Double(battVoltageValue!) / 1000.0// * 2.3 //this is a patch
            
            self.battLevel = Double(round(10 * bat)/10)
            
            DispatchQueue.main.async{
                
                if(self.batteryVoltageLabelKeepHidden){
                    self.batteryVoltageLabel.isHidden = true
                }
                else{
                    self.batteryVoltageLabel.text = "Device Batt: " + String(self.battLevel) + " V"
                    self.batteryVoltageLabel.isHidden = false
                }
                
            }
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func appendStringToFile(url: URL, string: String){
        do {
            let fileHandle = try FileHandle(forWritingTo: url)
                fileHandle.seekToEndOfFile()
                fileHandle.write(string.data(using: .utf8)!)
                fileHandle.closeFile()
        } catch {
            print("Error writing to file \(error)")
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("User cancelled")
            break

        case .saved:
            print("Mail is saved by user")
            break

        case .sent:
            print("Mail is sent successfully")
            self.showToast(controller: self, message: "Mail is sent successfully", seconds: 2)
            break

        case .failed:
            print("Sending mail is failed")
            self.showToast(controller: self, message: "Sending mail is failed", seconds: 2)
            break
        default:
            break
        }

        controller.dismiss(animated: true)

    }
    
    
}

extension SingleStripTestViewController: WCSessionDelegate{
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //TODO
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //TODO
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        //TODO
    }
}


@available(iOS 12.0, *)
extension SingleStripTestViewController {

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
extension SingleStripTestViewController: INUIAddVoiceShortcutViewControllerDelegate {
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
