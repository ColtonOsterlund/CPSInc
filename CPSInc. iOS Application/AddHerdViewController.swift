//
//  AddHerdViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-27.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import CoreData

class AddHerdViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    private var appDelegate: AppDelegate? = nil
    private var herdLogbookView: HerdLogbookViewController? = nil
    
    private let idLabel = UILabel()
    private let locationLabel = UILabel()
    private let milkingSystemLabel = UILabel()
    private let pinLabel = UILabel()
    
    private let idTextView = UITextView()
    private let locationTextView = UITextView()
    private let milkingSystemTextView = UITextView()
    private let pinTextView = UITextView()
    
    private let milkingSystemPicker = UIPickerView()
    private let milkingSystemPickerData = ["Tie Stall Herd", "Milking Parlour", "Robotic Milking System"]
    
    private let selectBtn = UIButton()
    private let saveBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Herd"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupLayoutComponents()
        setupLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            self.idTextView.text = ""
//            self.locationTextView.text = ""
//            self.milkingSystemTextView.text = ""
//            self.pinTextView.text = ""
//        }
    }
    
    private func setupLayoutComponents(){
        
        idLabel.text = "Herd ID:"
        view.addSubview(idLabel)
        
        locationLabel.text = "Herd Location:"
        view.addSubview(locationLabel)
        
        milkingSystemLabel.text = "Milking System:"
        view.addSubview(milkingSystemLabel)
        
        pinLabel.text = "Herd PIN:"
        view.addSubview(pinLabel)
        
        
        let bar = UIToolbar()
        bar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneKeyboardBtnPressed))
        bar.items = [flex, done]
        
        
        idTextView.tag = 0
        idTextView.delegate = self
        idTextView.keyboardType = .numberPad
        idTextView.inputAccessoryView = bar
        view.addSubview(idTextView)
        
        locationTextView.tag = 1
        locationTextView.delegate = self
        locationTextView.keyboardType = .default
        locationTextView.inputAccessoryView = bar
        view.addSubview(locationTextView)
        
        milkingSystemTextView.tag = 2
        milkingSystemTextView.delegate = self
        view.addSubview(milkingSystemTextView)
        
        pinTextView.tag = 3
        pinTextView.delegate = self
        pinTextView.keyboardType = .numberPad
        pinTextView.inputAccessoryView = bar
        view.addSubview(pinTextView)
        
        milkingSystemPicker.backgroundColor = .gray
        milkingSystemPicker.layer.borderColor = UIColor.black.cgColor
        milkingSystemPicker.layer.borderWidth = 1
        milkingSystemPicker.delegate = self
        milkingSystemPicker.dataSource = self
        milkingSystemPicker.selectRow(0, inComponent: 0, animated: true)
        milkingSystemPicker.isHidden = true //hide until needed
        milkingSystemPicker.isUserInteractionEnabled = false //disable until needed
        view.addSubview(milkingSystemPicker)
        
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
    
    
    private func setupLayoutConstraints(){
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        idLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        
        idTextView.translatesAutoresizingMaskIntoConstraints = false
        idTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        idTextView.leftAnchor.constraint(equalTo: idLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        idTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        idTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        
        locationTextView.translatesAutoresizingMaskIntoConstraints = false
        locationTextView.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        locationTextView.leftAnchor.constraint(equalTo: locationLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        locationTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        locationTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        milkingSystemLabel.translatesAutoresizingMaskIntoConstraints = false
        milkingSystemLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        milkingSystemLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        
        milkingSystemTextView.translatesAutoresizingMaskIntoConstraints = false
        milkingSystemTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        milkingSystemTextView.leftAnchor.constraint(equalTo: milkingSystemLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        milkingSystemTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        milkingSystemTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        pinLabel.translatesAutoresizingMaskIntoConstraints = false
        pinLabel.topAnchor.constraint(equalTo: milkingSystemLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        pinLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        
        pinTextView.translatesAutoresizingMaskIntoConstraints = false
        pinTextView.topAnchor.constraint(equalTo: milkingSystemLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        pinTextView.leftAnchor.constraint(equalTo: pinLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        pinTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pinTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        milkingSystemPicker.translatesAutoresizingMaskIntoConstraints = false
        milkingSystemPicker.topAnchor.constraint(equalTo: pinLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        milkingSystemPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        milkingSystemPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = true
        milkingSystemPicker.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.23)).isActive = true
   
    
        selectBtn.translatesAutoresizingMaskIntoConstraints = false
        selectBtn.topAnchor.constraint(equalTo: milkingSystemPicker.bottomAnchor).isActive = true
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
    
    
    public convenience init(herdLogbook: HerdLogbookViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        self.herdLogbookView = herdLogbook
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
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        saveBtn.isHidden = true
        
        if(textView.tag == 2){
            textView.endEditing(true)
            
            saveBtn.isHidden = true
            
            textView.text = milkingSystemPickerData[0]
            
            milkingSystemPicker.isHidden = false
            milkingSystemPicker.isUserInteractionEnabled = true
            
            selectBtn.isHidden = false
            selectBtn.isEnabled = true
        }
        else{
            milkingSystemPicker.isHidden = true
            milkingSystemPicker.isUserInteractionEnabled = false
            
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
        
        milkingSystemPicker.isHidden = true
        milkingSystemPicker.isUserInteractionEnabled = false
        
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
        
        let fetchRequestCheckID: NSFetchRequest<Herd> = Herd.fetchRequest()
        let idToCheck = idTextView.text
        fetchRequestCheckID.predicate = NSPredicate(format: "id == %@", idToCheck!)
        
        var savedHerdArray: [Herd]? = nil
        do{
            savedHerdArray = try appDelegate?.persistentContainer.viewContext.fetch(fetchRequestCheckID)
            
        } catch{
            print("Error during fetch request")
        }
        
        if(savedHerdArray!.isEmpty == false){
            showToast(controller: self, message: "Herd Already Exists with that ID", seconds: 1)
        }
        else{
        
            let herd = Herd(context: (appDelegate?.persistentContainer.viewContext)!)
            herd.id = idTextView.text
            herd.location = locationTextView.text
            herd.milkingSystem = milkingSystemTextView.text
            herd.pin = pinTextView.text
        
            herdLogbookView!.addToHerdList(herdToAppend: herd)
        
            appDelegate?.saveContext()
            
        }
        
        
        DispatchQueue.main.async {
            self.idTextView.text = ""
            self.locationTextView.text = ""
            self.milkingSystemTextView.text = ""
            self.pinTextView.text = ""
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
        return milkingSystemPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return milkingSystemPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        milkingSystemTextView.text = milkingSystemPickerData[row]
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
