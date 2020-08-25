//
//  RecommendationPageViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-07-21.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit

class RecommendationPageViewController: UIViewController {
    
    //views
    private var appDelegate: AppDelegate? = nil
    private var menuView: MenuViewController? = nil
    
    
    private var severeHypocalcemiaRecommendationBtn = UIButton()
    private var subClinicalHypocalcemiaRecommendationBtn = UIButton()
    private var normalCalcemiaRecommendationBtn = UIButton()
    
    private var zoneSpecificRecommendationLabel = UILabel()
    
    //UIProgressView
    private let testProgressView = UIProgressView(progressViewStyle: UIProgressView.Style.default)
    private let testResultProgressBar = UIProgressView(progressViewStyle: UIProgressView.Style.default)

    //recommendationBoxes
    private let recommendationBoxLeft = UIImageView()
    private let recommendationBoxMiddle = UIImageView()
    private let recommendationBoxRight = UIImageView()
    
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(appDelegate: AppDelegate?, menuView: MenuViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.appDelegate = appDelegate
        self.menuView = menuView
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Recommendations"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupLayoutComponents()
        setupLayoutConstraints()
        setupBtnListeners()
    }
    
    
    private func setupLayoutComponents(){
        //zoneSpecificRecommendationLabel
                zoneSpecificRecommendationLabel.text = "* Click anywhere on the gradient to view CPS's zone-specific recommendations *" //will be filled out with the test result
                zoneSpecificRecommendationLabel.textColor = .black //will be set based on test results
                zoneSpecificRecommendationLabel.font = zoneSpecificRecommendationLabel.font.withSize(15) //adjust font size
                zoneSpecificRecommendationLabel.textAlignment = .center
                zoneSpecificRecommendationLabel.numberOfLines = 2
                view.addSubview(zoneSpecificRecommendationLabel)
                //zoneSpecificRecommendationLabel.isHidden = true
                
                //testResultProgressBar
                self.testResultProgressBar.progressImage = UIImage(named: "testGradient")
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
        zoneSpecificRecommendationLabel.translatesAutoresizingMaskIntoConstraints = false
        zoneSpecificRecommendationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        zoneSpecificRecommendationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -(UIScreen.main.bounds.height * 0.1)).isActive = true
        zoneSpecificRecommendationLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        self.testResultProgressBar.translatesAutoresizingMaskIntoConstraints = false
        self.testResultProgressBar.setProgress(1, animated: true)
        self.testResultProgressBar.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.testResultProgressBar.topAnchor.constraint(equalTo: self.zoneSpecificRecommendationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        self.testResultProgressBar.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.75)).isActive = true
        self.testResultProgressBar.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        severeHypocalcemiaRecommendationBtn.translatesAutoresizingMaskIntoConstraints = false
        severeHypocalcemiaRecommendationBtn.topAnchor.constraint(equalTo: self.zoneSpecificRecommendationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        severeHypocalcemiaRecommendationBtn.leftAnchor.constraint(equalTo: self.testResultProgressBar.leftAnchor).isActive = true
        severeHypocalcemiaRecommendationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.2925)).isActive = true
        severeHypocalcemiaRecommendationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        subClinicalHypocalcemiaRecommendationBtn.translatesAutoresizingMaskIntoConstraints = false
        subClinicalHypocalcemiaRecommendationBtn.topAnchor.constraint(equalTo: self.zoneSpecificRecommendationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        subClinicalHypocalcemiaRecommendationBtn.leftAnchor.constraint(equalTo: self.severeHypocalcemiaRecommendationBtn.rightAnchor).isActive = true
        subClinicalHypocalcemiaRecommendationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.0975)).isActive = true
        subClinicalHypocalcemiaRecommendationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        normalCalcemiaRecommendationBtn.translatesAutoresizingMaskIntoConstraints = false
        normalCalcemiaRecommendationBtn.topAnchor.constraint(equalTo: self.zoneSpecificRecommendationLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        normalCalcemiaRecommendationBtn.leftAnchor.constraint(equalTo: self.subClinicalHypocalcemiaRecommendationBtn.rightAnchor).isActive = true
        normalCalcemiaRecommendationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.36)).isActive = true
        normalCalcemiaRecommendationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        
        recommendationBoxLeft.translatesAutoresizingMaskIntoConstraints = false
        recommendationBoxLeft.bottomAnchor.constraint(equalTo: self.severeHypocalcemiaRecommendationBtn.topAnchor).isActive = true
        recommendationBoxLeft.leftAnchor.constraint(equalTo: self.severeHypocalcemiaRecommendationBtn.leftAnchor, constant: -(UIScreen.main.bounds.width * 0.1)).isActive = true
        recommendationBoxLeft.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.55)).isActive = true
        recommendationBoxLeft.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        
        recommendationBoxMiddle.translatesAutoresizingMaskIntoConstraints = false
        recommendationBoxMiddle.bottomAnchor.constraint(equalTo: self.subClinicalHypocalcemiaRecommendationBtn.topAnchor).isActive = true
        recommendationBoxMiddle.centerXAnchor.constraint(equalTo: self.subClinicalHypocalcemiaRecommendationBtn.centerXAnchor).isActive = true
        recommendationBoxMiddle.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.55)).isActive = true
        recommendationBoxMiddle.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        
        recommendationBoxRight.translatesAutoresizingMaskIntoConstraints = false
        recommendationBoxRight.bottomAnchor.constraint(equalTo: self.normalCalcemiaRecommendationBtn.topAnchor).isActive = true
        recommendationBoxRight.rightAnchor.constraint(equalTo: self.normalCalcemiaRecommendationBtn.rightAnchor, constant: (UIScreen.main.bounds.width * 0.1)).isActive = true
        recommendationBoxRight.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.55)).isActive = true
        recommendationBoxRight.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        
    }
    
    private func setupBtnListeners(){
        severeHypocalcemiaRecommendationBtn.addTarget(self, action: #selector(severeHypocalcemiaRecommendationBtnListener), for: .touchUpInside)
        subClinicalHypocalcemiaRecommendationBtn.addTarget(self, action: #selector(subClinicalHypocalcemiaRecommendationBtnListener), for: .touchUpInside)
        normalCalcemiaRecommendationBtn.addTarget(self, action: #selector(normalCalcemiaRecommendationBtnListener), for: .touchUpInside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Milk Fever", message: "Recommendations are dependant on whether the cow is showing signs of milk fever or not. Would you like to view recommendations for a cow with or without signs of milk fever?", preferredStyle: .alert)

               alert.addAction(UIAlertAction(title: "With", style: .default, handler: {action in
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
               }))
               alert.addAction(UIAlertAction(title: "Without", style: .default, handler: { action in
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
               }))

               self.present(alert, animated: true)
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
    
    
}

