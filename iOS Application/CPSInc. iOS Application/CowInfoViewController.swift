//
//  CowInfoViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-27.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH DISPLAYING THE COW INFO WHEN COW SELECTED

import UIKit
import CoreData
import SwiftKeychainWrapper

class CowInfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    private let scanningIndicator = UIActivityIndicatorView()
    
    //scrolling
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var appDelegate: AppDelegate? = nil
    private var cowLogbookView: CowLogbookViewController? = nil
    private var selectedCow: Cow? = nil
    
    private let idLabel = UILabel()
    private let daysInMilkLabel = UILabel()
    private let dryOffDayLabel = UILabel()
    private let mastitisHistoryLabel = UILabel()
    private let methodOfDryOffLabel = UILabel()
    private let dailyMilkAverageLabel = UILabel()
    private let parityLabel = UILabel()
    private let reproductionStatusLabel = UILabel()
    private let numberOfTimesBredLabel = UILabel()
    private let farmBreedingIndexLabel = UILabel()
    
    private let lactationNumberLabel = UILabel()
    private let daysCarriedCalfIfPregnantLabel = UILabel()
    private let projectedDueDateLabel = UILabel()
    private let current305DayMilkLabel = UILabel()
    private let currentSomaticCellCountLabel = UILabel()
    private let linearScoreAtLastTestLabel = UILabel()
    private let dateOfLastClinialMastitisLabel = UILabel()
    private let chainVisibleIDLabel = UILabel()
    private let animalRegistrationNoNLIDLabel = UILabel()
    private let damBreedLabel = UILabel()
    private let culledLabel = UILabel()
    
    private let idTextView = UITextView()
    private let daysInMilkTextView = UITextView()
    private let dryOffDayTextView = UITextView()
    private let mastitisHistoryTextView = UITextView()
    private let methodOfDryOffTextView = UITextView()
    private let dailyMilkAverageTextView = UITextView()
    private let parityTextView = UITextView()
    private let reproductionStatusTextView = UITextView()
    private let numberOfTimesBredTextView = UITextView()
    private let farmBreedingIndexTextView = UITextView()
    
    private let lactationNumberTextView = UITextView()
    private let daysCarriedCalfIfPregnantTextView = UITextView()
    private let projectedDueDateTextView = UITextView()
    private let current305DayMilkTextView = UITextView()
    private let currentSomaticCellCountTextView = UITextView()
    private let linearScoreAtLastTestTextView = UITextView()
    private let dateOfLastClinialMastitisTextView = UITextView()
    private let chainVisibleIDTextView = UITextView()
    private let animalRegistrationNoNLIDTextView = UITextView()
    private let damBreedTextView = UITextView()
    private let culledTextView = UITextView()
    
    private let dryOffDayPicker = UIPickerView()
    private let dryOffDayPickerData = ["Lactating", "Drying Off", "Dry"]
    
    private let methodOfDryOffPicker = UIPickerView()
    private let methodOfDryOffPickerData = ["Yes", "No"]
    
    private let reproductionStatusPicker = UIPickerView()
    private let reproductionStatusPickerData = ["Pregnant", "Not Pregnant"]
    
    
    private let selectBtn = UIButton()
    private let saveBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cow Info"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupComponents()
        setLayoutConstraints()
    }
    
    private func setupComponents(){
        
        scrollView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.3)
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator)
        //scanningIndicator
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scanningIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        scanningIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true

        
        contentView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        contentView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        scrollView.addSubview(contentView)
        
        let bar = UIToolbar()
        bar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneKeyboardBtnPressed))
        bar.items = [flex, done]
        
        
        idLabel.text = "Cow ID:"
        contentView.addSubview(idLabel)
        
        daysInMilkLabel.text = "Cow Days in Milk:"
        contentView.addSubview(daysInMilkLabel)
        
        dryOffDayLabel.text = "Cow Estimated Days Until Dry Off:"
        contentView.addSubview(dryOffDayLabel)
        
        mastitisHistoryLabel.text = "Cow Mastitis History:"
        contentView.addSubview(mastitisHistoryLabel)
        
        methodOfDryOffLabel.text = "Cow Dry Off:"
        contentView.addSubview(methodOfDryOffLabel)
        
        dailyMilkAverageLabel.text = "Cow Daily Milk Avg:"
        contentView.addSubview(dailyMilkAverageLabel)
        
        parityLabel.text = "Cow Parity:"
        contentView.addSubview(parityLabel)
        
        reproductionStatusLabel.text = "Cow Reproduction Status:"
        contentView.addSubview(reproductionStatusLabel)
        
        numberOfTimesBredLabel.text = "Cow Number of Times Bred:"
        contentView.addSubview(numberOfTimesBredLabel)
        
        farmBreedingIndexLabel.text = "Farm Breeding Index:"
        contentView.addSubview(farmBreedingIndexLabel)
        
        lactationNumberLabel.text = "Lactation Number:"
        contentView.addSubview(lactationNumberLabel)
        
        daysCarriedCalfIfPregnantLabel.text = "Days Carried Calf if Pregnant:"
        contentView.addSubview(daysCarriedCalfIfPregnantLabel)
        
        projectedDueDateLabel.text = "Projected Due Date"
        contentView.addSubview(projectedDueDateLabel)
        
        current305DayMilkLabel.text = "Current 305 Day Milk:"
        contentView.addSubview(current305DayMilkLabel)
        
        currentSomaticCellCountLabel.text = "Current Somatic Cell Count:"
        contentView.addSubview(currentSomaticCellCountLabel)
        
        linearScoreAtLastTestLabel.text = "Linear Score at Last Test:"
        contentView.addSubview(linearScoreAtLastTestLabel)
        
        dateOfLastClinialMastitisLabel.text = "Date of Last Clinical Mastitis:"
        contentView.addSubview(dateOfLastClinialMastitisLabel)
        
        chainVisibleIDLabel.text = "Chain Visible ID Label:"
        contentView.addSubview(chainVisibleIDLabel)
        
        animalRegistrationNoNLIDLabel.text = "Animal Registration No NLID:"
        contentView.addSubview(animalRegistrationNoNLIDLabel)
        
        damBreedLabel.text = "Dam Breed:"
        contentView.addSubview(damBreedLabel)
        
        culledLabel.text = "Culled:"
        contentView.addSubview(culledLabel)
        
        
        idTextView.tag = 0
        idTextView.delegate = self
        idTextView.keyboardType = .numberPad
        idTextView.inputAccessoryView = bar
        contentView.addSubview(idTextView)
        
        daysInMilkTextView.tag = 1
        daysInMilkTextView.delegate = self
        daysInMilkTextView.keyboardType = .numberPad
        daysInMilkTextView.inputAccessoryView = bar
        contentView.addSubview(daysInMilkTextView)
        
        dryOffDayTextView.tag = 2
        dryOffDayTextView.delegate = self
        dryOffDayTextView.keyboardType = .numberPad
        dryOffDayTextView.inputAccessoryView = bar
        contentView.addSubview(dryOffDayTextView)
        
        mastitisHistoryTextView.tag = 3
        mastitisHistoryTextView.delegate = self
        mastitisHistoryTextView.keyboardType = .numberPad
        mastitisHistoryTextView.inputAccessoryView = bar
        //contentView.addSubview(mastitisHistoryTextView)
        
        methodOfDryOffTextView.tag = 4
        methodOfDryOffTextView.delegate = self
        methodOfDryOffTextView.keyboardType = .default
        methodOfDryOffTextView.inputAccessoryView = bar
        //contentView.addSubview(methodOfDryOffTextView)
        
        dailyMilkAverageTextView.tag = 5
        dailyMilkAverageTextView.delegate = self
        dailyMilkAverageTextView.keyboardType = .default
        dailyMilkAverageTextView.inputAccessoryView = bar
        //contentView.addSubview(dailyMilkAverageTextView)
        
        parityTextView.tag = 6
        parityTextView.delegate = self
        parityTextView.keyboardType = .numberPad
        parityTextView.inputAccessoryView = bar
        //contentView.addSubview(parityTextView)
        
        reproductionStatusTextView.tag = 7
        reproductionStatusTextView.delegate = self
        reproductionStatusTextView.keyboardType = .default
        reproductionStatusTextView.inputAccessoryView = bar
        //contentView.addSubview(reproductionStatusTextView)
        
        
        numberOfTimesBredTextView.tag = 8
        numberOfTimesBredTextView.delegate = self
        numberOfTimesBredTextView.keyboardType = .numberPad
        numberOfTimesBredTextView.inputAccessoryView = bar
        //contentView.addSubview(numberOfTimesBredTextView)
        
        farmBreedingIndexTextView.tag = 9
        farmBreedingIndexTextView.delegate = self
        farmBreedingIndexTextView.keyboardType = .numberPad
        farmBreedingIndexTextView.inputAccessoryView = bar
        //contentView.addSubview(farmBreedingIndexTextView)
        
        lactationNumberTextView.tag = 10
        lactationNumberTextView.delegate = self
        lactationNumberTextView.keyboardType = .numberPad
        lactationNumberTextView.inputAccessoryView = bar
        contentView.addSubview(lactationNumberTextView)
        
        daysCarriedCalfIfPregnantTextView.tag = 11
        daysCarriedCalfIfPregnantTextView.delegate = self
        daysCarriedCalfIfPregnantTextView.keyboardType = .numberPad
        daysCarriedCalfIfPregnantTextView.inputAccessoryView = bar
        contentView.addSubview(daysCarriedCalfIfPregnantTextView)
        
        projectedDueDateTextView.tag = 12
        projectedDueDateTextView.delegate = self
        projectedDueDateTextView.keyboardType = .default
        projectedDueDateTextView.inputAccessoryView = bar
        contentView.addSubview(projectedDueDateTextView)
        
        current305DayMilkTextView.tag = 13
        current305DayMilkTextView.delegate = self
        current305DayMilkTextView.keyboardType = .numberPad
        current305DayMilkTextView.inputAccessoryView = bar
        contentView.addSubview(current305DayMilkTextView)
        
        currentSomaticCellCountTextView.tag = 14
        currentSomaticCellCountTextView.delegate = self
        currentSomaticCellCountTextView.keyboardType = .numberPad
        currentSomaticCellCountTextView.inputAccessoryView = bar
        contentView.addSubview(currentSomaticCellCountTextView)
        
        linearScoreAtLastTestTextView.tag = 15
        linearScoreAtLastTestTextView.delegate = self
        linearScoreAtLastTestTextView.keyboardType = .numberPad
        linearScoreAtLastTestTextView.inputAccessoryView = bar
        contentView.addSubview(linearScoreAtLastTestTextView)
        
        dateOfLastClinialMastitisTextView.tag = 16
        dateOfLastClinialMastitisTextView.delegate = self
        dateOfLastClinialMastitisTextView.keyboardType = .default
        dateOfLastClinialMastitisTextView.inputAccessoryView = bar
        contentView.addSubview(dateOfLastClinialMastitisTextView)
        
        
        chainVisibleIDTextView.tag = 17
        chainVisibleIDTextView.delegate = self
        chainVisibleIDTextView.keyboardType = .numberPad
        chainVisibleIDTextView.inputAccessoryView = bar
        contentView.addSubview(chainVisibleIDTextView)
        
        animalRegistrationNoNLIDTextView.tag = 18
        animalRegistrationNoNLIDTextView.delegate = self
        animalRegistrationNoNLIDTextView.keyboardType = .numberPad
        animalRegistrationNoNLIDTextView.inputAccessoryView = bar
        contentView.addSubview(animalRegistrationNoNLIDTextView)
        
        damBreedTextView.tag = 19
        damBreedTextView.delegate = self
        damBreedTextView.keyboardType = .default
        damBreedTextView.inputAccessoryView = bar
        contentView.addSubview(damBreedTextView)
        
        culledTextView.tag = 20
        culledTextView.delegate = self
        culledTextView.keyboardType = .numberPad
        culledTextView.isEditable = false //READ ONLY
        culledTextView.inputAccessoryView = bar
        contentView.addSubview(culledTextView)
        
        dryOffDayPicker.tag = 0
        dryOffDayPicker.backgroundColor = .gray
        dryOffDayPicker.layer.borderColor = UIColor.black.cgColor
        dryOffDayPicker.layer.borderWidth = 1
        dryOffDayPicker.delegate = self
        dryOffDayPicker.dataSource = self
        dryOffDayPicker.selectRow(0, inComponent: 0, animated: true)
        dryOffDayPicker.isHidden = true //hide until needed
        dryOffDayPicker.isUserInteractionEnabled = false //disable until needed
        view.addSubview(dryOffDayPicker)
        
        
        methodOfDryOffPicker.tag = 1
        methodOfDryOffPicker.backgroundColor = .gray
        methodOfDryOffPicker.layer.borderColor = UIColor.black.cgColor
        methodOfDryOffPicker.layer.borderWidth = 1
        methodOfDryOffPicker.delegate = self
        methodOfDryOffPicker.dataSource = self
        methodOfDryOffPicker.selectRow(0, inComponent: 0, animated: true)
        methodOfDryOffPicker.isHidden = true //hide until needed
        methodOfDryOffPicker.isUserInteractionEnabled = false //disable until needed
        view.addSubview(methodOfDryOffPicker)
        
        
        reproductionStatusPicker.tag = 2
        reproductionStatusPicker.backgroundColor = .gray
        reproductionStatusPicker.layer.borderColor = UIColor.black.cgColor
        reproductionStatusPicker.layer.borderWidth = 1
        reproductionStatusPicker.delegate = self
        reproductionStatusPicker.dataSource = self
        reproductionStatusPicker.selectRow(0, inComponent: 0, animated: true)
        reproductionStatusPicker.isHidden = true //hide until needed
        reproductionStatusPicker.isUserInteractionEnabled = false //disable until needed
        view.addSubview(reproductionStatusPicker)
        
        
        
        
        selectBtn.setTitle("Select", for: .normal)
        selectBtn.setTitleColor(.white, for: .normal)
        selectBtn.backgroundColor = .gray
        selectBtn.layer.borderWidth = 1
        selectBtn.layer.borderColor = UIColor.black.cgColor
        selectBtn.addTarget(self, action: #selector(selectBtnPressed), for: .touchUpInside)
        selectBtn.isHidden = true
        selectBtn.isEnabled = false
        view.addSubview(selectBtn)
        
        saveBtn.setTitle("Save Edits", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.backgroundColor = .gray
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = UIColor.black.cgColor
        saveBtn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        saveBtn.isHidden = true
        contentView.addSubview(saveBtn)
        
    }
    
    private func setLayoutConstraints(){
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        idLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        idTextView.translatesAutoresizingMaskIntoConstraints = false
        idTextView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        idTextView.leftAnchor.constraint(equalTo: idLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        idTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        //idTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        idTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        daysInMilkLabel.translatesAutoresizingMaskIntoConstraints = false
        daysInMilkLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        daysInMilkLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        daysInMilkTextView.translatesAutoresizingMaskIntoConstraints = false
        daysInMilkTextView.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        daysInMilkTextView.leftAnchor.constraint(equalTo: daysInMilkLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        daysInMilkTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        daysInMilkTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        dryOffDayLabel.translatesAutoresizingMaskIntoConstraints = false
        dryOffDayLabel.topAnchor.constraint(equalTo: daysInMilkLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dryOffDayLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        dryOffDayTextView.translatesAutoresizingMaskIntoConstraints = false
        dryOffDayTextView.topAnchor.constraint(equalTo: daysInMilkLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dryOffDayTextView.leftAnchor.constraint(equalTo: dryOffDayLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        dryOffDayTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        dryOffDayTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
//        mastitisHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
//        mastitisHistoryLabel.topAnchor.constraint(equalTo: dryOffDayLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        mastitisHistoryLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//        mastitisHistoryTextView.translatesAutoresizingMaskIntoConstraints = false
//        mastitisHistoryTextView.topAnchor.constraint(equalTo: dryOffDayLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        mastitisHistoryTextView.leftAnchor.constraint(equalTo: mastitisHistoryLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        mastitisHistoryTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
//        mastitisHistoryTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//
//        methodOfDryOffLabel.translatesAutoresizingMaskIntoConstraints = false
//        methodOfDryOffLabel.topAnchor.constraint(equalTo: mastitisHistoryLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        methodOfDryOffLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//        methodOfDryOffTextView.translatesAutoresizingMaskIntoConstraints = false
//        methodOfDryOffTextView.topAnchor.constraint(equalTo: mastitisHistoryLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        methodOfDryOffTextView.leftAnchor.constraint(equalTo: methodOfDryOffLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        methodOfDryOffTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
//        methodOfDryOffTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        dailyMilkAverageLabel.translatesAutoresizingMaskIntoConstraints = false
//        dailyMilkAverageLabel.topAnchor.constraint(equalTo: methodOfDryOffLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        dailyMilkAverageLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//        dailyMilkAverageTextView.translatesAutoresizingMaskIntoConstraints = false
//        dailyMilkAverageTextView.topAnchor.constraint(equalTo: methodOfDryOffLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        dailyMilkAverageTextView.leftAnchor.constraint(equalTo: dailyMilkAverageLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        dailyMilkAverageTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
//        dailyMilkAverageTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        parityLabel.translatesAutoresizingMaskIntoConstraints = false
//        parityLabel.topAnchor.constraint(equalTo: dailyMilkAverageLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        parityLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//        parityTextView.translatesAutoresizingMaskIntoConstraints = false
//        parityTextView.topAnchor.constraint(equalTo: dailyMilkAverageLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        parityTextView.leftAnchor.constraint(equalTo: parityLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        parityTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
//        parityTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        reproductionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
//        reproductionStatusLabel.topAnchor.constraint(equalTo: parityLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        reproductionStatusLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//        reproductionStatusTextView.translatesAutoresizingMaskIntoConstraints = false
//        reproductionStatusTextView.topAnchor.constraint(equalTo: parityLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        reproductionStatusTextView.leftAnchor.constraint(equalTo: reproductionStatusLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        reproductionStatusTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
//        reproductionStatusTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//
//
//        numberOfTimesBredLabel.translatesAutoresizingMaskIntoConstraints = false
//        numberOfTimesBredLabel.topAnchor.constraint(equalTo: reproductionStatusLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        numberOfTimesBredLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//
//        numberOfTimesBredTextView.translatesAutoresizingMaskIntoConstraints = false
//        numberOfTimesBredTextView.topAnchor.constraint(equalTo: reproductionStatusLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        numberOfTimesBredTextView.leftAnchor.constraint(equalTo: numberOfTimesBredLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        numberOfTimesBredTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
//        numberOfTimesBredTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//
//        farmBreedingIndexLabel.translatesAutoresizingMaskIntoConstraints = false
//        farmBreedingIndexLabel.topAnchor.constraint(equalTo: numberOfTimesBredLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        farmBreedingIndexLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//
//        farmBreedingIndexTextView.translatesAutoresizingMaskIntoConstraints = false
//        farmBreedingIndexTextView.topAnchor.constraint(equalTo: numberOfTimesBredLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//        farmBreedingIndexTextView.leftAnchor.constraint(equalTo: farmBreedingIndexLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
//        farmBreedingIndexTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
//        farmBreedingIndexTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        lactationNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        lactationNumberLabel.topAnchor.constraint(equalTo: dryOffDayLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        lactationNumberLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        lactationNumberTextView.translatesAutoresizingMaskIntoConstraints = false
        lactationNumberTextView.topAnchor.constraint(equalTo: dryOffDayLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        lactationNumberTextView.leftAnchor.constraint(equalTo: lactationNumberLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        lactationNumberTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        lactationNumberTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        daysCarriedCalfIfPregnantLabel.translatesAutoresizingMaskIntoConstraints = false
        daysCarriedCalfIfPregnantLabel.topAnchor.constraint(equalTo: lactationNumberLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        daysCarriedCalfIfPregnantLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        daysCarriedCalfIfPregnantTextView.translatesAutoresizingMaskIntoConstraints = false
        daysCarriedCalfIfPregnantTextView.topAnchor.constraint(equalTo: lactationNumberLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        daysCarriedCalfIfPregnantTextView.leftAnchor.constraint(equalTo: daysCarriedCalfIfPregnantLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        daysCarriedCalfIfPregnantTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        daysCarriedCalfIfPregnantTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        projectedDueDateLabel.translatesAutoresizingMaskIntoConstraints = false
        projectedDueDateLabel.topAnchor.constraint(equalTo: daysCarriedCalfIfPregnantLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        projectedDueDateLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        projectedDueDateTextView.translatesAutoresizingMaskIntoConstraints = false
        projectedDueDateTextView.topAnchor.constraint(equalTo: daysCarriedCalfIfPregnantLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        projectedDueDateTextView.leftAnchor.constraint(equalTo: projectedDueDateLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        projectedDueDateTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        projectedDueDateTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        current305DayMilkLabel.translatesAutoresizingMaskIntoConstraints = false
        current305DayMilkLabel.topAnchor.constraint(equalTo: projectedDueDateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        current305DayMilkLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        current305DayMilkTextView.translatesAutoresizingMaskIntoConstraints = false
        current305DayMilkTextView.topAnchor.constraint(equalTo: projectedDueDateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        current305DayMilkTextView.leftAnchor.constraint(equalTo: current305DayMilkLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        current305DayMilkTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        current305DayMilkTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        
        currentSomaticCellCountLabel.translatesAutoresizingMaskIntoConstraints = false
        currentSomaticCellCountLabel.topAnchor.constraint(equalTo: current305DayMilkLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        currentSomaticCellCountLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        currentSomaticCellCountTextView.translatesAutoresizingMaskIntoConstraints = false
        currentSomaticCellCountTextView.topAnchor.constraint(equalTo: current305DayMilkLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        currentSomaticCellCountTextView.leftAnchor.constraint(equalTo: currentSomaticCellCountLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        currentSomaticCellCountTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        currentSomaticCellCountTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        
        
        linearScoreAtLastTestLabel.translatesAutoresizingMaskIntoConstraints = false
        linearScoreAtLastTestLabel.topAnchor.constraint(equalTo: currentSomaticCellCountLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        linearScoreAtLastTestLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        linearScoreAtLastTestTextView.translatesAutoresizingMaskIntoConstraints = false
        linearScoreAtLastTestTextView.topAnchor.constraint(equalTo: currentSomaticCellCountLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        linearScoreAtLastTestTextView.leftAnchor.constraint(equalTo: linearScoreAtLastTestLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        linearScoreAtLastTestTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        linearScoreAtLastTestTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        
        dateOfLastClinialMastitisLabel.translatesAutoresizingMaskIntoConstraints = false
        dateOfLastClinialMastitisLabel.topAnchor.constraint(equalTo: linearScoreAtLastTestLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dateOfLastClinialMastitisLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        dateOfLastClinialMastitisTextView.translatesAutoresizingMaskIntoConstraints = false
        dateOfLastClinialMastitisTextView.topAnchor.constraint(equalTo: linearScoreAtLastTestLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dateOfLastClinialMastitisTextView.leftAnchor.constraint(equalTo: dateOfLastClinialMastitisLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        dateOfLastClinialMastitisTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        dateOfLastClinialMastitisTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        chainVisibleIDLabel.translatesAutoresizingMaskIntoConstraints = false
        chainVisibleIDLabel.topAnchor.constraint(equalTo: dateOfLastClinialMastitisLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        chainVisibleIDLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        chainVisibleIDTextView.translatesAutoresizingMaskIntoConstraints = false
        chainVisibleIDTextView.topAnchor.constraint(equalTo: dateOfLastClinialMastitisLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        chainVisibleIDTextView.leftAnchor.constraint(equalTo: chainVisibleIDLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        chainVisibleIDTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        chainVisibleIDTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        animalRegistrationNoNLIDLabel.translatesAutoresizingMaskIntoConstraints = false
        animalRegistrationNoNLIDLabel.topAnchor.constraint(equalTo: chainVisibleIDLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        animalRegistrationNoNLIDLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        animalRegistrationNoNLIDTextView.translatesAutoresizingMaskIntoConstraints = false
        animalRegistrationNoNLIDTextView.topAnchor.constraint(equalTo: chainVisibleIDLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        animalRegistrationNoNLIDTextView.leftAnchor.constraint(equalTo: animalRegistrationNoNLIDLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        animalRegistrationNoNLIDTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        animalRegistrationNoNLIDTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        damBreedLabel.translatesAutoresizingMaskIntoConstraints = false
        damBreedLabel.topAnchor.constraint(equalTo: animalRegistrationNoNLIDLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        damBreedLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        damBreedTextView.translatesAutoresizingMaskIntoConstraints = false
        damBreedTextView.topAnchor.constraint(equalTo: animalRegistrationNoNLIDLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        damBreedTextView.leftAnchor.constraint(equalTo: damBreedLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        damBreedTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        damBreedTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        culledLabel.translatesAutoresizingMaskIntoConstraints = false
        culledLabel.topAnchor.constraint(equalTo: damBreedLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        culledLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        culledTextView.translatesAutoresizingMaskIntoConstraints = false
        culledTextView.topAnchor.constraint(equalTo: damBreedLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        culledTextView.leftAnchor.constraint(equalTo: culledLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        culledTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.025)).isActive = true
        culledTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        selectBtn.translatesAutoresizingMaskIntoConstraints = false
        //selectBtn.topAnchor.constraint(equalTo: dryOffDayPicker.bottomAnchor).isActive = true
        selectBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.05)).isActive = true
        selectBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        selectBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        selectBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        
        dryOffDayPicker.translatesAutoresizingMaskIntoConstraints = false
        dryOffDayPicker.bottomAnchor.constraint(equalTo: selectBtn.topAnchor).isActive = true
        dryOffDayPicker.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        dryOffDayPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        dryOffDayPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        methodOfDryOffPicker.translatesAutoresizingMaskIntoConstraints = false
        methodOfDryOffPicker.bottomAnchor.constraint(equalTo: selectBtn.topAnchor).isActive = true
        methodOfDryOffPicker.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        methodOfDryOffPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        methodOfDryOffPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        
        reproductionStatusPicker.translatesAutoresizingMaskIntoConstraints = false
        reproductionStatusPicker.bottomAnchor.constraint(equalTo: selectBtn.topAnchor).isActive = true
        reproductionStatusPicker.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        reproductionStatusPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        reproductionStatusPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        //saveBtn.topAnchor.constraint(equalTo: milkingSystemPicker.bottomAnchor).isActive = true
        saveBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        saveBtn.topAnchor.constraint(equalTo: culledTextView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        //saveBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        saveBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        idTextView.text = selectedCow?.id
        daysInMilkTextView.text = selectedCow?.daysInMilk
        dryOffDayTextView.text = selectedCow?.dryOffDay
        mastitisHistoryTextView.text = selectedCow?.mastitisHistory
        methodOfDryOffTextView.text = selectedCow?.methodOfDryOff
        dailyMilkAverageTextView.text = selectedCow?.dailyMilkAverage
        parityTextView.text = selectedCow?.parity
        reproductionStatusTextView.text = selectedCow?.reproductionStatus
        numberOfTimesBredTextView.text = selectedCow?.numberTimesBred
        farmBreedingIndexTextView.text = selectedCow?.farmBreedingIndex
        lactationNumberTextView.text = selectedCow?.lactationNumber
        daysCarriedCalfIfPregnantTextView.text = selectedCow?.daysCarriedCalfIfPregnant
        projectedDueDateTextView.text = selectedCow?.projectedDueDate
        current305DayMilkTextView.text = selectedCow?.current305DayMilk
        currentSomaticCellCountTextView.text = selectedCow?.currentSomaticCellCount
        linearScoreAtLastTestTextView.text = selectedCow?.linearScoreAtLastTest
        dateOfLastClinialMastitisTextView.text = selectedCow?.dateOfLastClinicalMastitis
        chainVisibleIDTextView.text = selectedCow?.chainVisibleID
        animalRegistrationNoNLIDTextView.text = selectedCow?.animalRegistrationNoNLID
        damBreedTextView.text = selectedCow?.damBreed
        culledTextView.text = selectedCow?.culled
    }
    
    public convenience init(appDelegate: AppDelegate?, cowLogbook: CowLogbookViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.appDelegate = appDelegate
        self.cowLogbookView = cowLogbook
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        saveBtn.isHidden = true
        
//        if(textView.tag == 2){
//            textView.endEditing(true)
//            
//            saveBtn.isHidden = true
//            
//            textView.text = dryOffDayPickerData[0]
//            
//            methodOfDryOffPicker.isHidden = true
//            methodOfDryOffPicker.isUserInteractionEnabled = false
//            
//            reproductionStatusPicker.isHidden = true
//            reproductionStatusPicker.isUserInteractionEnabled = false
//            
//            dryOffDayPicker.isHidden = false
//            dryOffDayPicker.isUserInteractionEnabled = true
//            
//            selectBtn.isHidden = false
//            selectBtn.isEnabled = true
//        }
        if(textView.tag == 4){
            textView.endEditing(true)
            
            saveBtn.isHidden = true
            
            textView.text = methodOfDryOffPickerData[0]
            
            dryOffDayPicker.isHidden = true
            dryOffDayPicker.isUserInteractionEnabled = false
            
            reproductionStatusPicker.isHidden = true
            reproductionStatusPicker.isUserInteractionEnabled = false
            
            methodOfDryOffPicker.isHidden = false
            methodOfDryOffPicker.isUserInteractionEnabled = true
            
            selectBtn.isHidden = false
            selectBtn.isEnabled = true
        }
        else if(textView.tag == 7){
            textView.endEditing(true)
            
            saveBtn.isHidden = true
            
            textView.text = reproductionStatusPickerData[0]
            
            dryOffDayPicker.isHidden = true
            dryOffDayPicker.isUserInteractionEnabled = false
            
            methodOfDryOffPicker.isHidden = true
            methodOfDryOffPicker.isUserInteractionEnabled = false
            
            reproductionStatusPicker.isHidden = false
            reproductionStatusPicker.isUserInteractionEnabled = true
            
            selectBtn.isHidden = false
            selectBtn.isEnabled = true
        }
        else{
            dryOffDayPicker.isHidden = true
            dryOffDayPicker.isUserInteractionEnabled = false
            
            methodOfDryOffPicker.isHidden = true
            methodOfDryOffPicker.isUserInteractionEnabled = false
            
            reproductionStatusPicker.isHidden = true
            reproductionStatusPicker.isUserInteractionEnabled = false
            
            selectBtn.isHidden = true
            selectBtn.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveBtn.isHidden = false
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
        
        dryOffDayPicker.isHidden = true
        dryOffDayPicker.isUserInteractionEnabled = false
        
        methodOfDryOffPicker.isHidden = true
        methodOfDryOffPicker.isUserInteractionEnabled = false
        
        reproductionStatusPicker.isHidden = true
        reproductionStatusPicker.isUserInteractionEnabled = false
        
        selectBtn.isHidden = true
        selectBtn.isEnabled = false
        saveBtn.isHidden = false
    }
    
    
    @objc private func saveBtnPressed(){
        
        saveBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.saveBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        DispatchQueue.main.async {
            self.scanningIndicator.startAnimating()
        }
        
        //Build HTTP Request
        var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/cow-update")!) //sync route on the server
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
        request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
        
        //build JSON Body
        var jsonCowObject = [String: Any]()
        
        
        let cow = Cow(context: (appDelegate?.persistentContainer.viewContext)!)
        cow.daysInMilk = daysInMilkTextView.text
        cow.dryOffDay = dryOffDayTextView.text
        cow.id = idTextView.text
        cow.mastitisHistory = mastitisHistoryTextView.text
        cow.methodOfDryOff = methodOfDryOffTextView.text
        cow.dailyMilkAverage = dailyMilkAverageTextView.text
        cow.parity = parityTextView.text
        cow.reproductionStatus = reproductionStatusTextView.text
        cow.numberTimesBred = numberOfTimesBredTextView.text
        cow.farmBreedingIndex = farmBreedingIndexTextView.text
        cow.herd = cowLogbookView?.getSelectedHerd()
        cow.lactationNumber = lactationNumberTextView.text
        cow.daysCarriedCalfIfPregnant = daysCarriedCalfIfPregnantTextView.text
        cow.projectedDueDate = projectedDueDateTextView.text
        cow.current305DayMilk = current305DayMilkTextView.text
        cow.currentSomaticCellCount = currentSomaticCellCountTextView.text
        cow.linearScoreAtLastTest = linearScoreAtLastTestTextView.text
        cow.dateOfLastClinicalMastitis = dateOfLastClinialMastitisTextView.text
        cow.chainVisibleID = chainVisibleIDTextView.text
        cow.animalRegistrationNoNLID = animalRegistrationNoNLIDTextView.text
        cow.damBreed = damBreedTextView.text
        cow.culled = culledTextView.text
            
        jsonCowObject = [
            "objectType": "Cow" as Any,
            "herdID": cow.herd?.id as Any,
            "id": cow.id as Any,
            "daysInMilk": cow.daysInMilk as Any,
            "dryOffDay": cow.dryOffDay as Any,
            "mastitisHistory": cow.mastitisHistory as Any,
            "methodOfDryOff": cow.methodOfDryOff as Any,
            "dailyMilkAverage": cow.dailyMilkAverage as Any,
            "parity": cow.parity as Any,
            "reproductionStatus": cow.reproductionStatus as Any,
            "numberOfTimesBred": cow.numberTimesBred as Any,
            "farmBreedingIndex": cow.farmBreedingIndex as Any,
            "lactationNumber": cow.lactationNumber as Any,
            "daysCarriedCalfIfPregnant": cow.daysCarriedCalfIfPregnant as Any,
            "projectedDueDate": cow.projectedDueDate as Any,
            "current305DayMilk": cow.current305DayMilk as Any,
            "currentSomaticCellCount": cow.currentSomaticCellCount as Any,
            "linearScoreAtLastTest": cow.linearScoreAtLastTest as Any,
            "dateOfLastClinicalMastitis": cow.dateOfLastClinicalMastitis as Any,
            "chainVisibleId": cow.chainVisibleID as Any,
            "animalRegistrationNoNLID": cow.animalRegistrationNoNLID as Any,
            "damBreed": cow.damBreed as Any,
            "culled": cow.culled as Any,
            "userID": KeychainWrapper.standard.string(forKey: "User-ID-Token") as Any
        ]
        
        
        var syncJsonData: Data? = nil
        
        if(JSONSerialization.isValidJSONObject(jsonCowObject)){
            do{
                syncJsonData = try JSONSerialization.data(withJSONObject: jsonCowObject, options: [])
            }catch{
                print("Problem while serializing jsonHerdObject")
            }
        }

        request.httpBody = syncJsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                print("Error occured during /cow RESTAPI request")
                
            }
            else{
                print("Response:")
                print(response!)
                print("Data:")
                print(String(decoding: data!, as: UTF8.self))
        
        
                    if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
                        //TODO send them to login again
                        print("invalid token")
                        DispatchQueue.main.async {
                            self.showToast(controller: self, message: "Must login to add a cow to your logbook", seconds: 2)
                            self.scanningIndicator.stopAnimating()
                        }
                        
                        
                        return
                    }
        
        
                    if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
                        DispatchQueue.main.async {
                            self.showToast(controller: self, message: "Network Error", seconds: 1)
                        }
                    
                        DispatchQueue.main.async{
                            self.scanningIndicator.stopAnimating()
                        }
                        
                        return //return from function - end sync
                    }
                    else{
                        DispatchQueue.main.async {
                            self.showToast(controller: self, message: "Cow results have been saved", seconds: 3)
                            
                            self.scanningIndicator.stopAnimating()
                            
                            DispatchQueue.main.async {
                                self.saveBtn.isHidden = true;
                            }
                            
                            self.navigationController?.popViewController(animated: true)
                            
                            return //return from function - end sync
                        }
                    }
                }
        
            }
        
            task.resume()
    }
    
    
    @objc private func doneKeyboardBtnPressed(){
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //fill out
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //fill out
        if(pickerView.tag == 0){
            return dryOffDayPickerData.count
        }
        else if(pickerView.tag == 1){
            return methodOfDryOffPickerData.count
        }
        else{
            return reproductionStatusPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            return dryOffDayPickerData[row]
        }
        else if(pickerView.tag == 1){
            return methodOfDryOffPickerData[row]
        }
        else{
            return reproductionStatusPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0){
            dryOffDayTextView.text = dryOffDayPickerData[row]
        }
        else if(pickerView.tag == 1){
            methodOfDryOffTextView.text = methodOfDryOffPickerData[row]
        }
        else{
            reproductionStatusTextView.text = reproductionStatusPickerData[row]
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
    
    
    
    //getters/setter
    public func setSelectedCow(cow: Cow){
        self.selectedCow = cow
    }
}
