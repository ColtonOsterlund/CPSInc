//
//  SettingsViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-05-24.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore //to be able to round the background edges on the switches
import WatchConnectivity

public class SettingsViewController: UIViewController, WCSessionDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //View Controllers
    private var menuView: MenuViewController? = nil
    private var appDelegate: AppDelegate? = nil
//    private var connectView: ConnectViewController? = nil
//    private var testView: TestViewController? = nil
    
    //Labels
    private let testTypeLabel = UILabel()
    private let testDurationLabel = UILabel()
    private let testTypePickerLabel = UILabel()
    
    //PickerView
    private let finalContinuousPicker = UIPickerView()
    private let testDurationPicker = UIPickerView()
    private let testTypePicker = UIPickerView()
    
    //User Defaults
    private let defaults = UserDefaults.standard
    
    //textViews
    private let finalContinuousTextView = UILabel()
    private let testDurationTextView = UILabel()
    private let testTypeTextView = UILabel()
    
    //buttons
    private let selectBtn = UIButton()
    private let finalContinuousBtn = UIButton()
    private let testDurationBtn = UIButton()
    private let testTypeBtn = UIButton()
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    //picker data
    private let finalContinuousPickerTitles = ["Final Value", "Continuous Value"]
    private let testDurationPickerTitles = ["5 Seconds", "10 Seconds", "15 Seconds", "20 Seconds", "24 Seconds"]
    private let testTypePickerTitles = ["Immunoglobulins", "Lactoferrin", "Blood Calcium", "Glucose"]
   
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Configure Settings"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        //these should be done upon initialization instead of upon view loading so that the saved settings can be accessed in different controllers
        createLayoutItems()
        setLayoutConstraints()
//        setButtonListeners()
//        checkForSavedSettings()
        
//        if (WCSession.isSupported()) {
//            wcSession = WCSession.default
//            wcSession!.delegate = self
//            wcSession!.activate()
//            print("wcSession has been activated on mobile - SettingsViewController")
//        }
    }
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(menuView: MenuViewController, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.menuView = menuView
        self.appDelegate = appDelegate
        
        createLayoutItems()
        setLayoutConstraints()
    }

    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //register default settings off on init - will only happen if these have not been created on the device before
        defaults.register(defaults: ["finalContinuousDefault": 0])
        defaults.register(defaults: ["testDurationDefault": 0])
        defaults.register(defaults: ["testTypeDefault": 0])
        defaults.register(defaults: ["finalContinuousTextViewDefault": "Final Value"])
        defaults.register(defaults: ["testDurationTextViewDefault": "5 Seconds"])
        defaults.register(defaults: ["testTypeTextViewDefault": "Immunoglobulins"])
    }

    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }
    
    private func createLayoutItems(){
        //testTypeLabel
        let underlinedTestTypeLabelString: NSMutableAttributedString =  NSMutableAttributedString(string: "Final Vs. Cont:")
        underlinedTestTypeLabelString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, underlinedTestTypeLabelString.length))
        testTypeLabel.attributedText = underlinedTestTypeLabelString
        testTypeLabel.textColor = .black
        testTypeLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        testTypeLabel.textAlignment = .center
        view.addSubview(testTypeLabel)
        
        
        let underlinedTestDurationLabelString: NSMutableAttributedString = NSMutableAttributedString(string: "Test Duration:")
        underlinedTestDurationLabelString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, underlinedTestDurationLabelString.length))
        testDurationLabel.attributedText = underlinedTestDurationLabelString
        testDurationLabel.textColor = .black
        testDurationLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        testDurationLabel.textAlignment = .center
        view.addSubview(testDurationLabel)
        
        
        let underlinedTestTypePickerLabel: NSMutableAttributedString = NSMutableAttributedString(string: "Test Type:")
        underlinedTestTypePickerLabel.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, underlinedTestTypePickerLabel.length))
        testTypePickerLabel.attributedText = underlinedTestTypePickerLabel
        testTypePickerLabel.textColor = .black
        testTypePickerLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        testTypePickerLabel.textAlignment = .center
        view.addSubview(testTypePickerLabel)
        
        finalContinuousPicker.tag = 0
        finalContinuousPicker.backgroundColor = .gray
        finalContinuousPicker.layer.borderColor = UIColor.black.cgColor
        finalContinuousPicker.layer.borderWidth = 1
        finalContinuousPicker.delegate = self
        finalContinuousPicker.dataSource = self
        finalContinuousPicker.selectRow(defaults.integer(forKey: "finalContinuousDefault"), inComponent: 0, animated: true)
        finalContinuousPicker.isHidden = true //hide until needed
        finalContinuousPicker.isUserInteractionEnabled = false //disable until needed
        view.addSubview(finalContinuousPicker)
        
        testDurationPicker.tag = 1
        testDurationPicker.backgroundColor = .gray
        testDurationPicker.layer.borderColor = UIColor.black.cgColor
        testDurationPicker.layer.borderWidth = 1
        testDurationPicker.delegate = self
        testDurationPicker.dataSource = self
        testDurationPicker.selectRow(defaults.integer(forKey: "testDurationDefault"), inComponent: 0, animated: true)
        testDurationPicker.isHidden = true //hide until needed
        testDurationPicker.isUserInteractionEnabled = false //disable until needed
        view.addSubview(testDurationPicker)
        
       // testTypePicker.frame = CGRect(x: 400, y: 200, width: 50, height: 10)
        testTypePicker.tag = 2
        testTypePicker.backgroundColor = .gray
        testTypePicker.layer.borderColor = UIColor.black.cgColor
        testTypePicker.layer.borderWidth = 1
        testTypePicker.delegate = self
        testTypePicker.dataSource = self
        testTypePicker.selectRow(defaults.integer(forKey: "testTypeDefault"), inComponent: 0, animated: true)
        testTypePicker.isHidden = true //hide until needed
        testTypePicker.isUserInteractionEnabled = false //disable until needed
        view.addSubview(testTypePicker)
        
        finalContinuousTextView.text = defaults.string(forKey: "finalContinuousTextViewDefault")
//        finalContinuousTextView.layer.borderWidth = 0.5
//        finalContinuousTextView.layer.backgroundColor = UIColor.gray.cgColor
//        finalContinuousTextView.layer.borderColor = UIColor.black.cgColor
        //finalContinuousTextView.delegate = self
        finalContinuousTextView.tag = 0
        view.addSubview(finalContinuousTextView)
        
        
        testDurationTextView.text = defaults.string(forKey: "testDurationTextViewDefault")
//        testDurationTextView.layer.borderWidth = 0.5
//        testDurationTextView.layer.backgroundColor = UIColor.gray.cgColor
//        testDurationTextView.layer.borderColor = UIColor.black.cgColor
        //testDurationTextView.delegate = self
        testDurationTextView.tag = 1
        view.addSubview(testDurationTextView)
        
        
        testTypeTextView.text = defaults.string(forKey: "testTypeTextViewDefault")
        //testTypeTextView.layer.borderWidth = 0.5
        //testTypeTextView.layer.backgroundColor = UIColor.gray.cgColor
        //testTypeTextView.layer.borderColor = UIColor.black.cgColor
        //testTypeTextView.delegate = self
        testTypeTextView.tag = 2
        view.addSubview(testTypeTextView)
        
        selectBtn.setTitle("Select", for: .normal)
        selectBtn.setTitleColor(.white, for: .normal)
        selectBtn.backgroundColor = .gray
        selectBtn.layer.borderWidth = 1
        selectBtn.layer.borderColor = UIColor.black.cgColor
        selectBtn.addTarget(self, action: #selector(selectBtnPressed), for: .touchUpInside)
        selectBtn.isHidden = true
        selectBtn.isEnabled = false
        view.addSubview(selectBtn)
        
        finalContinuousBtn.addTarget(self, action: #selector(finalContinuousBtnPressed), for: .touchUpInside)
        finalContinuousBtn.isHidden = false
        finalContinuousBtn.isEnabled = true
        view.addSubview(finalContinuousBtn)
        
        testDurationBtn.addTarget(self, action: #selector(testDurationBtnPressed), for: .touchUpInside)
        testDurationBtn.isHidden = false
        testDurationBtn.isEnabled = true
        view.addSubview(testDurationBtn)
        
        testTypeBtn.addTarget(self, action: #selector(testTypeBtnPressed), for: .touchUpInside)
        testTypeBtn.isHidden = false
        testTypeBtn.isEnabled = true
        view.addSubview(testTypeBtn)
        
    }
    
    private func setLayoutConstraints(){
        testTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        testTypeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testTypeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        testDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        testDurationLabel.topAnchor.constraint(equalTo: testTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testDurationLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        testTypePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        testTypePickerLabel.topAnchor.constraint(equalTo: testDurationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testTypePickerLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        
        finalContinuousBtn.translatesAutoresizingMaskIntoConstraints = false
        finalContinuousBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        finalContinuousBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        finalContinuousBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.45)).isActive = true
        finalContinuousBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        testDurationBtn.translatesAutoresizingMaskIntoConstraints = false
        testDurationBtn.topAnchor.constraint(equalTo: testTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testDurationBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        testDurationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.45)).isActive = true
        testDurationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        testTypeBtn.translatesAutoresizingMaskIntoConstraints = false
        testTypeBtn.topAnchor.constraint(equalTo: testDurationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testTypeBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.07)).isActive = true
        testTypeBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.45)).isActive = true
        testTypeBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        finalContinuousTextView.translatesAutoresizingMaskIntoConstraints = false
        finalContinuousTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        finalContinuousTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.05)).isActive = true
        finalContinuousTextView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.4)).isActive = true
        finalContinuousTextView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        testDurationTextView.translatesAutoresizingMaskIntoConstraints = false
        testDurationTextView.topAnchor.constraint(equalTo: testTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testDurationTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.05)).isActive = true
        testDurationTextView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.4)).isActive = true
        testDurationTextView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        testTypeTextView.translatesAutoresizingMaskIntoConstraints = false
        testTypeTextView.topAnchor.constraint(equalTo: testDurationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testTypeTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.05)).isActive = true
        testTypeTextView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.4)).isActive = true
        testTypeTextView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        
        
        finalContinuousPicker.translatesAutoresizingMaskIntoConstraints = false
        finalContinuousPicker.topAnchor.constraint(equalTo: testTypePickerLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        finalContinuousPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        finalContinuousPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        finalContinuousPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.35)).isActive = true
        
        testDurationPicker.translatesAutoresizingMaskIntoConstraints = false
        testDurationPicker.topAnchor.constraint(equalTo: testTypePickerLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        testDurationPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        testDurationPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        testDurationPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.35)).isActive = true
        
        testTypePicker.translatesAutoresizingMaskIntoConstraints = false
        testTypePicker.topAnchor.constraint(equalTo: testTypePickerLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        testTypePicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        testTypePicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        testTypePicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.35)).isActive = true
        
        selectBtn.translatesAutoresizingMaskIntoConstraints = false
        selectBtn.topAnchor.constraint(equalTo: finalContinuousPicker.bottomAnchor).isActive = true
        selectBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        selectBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        selectBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        
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
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(pickerView.tag == 0){
            return 1
        }
        else if(pickerView.tag == 1){
            return 1
        }
        else{
            return 1
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0){
            return finalContinuousPickerTitles.count
        }
        else if(pickerView.tag == 1){
            return testDurationPickerTitles.count
        }
        else{
            return testTypePickerTitles.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            return finalContinuousPickerTitles[row]
        }
        else if(pickerView.tag == 1){
            return testDurationPickerTitles[row]
        }
        else{
            return testTypePickerTitles[row]
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 0){
            defaults.set(row, forKey: "finalContinuousDefault") //save to userDefaults
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["FinalContSettingsUpdate":defaults.integer(forKey: "finalContinuousDefault")])
                }catch{
                    print("Error while sending application context")
                }
            }
        }
        else if(pickerView.tag == 1){
            defaults.set(row, forKey: "testDurationDefault") //save to userDefaults
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestDurationSettingsUpdate":defaults.integer(forKey: "testDurationDefault")])
                }catch{
                    print("Error while sending application context")
                }
            }
        }
        else{
            defaults.set(row, forKey: "testTypeDefault") //save to userDefaults
            
            if(wcSession!.isReachable){
                do{
                    try wcSession?.updateApplicationContext(["TestTypeSettingsUpdate":defaults.integer(forKey: "testTypeDefault")])
                }catch{
                    print("Error while sending application context")
                }
            }
        }
    }
    
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
    
    @objc private func finalContinuousBtnPressed(){
        
        testTypeLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.testTypeLabel.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        testTypeLabel.textColor = .blue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.testTypeLabel.textColor = .black
        }
        
        finalContinuousPicker.isHidden = false
        finalContinuousPicker.isUserInteractionEnabled = true
        selectBtn.isHidden = false
        selectBtn.isEnabled = true
        
        testDurationBtn.isEnabled = false
        testTypeBtn.isEnabled = false
    }
    
    @objc private func testDurationBtnPressed(){
        
        testDurationLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.testDurationLabel.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        testDurationLabel.textColor = .blue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
           self.testDurationLabel.textColor = .black
        }
        
        testDurationPicker.isHidden = false
        testDurationPicker.isUserInteractionEnabled = true
        selectBtn.isHidden = false
        selectBtn.isEnabled = true
        
        finalContinuousBtn.isEnabled = false
        testTypeBtn.isEnabled = false
    }
    
    @objc private func testTypeBtnPressed(){
        
        testTypePickerLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.testTypePickerLabel.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        testTypePickerLabel.textColor = .blue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.testTypePickerLabel.textColor = .black
        }
        
        testTypePicker.isHidden = false
        testTypePicker.isUserInteractionEnabled = true
        selectBtn.isHidden = false
        selectBtn.isEnabled = true
        
        finalContinuousBtn.isEnabled = false
        testDurationBtn.isEnabled = false
    }
    
    @objc private func selectBtnPressed(){
        
        selectBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.selectBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        if(finalContinuousPicker.isHidden == false){
            switch finalContinuousPicker.selectedRow(inComponent: 0){
                case 0:
                    finalContinuousTextView.text = "Final Value"
                    defaults.set("Final Value", forKey: "finalContinuousTextViewDefault")
                case 1:
                    finalContinuousTextView.text = "Continuous Value"
                    defaults.set("Continuous Value", forKey: "finalContinuousTextViewDefault")
                default:
                    finalContinuousTextView.text = "Error"
            }
            
            finalContinuousPicker.isHidden = true
            finalContinuousPicker.isUserInteractionEnabled = false
            selectBtn.isHidden = true
            selectBtn.isEnabled = false
            
            testDurationBtn.isEnabled = true
            testTypeBtn.isEnabled = true
//            testDurationTextView.isEditable = true
//            testTypeTextView.isEditable = true
        }
        
        else if(testDurationPicker.isHidden == false){
            switch testDurationPicker.selectedRow(inComponent: 0){
                case 0:
                    testDurationTextView.text = "5 Seconds"
                    defaults.set("5 Seconds", forKey: "testDurationTextViewDefault")
                case 1:
                    testDurationTextView.text = "10 Seconds"
                    defaults.set("10 Seconds", forKey: "testDurationTextViewDefault")
                case 2:
                    testDurationTextView.text = "15 Seconds"
                    defaults.set("15 Seconds", forKey: "testDurationTextViewDefault")
                case 3:
                    testDurationTextView.text = "20 Seconds"
                    defaults.set("20 Seconds", forKey: "testDurationTextViewDefault")
                case 4:
                    testDurationTextView.text = "24 Seconds"
                    defaults.set("24 Seconds", forKey: "testDurationTextViewDefault")
                default:
                    testDurationTextView.text = "Error"
            }
            
            testDurationPicker.isHidden = true
            testDurationPicker.isUserInteractionEnabled = false
            selectBtn.isHidden = true
            selectBtn.isEnabled = false
            
            finalContinuousBtn.isEnabled = true
            testTypeBtn.isEnabled = true
//            finalContinuousTextView.isEditable = true
//            testTypeTextView.isEditable = true
        }
        
        else{
            switch testTypePicker.selectedRow(inComponent: 0){
                case 0:
                    testTypeTextView.text = "Immunogobulins"
                    defaults.set("Immunoglobulins", forKey: "testTypeTextViewDefault")
                case 1:
                    testTypeTextView.text = "Lactoferrin"
                    defaults.set("Lactoferrin", forKey: "testTypeTextViewDefault")
                case 2:
                    testTypeTextView.text = "Blood Calcium"
                    defaults.set("Blood Calcium", forKey: "testTypeTextViewDefault")
                case 3:
                    testTypeTextView.text = "Glucose"
                    defaults.set("Glucose", forKey: "testTypeTextViewDefault")
                default:
                    testTypeTextView.text = "Error"
            }
            
            
            testTypePicker.isHidden = true
            testTypePicker.isUserInteractionEnabled = false
            selectBtn.isHidden = true
            selectBtn.isEnabled = false
            
            finalContinuousBtn.isEnabled = true
            testDurationBtn.isEnabled = true
//            finalContinuousTextView.isEditable = true
//            testDurationTextView.isEditable = true
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
        
        else if(applicationContext["FinalContSettingsUpdate"] != nil){
            DispatchQueue.main.async {
                self.finalContinuousPicker.selectRow(applicationContext["FinalContSettingsUpdate"] as! Int, inComponent: 0, animated: true)
                
                switch(applicationContext["FinalContSettingsUpdate"] as! Int){
                    case 0:
                        self.finalContinuousTextView.text = "Final Value"
                    case 1:
                        self.finalContinuousTextView.text = "Continuous Value"
                    default:
                        print("default case - do nothing")
                }
                
                self.defaults.set(applicationContext["FinalContSettingsUpdate"] as! Int, forKey: "finalContinuousDefault")
            }
        }
        
        else if(applicationContext["TestDurationSettingsUpdate"] != nil){
            DispatchQueue.main.async {
                self.testDurationPicker.selectRow(applicationContext["TestDurationSettingsUpdate"] as! Int, inComponent: 0, animated: true)
                
                switch(applicationContext["TestDurationSettingsUpdate"] as! Int){
                    case 0:
                        self.testDurationTextView.text = "5 Seconds"
                    case 1:
                        self.testDurationTextView.text = "10 Seconds"
                    case 2:
                        self.testDurationTextView.text = "15 Seconds"
                    case 3:
                        self.testDurationTextView.text = "20 Seconds"
                    default:
                        print("default case - do nothing")
                }
                
                self.defaults.set(applicationContext["TestDurationSettingsUpdate"] as! Int, forKey: "testDurationDefault")
            }
        }
        
        else if(applicationContext["TestTypeSettingsUpdate"] != nil){
            DispatchQueue.main.async {
                self.testTypePicker.selectRow(applicationContext["TestTypeSettingsUpdate"] as! Int, inComponent: 0, animated: true)
                
                switch(applicationContext["TestTypeSettingsUpdate"] as! Int){
                    case 0:
                        self.testTypeTextView.text = "Immunoglobulins"
                    case 1:
                        self.testTypeTextView.text = "Lactoferrin"
                    case 2:
                        self.testTypeTextView.text = "Blood Calcium"
                    case 3:
                        self.testTypeTextView.text = "Glucose"
                    default:
                        print("default case - do nothing")
                }
                
                self.defaults.set(applicationContext["TestTypeSettingsUpdate"] as! Int, forKey: "testDurationDefault")
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
    
    public func getFinalContinuous() -> Bool{
        //returns true if Final Value Test, returns false if Continuous Value Test
        if(finalContinuousPicker.selectedRow(inComponent: 0) == 0){
            return true
        }
        else{
            return false
        }
    }
    
    public func getTestDuration() -> Int{
        //returns the amount of seconds to run the test
        if(testDurationPicker.selectedRow(inComponent: 0) == 0){
            return 5
        }
        else if(testDurationPicker.selectedRow(inComponent: 0) == 1){
            return 10
        }
        else if(testDurationPicker.selectedRow(inComponent: 0) == 2){
            return 15
        }
        else if(testDurationPicker.selectedRow(inComponent: 0) == 3){
            return 20
        }
        else{
            return 24
        }
    }
    
    public func getTestType() -> Int{
        //returns 0 if Immunoglobulins, 1 if Lactoferin, 2 if Blood Calcium, 3 if Generic Glucose
        return testTypePicker.selectedRow(inComponent: 0)
    }
    
    
}
