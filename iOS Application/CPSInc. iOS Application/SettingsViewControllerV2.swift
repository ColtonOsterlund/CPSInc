//
//  SettingsPageV2.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-07-20.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore //to be able to round the background edges on the switches
import WatchConnectivity
import SwiftKeychainWrapper


public class SettingsViewControllerV2: UIViewController, WCSessionDelegate, /*UIPickerViewDataSource, UIPickerViewDelegate, */UITextFieldDelegate{
    
    //View Controllers
    private var menuView: MenuViewController? = nil
    private var appDelegate: AppDelegate? = nil
//    private var connectView: ConnectViewController? = nil
//    private var testView: TestViewController? = nil
    
    //Labels
    //private let testTypeLabel = UILabel()
    //private let testDurationLabel = UILabel()
    //private let testTypePickerLabel = UILabel()
    private let manualCalibrationLabel = UILabel()
    private let unitsLabel = UILabel()
    private let mgDlLabel = UILabel()
    private let mMLabel = UILabel()
    private let testingModeLabel = UILabel()
    private let quantitativeModeLabel = UILabel()
    
    //PickerView
    //private let finalContinuousPicker = UIPickerView()
    //private let testDurationPicker = UIPickerView()
    //private let testTypePicker = UIPickerView()
    
    //UISwitch
    private let manualCalibrationSwitch = UISwitch()
    private let unitsSwitch = UISwitch()
    private let testingModeSwitch = UISwitch()
    private let quantitativeModeSwitch = UISwitch()
    
    //User Defaults
    private let defaults = UserDefaults.standard
    
    //textViews
    //private let finalContinuousTextView = UILabel()
    //private let testDurationTextView = UILabel()
    //private let testTypeTextView = UILabel()
    
    //textFields
    private let mManualCalibrationTextView = UITextField()
    private let bManualCalibrationTextView = UITextField()
    private let testDurationTextView = UITextField()
    
    //buttons
    //private let selectBtn = UIButton()
    //private let finalContinuousBtn = UIButton()
    //private let testDurationBtn = UIButton()
    //private let testTypeBtn = UIButton()
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    //picker data
    //private let finalContinuousPickerTitles = ["Final Value", "Continuous Value"]
    //private let testDurationPickerTitles = ["5 Seconds", "10 Seconds", "15 Seconds", "20 Seconds", "24 Seconds"]
    //private let testTypePickerTitles = ["Immunoglobulins", "Lactoferrin", "Blood Calcium", "Glucose"]
   
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Configure Settings"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        //these should be done upon initialization instead of upon view loading so that the saved settings can be accessed in different controllers
        createLayoutItems()
        setLayoutConstraints()
        checkAccess()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        checkAccess()
    }
    
    // This allows you to initialise your custom UIViewController witho@available(iOS 12.0, *)
    public convenience init(menuView: MenuViewController, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.menuView = menuView
        self.appDelegate = appDelegate
        
        createLayoutItems()
        setLayoutConstraints()
        checkAccess()
    }

    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        

        defaults.register(defaults: ["manualCalibrationDefault": false])
        defaults.register(defaults: ["unitsDefault": false])
        defaults.register(defaults: ["testingModeDefault": false])
        defaults.register(defaults: ["quantitativeModeDefault": false])
        defaults.register(defaults: ["mValDefault": 0])
        defaults.register(defaults: ["bValDefault": 0])
        defaults.register(defaults: ["testDurationDefault": 7])
    }

    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }
    
    private func createLayoutItems(){
        
        let bar = UIToolbar()
        bar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneKeyboardBtnPressed))
        bar.items = [flex, done]
        

        
        let underlinedManualCalibrationLabel: NSMutableAttributedString = NSMutableAttributedString(string: "Manual Calibration:")
        underlinedManualCalibrationLabel.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, underlinedManualCalibrationLabel.length))
        manualCalibrationLabel.attributedText = underlinedManualCalibrationLabel
        manualCalibrationLabel.textColor = .black
        manualCalibrationLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        manualCalibrationLabel.textAlignment = .center
        view.addSubview(manualCalibrationLabel)
        
        let underlinedUnitsLabel: NSMutableAttributedString = NSMutableAttributedString(string: "Units:")
        underlinedUnitsLabel.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, underlinedUnitsLabel.length))
        unitsLabel.attributedText = underlinedUnitsLabel
        unitsLabel.textColor = .black
        unitsLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        unitsLabel.textAlignment = .center
        view.addSubview(unitsLabel)
        
        mgDlLabel.text = "mM"
        mgDlLabel.textColor = .black
        mgDlLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        mgDlLabel.textAlignment = .center
        view.addSubview(mgDlLabel)
        
        mMLabel.text = "mg/dL"
        mMLabel.textColor = .black
        mMLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        mMLabel.textAlignment = .center
        view.addSubview(mMLabel)
        
        let underlinedTestingLabel: NSMutableAttributedString = NSMutableAttributedString(string: "Testing Mode:")
        underlinedTestingLabel.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, underlinedTestingLabel.length))
        testingModeLabel.attributedText = underlinedTestingLabel
        testingModeLabel.textColor = .black
        testingModeLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        testingModeLabel.textAlignment = .center
        view.addSubview(testingModeLabel)
        
        
        let underlinedQuantitativeLabel: NSMutableAttributedString = NSMutableAttributedString(string: "Quantitative Mode:")
        underlinedQuantitativeLabel.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, underlinedQuantitativeLabel.length))
        quantitativeModeLabel.attributedText = underlinedQuantitativeLabel
        quantitativeModeLabel.textColor = .black
        quantitativeModeLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        quantitativeModeLabel.textAlignment = .center
        view.addSubview(quantitativeModeLabel)
        
        
        manualCalibrationSwitch.setOn(defaults.bool(forKey: "manualCalibrationDefault"), animated: true)
        manualCalibrationSwitch.addTarget(self, action: #selector(manualCalibrationSwitchStateChanged), for: .valueChanged)
        view.addSubview(manualCalibrationSwitch)
        
        unitsSwitch.setOn(defaults.bool(forKey: "unitsDefault"), animated: true)
        unitsSwitch.addTarget(self, action: #selector(unitsSwitchStateChanged), for: .valueChanged)
        view.addSubview(unitsSwitch)
        
        quantitativeModeSwitch.setOn(defaults.bool(forKey: "quantitativeModeDefault"), animated: true)
        quantitativeModeSwitch.addTarget(self, action: #selector(quantitativeModeSwitchStateChanged), for: .valueChanged)
        view.addSubview(quantitativeModeSwitch)
        
        testingModeSwitch.setOn(defaults.bool(forKey: "testingModeDefault"), animated: true)
        testingModeSwitch.addTarget(self, action: #selector(testingModeSwitchStateChanged), for: .valueChanged)
        view.addSubview(testingModeSwitch)
        
        mManualCalibrationTextView.placeholder = "Enter Slope Value (m)"
        mManualCalibrationTextView.tag = 0
        mManualCalibrationTextView.backgroundColor = .white
        mManualCalibrationTextView.inputAccessoryView = bar
        mManualCalibrationTextView.keyboardType = .default
        view.addSubview(mManualCalibrationTextView)
        
        bManualCalibrationTextView.placeholder = "Enter Origin Value (b)"
        bManualCalibrationTextView.tag = 1
        bManualCalibrationTextView.backgroundColor = .white
        bManualCalibrationTextView.inputAccessoryView = bar
        bManualCalibrationTextView.keyboardType = .default
        view.addSubview(bManualCalibrationTextView)
        
        testDurationTextView.placeholder = "Enter Test Duration"
        testDurationTextView.tag = 2
        testDurationTextView.backgroundColor = .white
        testDurationTextView.inputAccessoryView = bar
        testDurationTextView.keyboardType = .default
        view.addSubview(testDurationTextView)
        
        
        if(defaults.bool(forKey: "manualCalibrationDefault") == true){
            mManualCalibrationTextView.isHidden = false
            bManualCalibrationTextView.isHidden = false
        }
        else{
            mManualCalibrationTextView.isHidden = true
            bManualCalibrationTextView.isHidden = true
        }
        
        
    }
    
    private func setLayoutConstraints(){
        
        
        
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        unitsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        unitsLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        mgDlLabel.translatesAutoresizingMaskIntoConstraints = false
        mgDlLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        mgDlLabel.leftAnchor.constraint(equalTo: self.unitsLabel.rightAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        mMLabel.translatesAutoresizingMaskIntoConstraints = false
        mMLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        mMLabel.leftAnchor.constraint(equalTo: self.unitsSwitch.rightAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        
        unitsSwitch.translatesAutoresizingMaskIntoConstraints = false
        unitsSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        unitsSwitch.leftAnchor.constraint(equalTo: self.mgDlLabel.rightAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        testingModeLabel.translatesAutoresizingMaskIntoConstraints = false
        testingModeLabel.topAnchor.constraint(equalTo: self.unitsLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testingModeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        testingModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        testingModeSwitch.topAnchor.constraint(equalTo: self.unitsSwitch.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testingModeSwitch.leftAnchor.constraint(equalTo: self.testingModeLabel.rightAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true

        
        quantitativeModeLabel.translatesAutoresizingMaskIntoConstraints = false
        quantitativeModeLabel.topAnchor.constraint(equalTo: self.testingModeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        quantitativeModeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true

        
        quantitativeModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        quantitativeModeSwitch.topAnchor.constraint(equalTo: self.testingModeSwitch.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        quantitativeModeSwitch.leftAnchor.constraint(equalTo: self.quantitativeModeLabel.rightAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        
        testDurationTextView.translatesAutoresizingMaskIntoConstraints = false
        testDurationTextView.topAnchor.constraint(equalTo: quantitativeModeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testDurationTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.1)).isActive = true
        testDurationTextView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        
        manualCalibrationLabel.translatesAutoresizingMaskIntoConstraints = false
        manualCalibrationLabel.topAnchor.constraint(equalTo: self.testDurationTextView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        manualCalibrationLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        

        manualCalibrationSwitch.translatesAutoresizingMaskIntoConstraints = false
        manualCalibrationSwitch.topAnchor.constraint(equalTo: self.testDurationTextView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        manualCalibrationSwitch.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.05)).isActive = true
        
        
        mManualCalibrationTextView.translatesAutoresizingMaskIntoConstraints = false
        mManualCalibrationTextView.topAnchor.constraint(equalTo: manualCalibrationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        mManualCalibrationTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.1)).isActive = true
        mManualCalibrationTextView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        
        bManualCalibrationTextView.translatesAutoresizingMaskIntoConstraints = false
        bManualCalibrationTextView.topAnchor.constraint(equalTo: mManualCalibrationTextView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        bManualCalibrationTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.1)).isActive = true
        bManualCalibrationTextView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        
    }
    
    
    private func checkAccess(){
        if(KeychainWrapper.standard.string(forKey: "UserEmail") != "creativeproteinsolutions@gmail.com" && KeychainWrapper.standard.string(forKey: "UserEmail") != "coltonericosterlund@gmail.com"){
            testingModeSwitch.isEnabled = false
            testingModeSwitch.isHidden = true
            quantitativeModeSwitch.isEnabled = false
            quantitativeModeSwitch.isHidden = true
            manualCalibrationSwitch.isEnabled = false
            manualCalibrationSwitch.isHidden = true
            
            testingModeLabel.isHidden = true
            quantitativeModeLabel.isHidden = true
            manualCalibrationLabel.isHidden = true
            mManualCalibrationTextView.isHidden = true
            bManualCalibrationTextView.isHidden = true
            testDurationTextView.isHidden = true
        }
        else{
            testingModeSwitch.isEnabled = true
            testingModeSwitch.isHidden = false
            quantitativeModeSwitch.isEnabled = true
            quantitativeModeSwitch.isHidden = false
            manualCalibrationSwitch.isEnabled = true
            manualCalibrationSwitch.isHidden = false
            
            testingModeLabel.isHidden = false
            quantitativeModeLabel.isHidden = false
            manualCalibrationLabel.isHidden = false
            mManualCalibrationTextView.isHidden = false
            bManualCalibrationTextView.isHidden = false
            testDurationTextView.isHidden = false
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
    
//    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        if(pickerView.tag == 0){
//            return 1
//        }
//        else if(pickerView.tag == 1){
//            return 1
//        }
//        else{
//            return 1
//        }
//    }
    
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if(pickerView.tag == 0){
//            return finalContinuousPickerTitles.count
//        }
//        else if(pickerView.tag == 1){
//            return testDurationPickerTitles.count
//        }
//        else{
//            return testTypePickerTitles.count
//        }
//    }
    
//    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if(pickerView.tag == 0){
//            return finalContinuousPickerTitles[row]
//        }
//        else if(pickerView.tag == 1){
//            return testDurationPickerTitles[row]
//        }
//        else{
//            return testTypePickerTitles[row]
//        }
//    }
    
//    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        if(pickerView.tag == 0){
//            defaults.set(row, forKey: "finalContinuousDefault") //save to userDefaults
//            if(wcSession != nil){
//            if(wcSession!.isReachable){
//                do{
//                    try wcSession?.updateApplicationContext(["FinalContSettingsUpdate":defaults.integer(forKey: "finalContinuousDefault")])
//                }catch{
//                    print("Error while sending application context")
//                }
//            }
//            }
//        }
//        else if(pickerView.tag == 1){
//            defaults.set(row, forKey: "testDurationDefault") //save to userDefaults
//            if(wcSession != nil){
//            if(wcSession!.isReachable){
//                do{
//                    try wcSession?.updateApplicationContext(["TestDurationSettingsUpdate":defaults.integer(forKey: "testDurationDefault")])
//                }catch{
//                    print("Error while sending application context")
//                }
//            }
//            }
//        }
//        else{
//            defaults.set(row, forKey: "testTypeDefault") //save to userDefaults
//            if(wcSession != nil){
//            if(wcSession!.isReachable){
//                do{
//                    try wcSession?.updateApplicationContext(["TestTypeSettingsUpdate":defaults.integer(forKey: "testTypeDefault")])
//                }catch{
//                    print("Error while sending application context")
//                }
//            }
//            }
//
//            if(row == 0){
//                changeToImmunoglobulin()
//            }
//            else{
//                changeFromImmunoglobulin()
//            }
//        }
//    }
    
    @objc private func manualCalibrationSwitchStateChanged(){
        if(manualCalibrationSwitch.isOn){
            defaults.set(true, forKey: "manualCalibrationDefault")
            //display y = mx + b option
            mManualCalibrationTextView.isHidden = false
            bManualCalibrationTextView.isHidden = false
        }
        else{
            defaults.set(false, forKey: "manualCalibrationDefault")
            mManualCalibrationTextView.isHidden = true
            bManualCalibrationTextView.isHidden = true
        }
    }
    
    @objc private func unitsSwitchStateChanged(){
        if(unitsSwitch.isOn){
            defaults.set(true, forKey: "unitsDefault")
        }
        else{
            defaults.set(false, forKey: "unitsDefault")
        }
    }
    
    
    
    @objc private func testingModeSwitchStateChanged(){
        
        print("testing mode switch changed")
        
        if(testingModeSwitch.isOn){
            defaults.set(true, forKey: "testingModeDefault")
        }
        else{
            defaults.set(false, forKey: "testingModeDefault")
        }
    }
    
    @objc private func quantitativeModeSwitchStateChanged(){
        
        print("quantitative mode switch changed")
        
        if(quantitativeModeSwitch.isOn){
            defaults.set(true, forKey: "quantitativeModeDefault")
        }
        else{
            defaults.set(false, forKey: "quantitativeModeDefault")
        }
    }
    
//    private func changeToImmunoglobulin(){
//        //change to final value
//        finalContinuousPicker.selectRow(0, inComponent: 0, animated: true)
//        finalContinuousTextView.text = "Final Value"
//        defaults.set(0, forKey: "finalContinuousDefault")
//        defaults.set("Final Value", forKey: "finalContinuousTextViewDefault")
//        if(wcSession != nil){
//            if(wcSession!.isReachable){
//                do{
//                    try wcSession?.updateApplicationContext(["FinalContSettingsUpdate":defaults.integer(forKey: "finalContinuousDefault")])
//                }catch{
//                    print("Error while sending application context")
//                }
//            }
//        }
//        testTypeLabel.textColor = .gray
//        finalContinuousTextView.textColor = .gray
//        finalContinuousBtn.isEnabled = false
//
//        //change test duration
//        testDurationPicker.selectRow(2, inComponent: 0, animated: true)
//        testDurationTextView.text = "15 Seconds"
//        defaults.set(2, forKey: "testDurationDefault")
//        defaults.set("15 Second", forKey: "testDurationTextViewDefault")
//        if(wcSession != nil){
//            if(wcSession!.isReachable){
//                do{
//                    try wcSession?.updateApplicationContext(["TestDurationSettingsUpdate":defaults.integer(forKey: "testDurationDefault")])
//                }catch{
//                    print("Error while sending application context")
//                }
//            }
//        }
//        testDurationLabel.textColor = .gray
//        testDurationTextView.textColor = .gray
//        testDurationBtn.isEnabled = false
//
//    }
    
//    private func changeFromImmunoglobulin(){
//        testTypeLabel.textColor = .black
//        finalContinuousTextView.textColor = .black
//        finalContinuousBtn.isEnabled = true
//
//        testDurationLabel.textColor = .black
//        testDurationTextView.textColor = .black
//        testDurationBtn.isEnabled = true
//    }
    
//    public func textViewDidBeginEditing(_ textView: UITextView) {
//        self.view.endEditing(true) //do not show keyboard
//
//        //finalContinuous
//        if(textView.tag == 0){
//            finalContinuousPicker.isHidden = false
//            finalContinuousPicker.isUserInteractionEnabled = true
//            selectBtn.isHidden = false
//            selectBtn.isEnabled = true
//
//            testDurationTextView.isEditable = false
//            testTypeTextView.isEditable = false
//        }
//
//        //testDuration
//        else if(textView.tag == 1){
//            testDurationPicker.isHidden = false
//            testDurationPicker.isUserInteractionEnabled = true
//            selectBtn.isHidden = false
//            selectBtn.isEnabled = true
//
//            finalContinuousTextView.isEditable = false
//            testTypeTextView.isEditable = false
//        }
//
//        //testType
//        else{
//            testTypePicker.isHidden = false
//            testTypePicker.isUserInteractionEnabled = true
//            selectBtn.isHidden = false
//            selectBtn.isEnabled = true
//
//            finalContinuousTextView.isEditable = false
//            testDurationTextView.isEditable = false
//        }
//    }
    
//    @objc private func finalContinuousBtnPressed(){
        
//        testTypeLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.70),
//                       initialSpringVelocity: CGFloat(5.0),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.testTypeLabel.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in()  }
//        )
//
//
//        mManualCalibrationTextView.isHidden = true
//        bManualCalibrationTextView.isHidden = true
//
//
//        testTypeLabel.textColor = .blue
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
//            self.testTypeLabel.textColor = .black
//        }
//
//        finalContinuousPicker.isHidden = false
//        finalContinuousPicker.isUserInteractionEnabled = true
//        selectBtn.isHidden = false
//        selectBtn.isEnabled = true
//
//        testDurationBtn.isEnabled = false
//        testTypeBtn.isEnabled = false
//    }
    
//    @objc private func testDurationBtnPressed(){
        
//        testDurationLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.70),
//                       initialSpringVelocity: CGFloat(5.0),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.testDurationLabel.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in()  }
//        )
//
//        mManualCalibrationTextView.isHidden = true
//        bManualCalibrationTextView.isHidden = true
//
//        testDurationLabel.textColor = .blue
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
//           self.testDurationLabel.textColor = .black
//        }
//
//        testDurationPicker.isHidden = false
//        testDurationPicker.isUserInteractionEnabled = true
//        selectBtn.isHidden = false
//        selectBtn.isEnabled = true
//
//        finalContinuousBtn.isEnabled = false
//        testTypeBtn.isEnabled = false
//    }
    
//    @objc private func testTypeBtnPressed(){
        
//        testTypePickerLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.70),
//                       initialSpringVelocity: CGFloat(5.0),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.testTypePickerLabel.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in()  }
//        )
//
//        mManualCalibrationTextView.isHidden = true
//        bManualCalibrationTextView.isHidden = true
//
//        testTypePickerLabel.textColor = .blue
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
//            self.testTypePickerLabel.textColor = .black
//        }
//
//        testTypePicker.isHidden = false
//        testTypePicker.isUserInteractionEnabled = true
//        selectBtn.isHidden = false
//        selectBtn.isEnabled = true
//
//        finalContinuousBtn.isEnabled = false
//        testDurationBtn.isEnabled = false
//    }
    
//    @objc private func selectBtnPressed(){
        
//        selectBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.70),
//                       initialSpringVelocity: CGFloat(5.0),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.selectBtn.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in()  }
//        )
//
//        if(finalContinuousPicker.isHidden == false){
//            switch finalContinuousPicker.selectedRow(inComponent: 0){
//                case 0:
//                    finalContinuousTextView.text = "Final Value"
//                    defaults.set("Final Value", forKey: "finalContinuousTextViewDefault")
//                case 1:
//                    finalContinuousTextView.text = "Continuous Value"
//                    defaults.set("Continuous Value", forKey: "finalContinuousTextViewDefault")
//                default:
//                    finalContinuousTextView.text = "Error"
//            }
//
//            finalContinuousPicker.isHidden = true
//            finalContinuousPicker.isUserInteractionEnabled = false
//            selectBtn.isHidden = true
//            selectBtn.isEnabled = false
//
//            testDurationBtn.isEnabled = true
//            testTypeBtn.isEnabled = true
////            testDurationTextView.isEditable = true
////            testTypeTextView.isEditable = true
//        }
//
//        else if(testDurationPicker.isHidden == false){
//            switch testDurationPicker.selectedRow(inComponent: 0){
//                case 0:
//                    testDurationTextView.text = "5 Seconds"
//                    defaults.set("5 Seconds", forKey: "testDurationTextViewDefault")
//                case 1:
//                    testDurationTextView.text = "10 Seconds"
//                    defaults.set("10 Seconds", forKey: "testDurationTextViewDefault")
//                case 2:
//                    testDurationTextView.text = "15 Seconds"
//                    defaults.set("15 Seconds", forKey: "testDurationTextViewDefault")
//                case 3:
//                    testDurationTextView.text = "20 Seconds"
//                    defaults.set("20 Seconds", forKey: "testDurationTextViewDefault")
//                case 4:
//                    testDurationTextView.text = "24 Seconds"
//                    defaults.set("24 Seconds", forKey: "testDurationTextViewDefault")
//                default:
//                    testDurationTextView.text = "Error"
//            }
//
//            testDurationPicker.isHidden = true
//            testDurationPicker.isUserInteractionEnabled = false
//            selectBtn.isHidden = true
//            selectBtn.isEnabled = false
//
//            finalContinuousBtn.isEnabled = true
//            testTypeBtn.isEnabled = true
////            finalContinuousTextView.isEditable = true
////            testTypeTextView.isEditable = true
//        }
//
//        else{
//            switch testTypePicker.selectedRow(inComponent: 0){
//                case 0:
//                    testTypeTextView.text = "Immunogobulins"
//                    defaults.set("Immunoglobulins", forKey: "testTypeTextViewDefault")
//                case 1:
//                    testTypeTextView.text = "Lactoferrin"
//                    defaults.set("Lactoferrin", forKey: "testTypeTextViewDefault")
//                case 2:
//                    testTypeTextView.text = "Blood Calcium"
//                    defaults.set("Blood Calcium", forKey: "testTypeTextViewDefault")
//                case 3:
//                    testTypeTextView.text = "Glucose"
//                    defaults.set("Glucose", forKey: "testTypeTextViewDefault")
//                default:
//                    testTypeTextView.text = "Error"
//            }
//
//
//            testTypePicker.isHidden = true
//            testTypePicker.isUserInteractionEnabled = false
//            selectBtn.isHidden = true
//            selectBtn.isEnabled = false
//
//            finalContinuousBtn.isEnabled = true
//            testDurationBtn.isEnabled = true
////            finalContinuousTextView.isEditable = true
////            testDurationTextView.isEditable = true
//
//            if(manualCalibrationSwitch.isOn){
//                //display y = mx + b option
//                mManualCalibrationTextView.isHidden = false
//                bManualCalibrationTextView.isHidden = false
//            }
//        }
//
//        if(defaults.integer(forKey: "testTypeDefault") == 0){
//            changeToImmunoglobulin()
//        }
//    }
    
    
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
            case "RunTest":
                DispatchQueue.main.async {
                    self.menuView?.setInQueueView(flag: 2)
                    self.navigationController?.popViewController(animated: true)
                }
            case "Settings":
                //do nothing
                print("do nothing case")
            default:
                print("Default case - do nothing")
            }
        }
        
//        else if(applicationContext["FinalContSettingsUpdate"] != nil){
//            DispatchQueue.main.async {
//                self.changeFromImmunoglobulin() //initially change from immunoglobulin test, change back to immunoglobulin test at end if immunoglobulin test selected from watch
//
//                self.finalContinuousPicker.selectRow(applicationContext["FinalContSettingsUpdate"] as! Int, inComponent: 0, animated: true)
//
//                switch(applicationContext["FinalContSettingsUpdate"] as! Int){
//                    case 0:
//                        self.finalContinuousTextView.text = "Final Value"
//                    case 1:
//                        self.finalContinuousTextView.text = "Continuous Value"
//                    default:
//                        print("default case - do nothing")
//                }
//
//                self.defaults.set(applicationContext["FinalContSettingsUpdate"] as! Int, forKey: "finalContinuousDefault")
//            }
//        }
//
//        else if(applicationContext["TestDurationSettingsUpdate"] != nil){
//            DispatchQueue.main.async {
//                self.testDurationPicker.selectRow(applicationContext["TestDurationSettingsUpdate"] as! Int, inComponent: 0, animated: true)
//
//                switch(applicationContext["TestDurationSettingsUpdate"] as! Int){
//                    case 0:
//                        self.testDurationTextView.text = "5 Seconds"
//                    case 1:
//                        self.testDurationTextView.text = "10 Seconds"
//                    case 2:
//                        self.testDurationTextView.text = "15 Seconds"
//                    case 3:
//                        self.testDurationTextView.text = "20 Seconds"
//                    default:
//                        print("default case - do nothing")
//                }
//
//                self.defaults.set(applicationContext["TestDurationSettingsUpdate"] as! Int, forKey: "testDurationDefault")
//            }
//        }
//
//        else if(applicationContext["TestTypeSettingsUpdate"] != nil){
//            DispatchQueue.main.async {
//                self.testTypePicker.selectRow(applicationContext["TestTypeSettingsUpdate"] as! Int, inComponent: 0, animated: true)
//
//                switch(applicationContext["TestTypeSettingsUpdate"] as! Int){
//                    case 0:
//                        self.testTypeTextView.text = "Immunoglobulins"
//                        self.changeToImmunoglobulin()
//                    case 1:
//                        self.testTypeTextView.text = "Lactoferrin"
//                    case 2:
//                        self.testTypeTextView.text = "Blood Calcium"
//                    case 3:
//                        self.testTypeTextView.text = "Glucose"
//                    default:
//                        print("default case - do nothing")
//                }
//
//                self.defaults.set(applicationContext["TestTypeSettingsUpdate"] as! Int, forKey: "testDurationDefault")
//            }
//        }
    }
    
    @objc private func doneKeyboardBtnPressed(){
        view.endEditing(true)
    }
    
    
    //GETTERS/SETTERS
    
    public func getWCSession() -> WCSession{
        return wcSession!
    }
    
    public func setWCSession(session: WCSession?){
        wcSession = session
    }
    
    
    public func getManualCalibrationSwitchValue() -> Bool{
        return defaults.bool(forKey: "manualCalibrationDefault")
    }
    
    public func getUnitsSwitchValue() -> Bool{
        return defaults.bool(forKey: "unitsDefault")
    }
    
    public func getManCalMVal() -> Float{
        if(mManualCalibrationTextView.text == nil){
            return 0.0
        }
        else if(mManualCalibrationTextView.text! == ""){
            return 0.0
        }
        else{
            return Float(mManualCalibrationTextView.text!)!
        }
    }
    
    public func getManCalBVal() -> Float{
        if(bManualCalibrationTextView.text == nil){
            return 0.0
        }
        else if(bManualCalibrationTextView.text! == ""){
            return 0.0
        }
        else{
            return Float(bManualCalibrationTextView.text!)!
        }
    }
    
    public func getTestDurationVal() -> Int{
        if(testDurationTextView.text == nil){
            return 7
        }
        else if(testDurationTextView.text! == ""){
            return 7
        }
        else if(Int(testDurationTextView.text!)! <= 0){
            return 7
        }
        else{
            return Int(testDurationTextView.text!)!
        }
    }
    
    public func getTestingModeDefault() -> Bool{
        return defaults.bool(forKey: "testingModeDefault")
    }
    
    public func getCalibrationModeDefault() -> Bool{
        return defaults.bool(forKey: "calibrationModeDefault")
    }
    
    public func getQuantitativeModeDefault() -> Bool{
        return defaults.bool(forKey: "quantitativeModeDefault")
    }
    
    
}
