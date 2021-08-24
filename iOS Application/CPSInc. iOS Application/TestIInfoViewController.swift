//
//  TestIInfoViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-27.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH DISPLAYING THE TEST INFO WHEN TEST SELECTED

import UIKit

class TestInfoViewController: UIViewController {

    private var testLogbook: TestLogbookViewController? = nil
    private var appDelegate: AppDelegate? = nil
    
    private var selectedTest: Test? = nil
    
    private let dateLabel = UILabel()
    //private let dataTypeLabel = UILabel()
    //private let runtimeLabel = UILabel()
    private let testTypeLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitsLabel = UILabel()
    
    private let dateTextView = UITextView()
    //private let dataTypeTextView = UITextView()
    //private let runtimeTextView = UITextView()
    private let testTypeTextView = UITextView()
    private let valueTextView = UITextView()
    private let unitsTextView = UITextView()
    
    
    
    //RECOMMENDATIONS
    
    private var severeHypocalcemiaRecommendationBtn = UIButton()
    private var subClinicalHypocalcemiaRecommendationBtn = UIButton()
    private var normalCalcemiaRecommendationBtn = UIButton()
    
    private var zoneSpecificRecommendationLabel = UILabel()
    
    //UIProgressView
    private let testProgressView = UIProgressView(progressViewStyle: UIProgressView.Style.default)
    private let testResultProgressBar = UIProgressView(progressViewStyle: UIProgressView.Style.default)
    private let testProgressIndicator = UIImageView()

    //recommendationBoxes
    private let recommendationBoxLeft = UIImageView()
    private let recommendationBoxMiddle = UIImageView()
    private let recommendationBoxRight = UIImageView()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Test Info"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupComponents()
        setupLayoutConstraints()
        setupBtnListeners()
    }
    

    private func setupComponents(){
        //setup layout components here
        dateLabel.text = "Date:"
        view.addSubview(dateLabel)
        
//        dataTypeLabel.text = "Data Collection Type:"
//        view.addSubview(dataTypeLabel)
//
//        runtimeLabel.text = "Test Runtime:"
//        view.addSubview(runtimeLabel)
        
        testTypeLabel.text = "Test Type:"
        view.addSubview(testTypeLabel)
        
        valueLabel.text = "Value:"
        view.addSubview(valueLabel)
        
        unitsLabel.text = "Units:"
        view.addSubview(unitsLabel)
        
        view.addSubview(dateTextView)
        
//        view.addSubview(dataTypeTextView)
//
//        view.addSubview(runtimeTextView)
        
        view.addSubview(testTypeTextView)
        
        view.addSubview(valueTextView)
        
        view.addSubview(unitsTextView)
        
        
        //RECOMMENDATIONS
        
        //zoneSpecificRecommendationLabel
        zoneSpecificRecommendationLabel.text = "* Click anywhere on the gradient to view CPS's zone-specific recommendations *" //will be filled out with the test result
        zoneSpecificRecommendationLabel.textColor = .black //will be set based on test results
        zoneSpecificRecommendationLabel.font = zoneSpecificRecommendationLabel.font.withSize(15) //adjust font size
        zoneSpecificRecommendationLabel.textAlignment = .center
        zoneSpecificRecommendationLabel.numberOfLines = 2
        view.addSubview(zoneSpecificRecommendationLabel)
        //zoneSpecificRecommendationLabel.isHidden = true
        
        //testResultProgressBar
        self.testResultProgressBar.progressImage = UIImage(named: "TestGradient")
        self.view.addSubview(self.testResultProgressBar)
        //self.testResultProgressBar.isHidden = true
                
                //these have to be added to the view after the testResultProgressBar so that they can be pressed on top of it
        //        severeHypocalcemiaRecommendationBtn.backgroundColor = .blue
        //        severeHypocalcemiaRecommendationBtn.setTitle("Severe Hypo", for: .normal)
        //        severeHypocalcemiaRecommendationBtn.setTitleColor(.white, for: .normal)
        //        severeHypocalcemiaRecommendationBtn.layer.borderWidth = 2
        //        severeHypocalcemiaRecommendationBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(severeHypocalcemiaRecommendationBtn)
//        severeHypocalcemiaRecommendationBtn.isHidden = true
//        severeHypocalcemiaRecommendationBtn.isEnabled = false
                
        //        subClinicalHypocalcemiaRecommendationBtn.backgroundColor = .blue
        //        subClinicalHypocalcemiaRecommendationBtn.setTitle("Subclinical Hypo", for: .normal)
        //        subClinicalHypocalcemiaRecommendationBtn.setTitleColor(.white, for: .normal)
        //        subClinicalHypocalcemiaRecommendationBtn.layer.borderWidth = 2
        //        subClinicalHypocalcemiaRecommendationBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(subClinicalHypocalcemiaRecommendationBtn)
//        subClinicalHypocalcemiaRecommendationBtn.isHidden = true
//        subClinicalHypocalcemiaRecommendationBtn.isEnabled = false
                
        //        normalCalcemiaRecommendationBtn.backgroundColor = .blue
        //        normalCalcemiaRecommendationBtn.setTitle("Normal Calc", for: .normal)
        //        normalCalcemiaRecommendationBtn.setTitleColor(.white, for: .normal)
        //        normalCalcemiaRecommendationBtn.layer.borderWidth = 2
        view.addSubview(normalCalcemiaRecommendationBtn)
//        normalCalcemiaRecommendationBtn.isHidden = true
//        normalCalcemiaRecommendationBtn.isEnabled = false
        
        //testProgressIndicator
        testProgressIndicator.image = UIImage(named: "arrowIndicator")
        self.view.addSubview(self.testProgressIndicator)
        //testProgressIndicator.isHidden = true
        
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
    }
    
    private func setupLayoutConstraints(){
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        dateTextView.translatesAutoresizingMaskIntoConstraints = false
        dateTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dateTextView.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        dateTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dateTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
//        dataTypeLabel.translatesAutoresizingMaskIntoConstraints = false
//        dataTypeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        dataTypeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//        dataTypeTextView.translatesAutoresizingMaskIntoConstraints = false
//        dataTypeTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        dataTypeTextView.leftAnchor.constraint(equalTo: dataTypeLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        dataTypeTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        dataTypeTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        runtimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        runtimeLabel.topAnchor.constraint(equalTo: dataTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        runtimeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//        runtimeTextView.translatesAutoresizingMaskIntoConstraints = false
//        runtimeTextView.topAnchor.constraint(equalTo: dataTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        runtimeTextView.leftAnchor.constraint(equalTo: runtimeLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        runtimeTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        runtimeTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        testTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        testTypeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testTypeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        testTypeTextView.translatesAutoresizingMaskIntoConstraints = false
        testTypeTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testTypeTextView.leftAnchor.constraint(equalTo: testTypeLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        testTypeTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        testTypeTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.topAnchor.constraint(equalTo: testTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        valueTextView.translatesAutoresizingMaskIntoConstraints = false
        valueTextView.topAnchor.constraint(equalTo: testTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        valueTextView.leftAnchor.constraint(equalTo: valueLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        valueTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        valueTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        unitsLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        unitsLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        unitsTextView.translatesAutoresizingMaskIntoConstraints = false
        unitsTextView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        unitsTextView.leftAnchor.constraint(equalTo: unitsLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        unitsTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        unitsTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        zoneSpecificRecommendationLabel.translatesAutoresizingMaskIntoConstraints = false
        zoneSpecificRecommendationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        zoneSpecificRecommendationLabel.topAnchor.constraint(equalTo: unitsTextView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        zoneSpecificRecommendationLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
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
        
        
    }
    
    private func setupBtnListeners(){
        severeHypocalcemiaRecommendationBtn.addTarget(self, action: #selector(severeHypocalcemiaRecommendationBtnListener), for: .touchUpInside)
        subClinicalHypocalcemiaRecommendationBtn.addTarget(self, action: #selector(subClinicalHypocalcemiaRecommendationBtnListener), for: .touchUpInside)
        normalCalcemiaRecommendationBtn.addTarget(self, action: #selector(normalCalcemiaRecommendationBtnListener), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        
        dateTextView.text = dateformatter.string(from: selectedTest!.date! as Date)
        //dataTypeTextView.text = selectedTest?.dataType
        //runtimeTextView.text = (selectedTest?.runtime)!.stringValue
        testTypeTextView.text = selectedTest?.testType
        valueTextView.text = String((selectedTest?.value)!)
        unitsTextView.text = selectedTest?.units
        
        var progressRatio: Double? = nil
        
        if(unitsTextView.text! == "mg/dL"){
            progressRatio = Double(valueTextView.text!)! / 14.0 //our scale goes up to 14mg/dL
            //print(progressRatio)
        }
        else{
            progressRatio = (Double(valueTextView.text!)! * 4) / 14.0 //our scale goes up to 14mg/dL
        }
        
        self.testProgressIndicator.removeConstraints(self.testProgressIndicator.constraints)
        self.testProgressIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.testProgressIndicator.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        self.testProgressIndicator.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        self.testProgressIndicator.topAnchor.constraint(equalTo: self.testResultProgressBar.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
        if(progressRatio! <= 1 && progressRatio! > 0){
            self.testProgressIndicator.leftAnchor.constraint(equalTo: self.testResultProgressBar.leftAnchor, constant: ((UIScreen.main.bounds.width * 0.75) * CGFloat(progressRatio!))).isActive = true
        }
        else if(progressRatio! <= 0){
            self.testProgressIndicator.leftAnchor.constraint(equalTo: self.testResultProgressBar.leftAnchor).isActive = true
        }
        else{
            self.testProgressIndicator.leftAnchor.constraint(equalTo: self.testResultProgressBar.leftAnchor, constant: ((UIScreen.main.bounds.width * 0.75))).isActive = true
        }
        self.testProgressIndicator.isHidden = false
        
        if(selectedTest!.milkFever){
            if(self.testLogbook?.cowLogbook?.herdLogbook?.menuView?.getSettingsView().getUnitsSwitchValue() == false){ //MGDL
                self.recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftMilkFeverMGDL")
                self.recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleMilkFeverMGDL")
                self.recommendationBoxRight.image = UIImage(named: "recommendationBoxRightMilkFeverMGDL")
            }
            else if(self.testLogbook?.cowLogbook?.herdLogbook?.menuView?.getSettingsView().getUnitsSwitchValue() == true){ //MGDL
                self.recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftMilkFeverMM")
                self.recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleMilkFeverMM")
                self.recommendationBoxRight.image = UIImage(named: "recommendationBoxRightMilkFeverMM")
            }
        }
        else{
            if(self.testLogbook?.cowLogbook?.herdLogbook?.menuView?.getSettingsView().getUnitsSwitchValue() == false){ //MGDL
                self.recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftNoMilkFeverMGDL")
                self.recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleNoMilkFeverMGDL")
                self.recommendationBoxRight.image = UIImage(named: "recommendationBoxRightNoMilkFeverMGDL")
            }
            else if(self.testLogbook?.cowLogbook?.herdLogbook?.menuView?.getSettingsView().getUnitsSwitchValue() == true){ //MGDL
                self.recommendationBoxLeft.image = UIImage(named: "recommendationBoxLeftNoMilkFeverMM")
                self.recommendationBoxMiddle.image = UIImage(named: "recommendationBoxMiddleNoMilkFeverMM")
                self.recommendationBoxRight.image = UIImage(named: "recommendationBoxRightNoMilkFeverMM")
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
    
    
    public convenience init(testLogbook: TestLogbookViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.testLogbook = testLogbook
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

    
    //getters/setters
    public func setSelectedTest(test: Test){
        self.selectedTest = test
    }
}
