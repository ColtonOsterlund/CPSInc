//
//  AddCowViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-27.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import CoreData

class AddCowViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    private var appDelegate: AppDelegate? = nil
    private var cowLogbookView: CowLogbookViewController? = nil
    
    private let idLabel = UILabel()
    private let daysInMilkLabel = UILabel()
    private let dryOffDayLabel = UILabel()
    private let mastitisHistoryLabel = UILabel()
    private let methodOfDryOffLabel = UILabel()
    private let nameLabel = UILabel()
    private let parityLabel = UILabel()
    private let reproductionStatusLabel = UILabel()
    
    private let idTextView = UITextView()
    private let daysInMilkTextView = UITextView()
    private let dryOffDayTextView = UITextView()
    private let mastitisHistoryTextView = UITextView()
    private let methodOfDryOffTextView = UITextView()
    private let nameTextView = UITextView()
    private let parityTextView = UITextView()
    private let reproductionStatusTextView = UITextView()
    
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

        self.title = "Add Cow"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupComponents()
        setLayoutConstraints()
    }
    
    private func setupComponents(){
        
        let bar = UIToolbar()
        bar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneKeyboardBtnPressed))
        bar.items = [flex, done]
        
        
        idLabel.text = "Cow ID:"
        view.addSubview(idLabel)
        
        daysInMilkLabel.text = "Cow Days in Milk:"
        view.addSubview(daysInMilkLabel)
        
        dryOffDayLabel.text = "Cow Dry Off Day:"
        view.addSubview(dryOffDayLabel)
        
        mastitisHistoryLabel.text = "Cow Mastitis History:"
        view.addSubview(mastitisHistoryLabel)
        
        methodOfDryOffLabel.text = "Cow Dry Off:"
        view.addSubview(methodOfDryOffLabel)
        
        nameLabel.text = "Cow Name:"
        view.addSubview(nameLabel)
        
        parityLabel.text = "Cow Parity:"
        view.addSubview(parityLabel)
        
        reproductionStatusLabel.text = "Cow Reproduction Status:"
        view.addSubview(reproductionStatusLabel)
        
        idTextView.tag = 0
        idTextView.delegate = self
        idTextView.keyboardType = .numberPad
        idTextView.inputAccessoryView = bar
        view.addSubview(idTextView)
        
        daysInMilkTextView.tag = 1
        daysInMilkTextView.delegate = self
        daysInMilkTextView.keyboardType = .numberPad
        daysInMilkTextView.inputAccessoryView = bar
        view.addSubview(daysInMilkTextView)
        
        dryOffDayTextView.tag = 2
        dryOffDayTextView.delegate = self
        dryOffDayTextView.keyboardType = .default
        dryOffDayTextView.inputAccessoryView = bar
        view.addSubview(dryOffDayTextView)
        
        mastitisHistoryTextView.tag = 3
        mastitisHistoryTextView.delegate = self
        mastitisHistoryTextView.keyboardType = .numberPad
        mastitisHistoryTextView.inputAccessoryView = bar
        view.addSubview(mastitisHistoryTextView)
        
        methodOfDryOffTextView.tag = 4
        methodOfDryOffTextView.delegate = self
        methodOfDryOffTextView.keyboardType = .default
        methodOfDryOffTextView.inputAccessoryView = bar
        view.addSubview(methodOfDryOffTextView)
        
        nameTextView.tag = 5
        nameTextView.delegate = self
        nameTextView.keyboardType = .default
        nameTextView.inputAccessoryView = bar
        view.addSubview(nameTextView)
        
        parityTextView.tag = 6
        parityTextView.delegate = self
        parityTextView.keyboardType = .numberPad
        parityTextView.inputAccessoryView = bar
        view.addSubview(parityTextView)
        
        reproductionStatusTextView.tag = 7
        reproductionStatusTextView.delegate = self
        reproductionStatusTextView.keyboardType = .default
        reproductionStatusTextView.inputAccessoryView = bar
        view.addSubview(reproductionStatusTextView)
        
        
        
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
        
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.backgroundColor = .gray
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = UIColor.black.cgColor
        saveBtn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        view.addSubview(saveBtn)
        
    }
    
    private func setLayoutConstraints(){
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        idLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        idTextView.translatesAutoresizingMaskIntoConstraints = false
        idTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        idTextView.leftAnchor.constraint(equalTo: idLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        idTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        idTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        daysInMilkLabel.translatesAutoresizingMaskIntoConstraints = false
        daysInMilkLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        daysInMilkLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        daysInMilkTextView.translatesAutoresizingMaskIntoConstraints = false
        daysInMilkTextView.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        daysInMilkTextView.leftAnchor.constraint(equalTo: daysInMilkLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        daysInMilkTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        daysInMilkTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        dryOffDayLabel.translatesAutoresizingMaskIntoConstraints = false
        dryOffDayLabel.topAnchor.constraint(equalTo: daysInMilkLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dryOffDayLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        dryOffDayTextView.translatesAutoresizingMaskIntoConstraints = false
        dryOffDayTextView.topAnchor.constraint(equalTo: daysInMilkLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dryOffDayTextView.leftAnchor.constraint(equalTo: dryOffDayLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        dryOffDayTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dryOffDayTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        mastitisHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
        mastitisHistoryLabel.topAnchor.constraint(equalTo: dryOffDayLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        mastitisHistoryLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        mastitisHistoryTextView.translatesAutoresizingMaskIntoConstraints = false
        mastitisHistoryTextView.topAnchor.constraint(equalTo: dryOffDayLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        mastitisHistoryTextView.leftAnchor.constraint(equalTo: mastitisHistoryLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        mastitisHistoryTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        mastitisHistoryTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        methodOfDryOffLabel.translatesAutoresizingMaskIntoConstraints = false
        methodOfDryOffLabel.topAnchor.constraint(equalTo: mastitisHistoryLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        methodOfDryOffLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        methodOfDryOffTextView.translatesAutoresizingMaskIntoConstraints = false
        methodOfDryOffTextView.topAnchor.constraint(equalTo: mastitisHistoryLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        methodOfDryOffTextView.leftAnchor.constraint(equalTo: methodOfDryOffLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        methodOfDryOffTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        methodOfDryOffTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: methodOfDryOffLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.topAnchor.constraint(equalTo: methodOfDryOffLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        nameTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        parityLabel.translatesAutoresizingMaskIntoConstraints = false
        parityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        parityLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        parityTextView.translatesAutoresizingMaskIntoConstraints = false
        parityTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        parityTextView.leftAnchor.constraint(equalTo: parityLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        parityTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        parityTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        reproductionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        reproductionStatusLabel.topAnchor.constraint(equalTo: parityLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        reproductionStatusLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
    
        reproductionStatusTextView.translatesAutoresizingMaskIntoConstraints = false
        reproductionStatusTextView.topAnchor.constraint(equalTo: parityLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        reproductionStatusTextView.leftAnchor.constraint(equalTo: reproductionStatusLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        reproductionStatusTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reproductionStatusTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        dryOffDayPicker.translatesAutoresizingMaskIntoConstraints = false
        dryOffDayPicker.topAnchor.constraint(equalTo: reproductionStatusLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dryOffDayPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        dryOffDayPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        dryOffDayPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        methodOfDryOffPicker.translatesAutoresizingMaskIntoConstraints = false
        methodOfDryOffPicker.topAnchor.constraint(equalTo: reproductionStatusLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        methodOfDryOffPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        methodOfDryOffPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        methodOfDryOffPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        reproductionStatusPicker.translatesAutoresizingMaskIntoConstraints = false
        reproductionStatusPicker.topAnchor.constraint(equalTo: reproductionStatusLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        reproductionStatusPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        reproductionStatusPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        reproductionStatusPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        
        selectBtn.translatesAutoresizingMaskIntoConstraints = false
        selectBtn.topAnchor.constraint(equalTo: dryOffDayPicker.bottomAnchor).isActive = true
        //selectBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        selectBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        selectBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        selectBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        //saveBtn.topAnchor.constraint(equalTo: milkingSystemPicker.bottomAnchor).isActive = true
        saveBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        saveBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.05)).isActive = true
        //saveBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        saveBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            self.idTextView.text = ""
//            self.daysInMilkTextView.text = ""
//            self.dryOffDayTextView.text = ""
//            self.mastitisHistoryTextView.text = ""
//            self.methodOfDryOffTextView.text = ""
//            self.nameTextView.text = ""
//            self.parityTextView.text = ""
//            self.reproductionStatusTextView.text = ""
//        }
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
        
        if(textView.tag == 2){
            textView.endEditing(true)
            
            saveBtn.isHidden = true
            
            textView.text = dryOffDayPickerData[0]
            
            methodOfDryOffPicker.isHidden = true
            methodOfDryOffPicker.isUserInteractionEnabled = false
            
            reproductionStatusPicker.isHidden = true
            reproductionStatusPicker.isUserInteractionEnabled = false
            
            dryOffDayPicker.isHidden = false
            dryOffDayPicker.isUserInteractionEnabled = true
            
            selectBtn.isHidden = false
            selectBtn.isEnabled = true
        }
        else if(textView.tag == 4){
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
        
        
        let fetchRequestCheckID: NSFetchRequest<Cow> = Cow.fetchRequest()
        let idToCheck = idTextView.text
        let herdOfCow = cowLogbookView!.getSelectedHerd()
        
        let idPredicate = NSPredicate(format: "id == %@", idToCheck!)
        let herdPredicate = NSPredicate(format: "herd == %@", herdOfCow) //must be in the same herd - cows of different herds can have the same id
        
        fetchRequestCheckID.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, herdPredicate])
        
        var savedCowArray: [Cow]? = nil
        savedCowArray?.removeAll(keepingCapacity: false)
        do{
            savedCowArray = try appDelegate?.persistentContainer.viewContext.fetch(fetchRequestCheckID)
            
        } catch{
            print("Error during fetch request")
        }
        
        if(savedCowArray!.isEmpty == false){
            showToast(controller: self, message: "Cow Already Exists with that ID", seconds: 1)
        }
        else{
            
            let cow = Cow(context: (appDelegate?.persistentContainer.viewContext)!)
            cow.daysInMilk = daysInMilkTextView.text
            cow.dryOffDay = dryOffDayTextView.text
            cow.id = idTextView.text
            cow.mastitisHistory = mastitisHistoryTextView.text
            cow.methodOfDryOff = methodOfDryOffTextView.text
            cow.name = nameTextView.text
            cow.parity = parityTextView.text
            cow.reproductionStatus = reproductionStatusTextView.text
            cow.herd = cowLogbookView?.getSelectedHerd()
            
            cowLogbookView!.addToCowList(cowToAppend: cow)
            
            appDelegate?.saveContext()
            
        }
        
        
        DispatchQueue.main.async {
            self.idTextView.text = ""
            self.daysInMilkTextView.text = ""
            self.dryOffDayTextView.text = ""
            self.mastitisHistoryTextView.text = ""
            self.methodOfDryOffTextView.text = ""
            self.nameTextView.text = ""
            self.parityTextView.text = ""
            self.reproductionStatusTextView.text = ""
        }
        
        navigationController?.popViewController(animated: true)
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


}
