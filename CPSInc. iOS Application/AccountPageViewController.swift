//
//  AccountPageViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-30.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import CoreData

class AccountPageViewController: UIViewController {
    
    //User Defaults
    private let defaults = UserDefaults.standard
    
    //views
    private var menuView: MenuViewController? = nil
    private var appDelegate: AppDelegate? = nil
    
    //UIBarButtonItems
    private var backBtn = UIBarButtonItem()
    private var logoutBtn = UIBarButtonItem()
    
    //UIImage
    private let userImage = UIImage(named: "userLOGO")
    
    //UILabels
    private let syncStatusLabel = UILabel()
    private let syncStatusTitleLabel = UILabel()
    private let previousSyncLabel = UILabel()
    private let previousSyncDateLabel = UILabel()
    
    //ImageView
    private let userLogoImageView = UIImageView()
    
    //UIButtons
    private let accountDetailsBtn = UIButton()
    private let syncCloudBtn = UIButton()
    private let backupCloudBtn = UIButton()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Account"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupLayoutComponents()
        setupLayoutConstraints()
    }
    
    private func setupLayoutComponents(){
        //BAR BUTON ITEMS
        backBtn = UIBarButtonItem.init(title: "Menu", style: .done, target: self, action: #selector(backBtnPressed))
        logoutBtn = UIBarButtonItem.init(title: "Logout", style: .done, target: self, action: #selector(logoutBtnPressed))
        navigationItem.leftBarButtonItem = backBtn
        //navigationController?.navigationBar.topItem?.backBarButtonItem = backBtn
        navigationItem.rightBarButtonItem = logoutBtn
        
        //SCANNING INDICATOR
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator)
        
        
        userLogoImageView.image = userImage
        view.addSubview(userLogoImageView)
        
        
        accountDetailsBtn.backgroundColor = .blue
        accountDetailsBtn.setTitle("View Account Information", for: .normal)
        accountDetailsBtn.setTitleColor(.white, for: .normal)
        accountDetailsBtn.layer.borderWidth = 2
        accountDetailsBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(accountDetailsBtn)
        accountDetailsBtn.addTarget(self, action: #selector(accountDetailsBtnPressed), for: .touchUpInside)
        
        syncCloudBtn.backgroundColor = .gray
        syncCloudBtn.setTitle("Sync", for: .normal)
        syncCloudBtn.layer.borderWidth = 2
        view.addSubview(syncCloudBtn)
        syncCloudBtn.addTarget(self, action: #selector(syncCloudBtnPressed), for: .touchUpInside)
        
        backupCloudBtn.backgroundColor = .blue
        backupCloudBtn.setTitle("Backup", for: .normal)
        backupCloudBtn.setTitleColor(.white, for: .normal)
//        backupCloudBtn.layer.borderWidth = 2
//        backupCloudBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(backupCloudBtn)
        backupCloudBtn.addTarget(self, action: #selector(backupCloudBtnPressed), for: .touchUpInside)
        
        
        syncStatusTitleLabel.attributedText = NSAttributedString(string: "Sync Status: ", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        syncStatusTitleLabel.textColor = .black
        syncStatusTitleLabel.textAlignment = .center
        view.addSubview(syncStatusTitleLabel)
        
        
        if(appDelegate!.getSyncUpToDate() == true){
            syncStatusLabel.text = "    Up to Date"
            syncStatusLabel.textColor = .green
            syncCloudBtn.isEnabled = false
            syncCloudBtn.layer.borderColor = UIColor.lightGray.cgColor
            syncCloudBtn.setTitleColor(.lightGray, for: .normal)
            
        }
        else{
            syncStatusLabel.text = "    Sync Required"
            syncStatusLabel.textColor = .red
            syncCloudBtn.isEnabled = true
            syncCloudBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            syncCloudBtn.setTitleColor(.black, for: .normal)
        }
        syncStatusLabel.textAlignment = .center
        view.addSubview(syncStatusLabel)
        
        
        
        previousSyncLabel.attributedText = NSAttributedString(string: "Last Synced: ", attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue])
        previousSyncLabel.textColor = .black
        previousSyncLabel.textAlignment = .center
        view.addSubview(previousSyncLabel)
        
        previousSyncDateLabel.text = "  " + defaults.string(forKey: "PreviousSyncDateDefault")!
        if(appDelegate!.getSyncUpToDate() == true){
            previousSyncDateLabel.textColor = .green
        }
        else{
            previousSyncDateLabel.textColor = .red
        }
        previousSyncDateLabel.textAlignment = .center
        view.addSubview(previousSyncDateLabel)
    }
    
    
    private func setupLayoutConstraints(){
        //SCANNING INDICATOR
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scanningIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        scanningIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
        
        
        
        userLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        userLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        userLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        userLogoImageView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        userLogoImageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        
        syncStatusTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        syncStatusTitleLabel.topAnchor.constraint(equalTo: userLogoImageView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        syncStatusTitleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        syncStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        syncStatusLabel.topAnchor.constraint(equalTo: userLogoImageView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        syncStatusLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        
        syncCloudBtn.translatesAutoresizingMaskIntoConstraints = false
        syncCloudBtn.topAnchor.constraint(equalTo: syncStatusTitleLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        syncCloudBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        syncCloudBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2).isActive = true
        
        
        previousSyncLabel.translatesAutoresizingMaskIntoConstraints = false
        previousSyncLabel.topAnchor.constraint(equalTo: syncCloudBtn.bottomAnchor, constant: UIScreen.main.bounds.height * 0.02).isActive = true
        previousSyncLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        previousSyncDateLabel.translatesAutoresizingMaskIntoConstraints = false
        previousSyncDateLabel.topAnchor.constraint(equalTo: syncCloudBtn.bottomAnchor, constant: UIScreen.main.bounds.height * 0.02).isActive = true
        previousSyncDateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    @objc private func backBtnPressed(){
        //print("should pop to menu view")
        navigationController?.popToViewController(menuView!, animated: true)
    }
    
    @objc private func logoutBtnPressed(){
        
        if(Reachability.isConnectedToNetwork() == false){
            self.showToast(controller: self, message: "No Internet Connection", seconds: 1)
            return
        }
        
        DispatchQueue.main.async {
            self.scanningIndicator.startAnimating()
        }
        
        
        
        //NEED TO SEND REQUEST TO BLACKLIST JWT TOKEN
        
        
        
        let removeJWTSuccessfull = KeychainWrapper.standard.removeObject(forKey: "JWT-Auth-Token") //remove jwt token
        
        let removeUserIDSuccessfull = KeychainWrapper.standard.removeObject(forKey: "User-ID-Token") //remove userID token
        
        if(removeJWTSuccessfull && removeUserIDSuccessfull){
             navigationController?.popToViewController(menuView!, animated: true)
        }
        
        
        DispatchQueue.main.async {
            self.scanningIndicator.stopAnimating()
        }
        
    }
    
    
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(appDelegate: AppDelegate?, menuView: MenuViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.appDelegate = appDelegate
        self.menuView = menuView
        
        //init before view is loaded (since this value will be needed when view is initially loaded)
        defaults.register(defaults: ["PreviousSyncDateDefault": "None"])
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc private func syncCloudBtnPressed(){ //start a sync logo
        
        if(Reachability.isConnectedToNetwork() == false){
            self.showToast(controller: self, message: "No Internet Connection", seconds: 1)
            return
        }
        
        //let syncQueue = DispatchQueue(label: "SyncQueue", qos: .background)
       // syncQueue.async {
            
            //fetch all Herds
            let herdFetchRequest: NSFetchRequest<Herd> = Herd.fetchRequest()
            var savedHerdArray: [Herd]? = nil
            
            do{
                savedHerdArray = try self.appDelegate?.persistentContainer.viewContext.fetch(herdFetchRequest)
                
                //upload Herds
                for herdToUpload in savedHerdArray! {
                    
                    
                    let jsonHerdObject: [String: Any] = [
                        "id": herdToUpload.id as Any,
                        "location": herdToUpload.location as Any,
                        "milkingSystem": herdToUpload.milkingSystem as Any,
                        "pin": herdToUpload.pin as Any,
                        "userID": KeychainWrapper.standard.string(forKey: "User-ID-Token") as Any
                    ]
                    
                    var herdJsonData: Data? = nil
                    
                    if(JSONSerialization.isValidJSONObject(jsonHerdObject)){
                        do{
                            herdJsonData = try JSONSerialization.data(withJSONObject: jsonHerdObject, options: [])
                        }catch{
                            print("Problem while serializing jsonLoginObject")
                        }
                    }
                    
                    
                    
                    var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/herd")!)
                    request.httpMethod = "POST"
                    request.httpBody = herdJsonData
                    request.setValue("application/json", forHTTPHeaderField: "Content-type")
                    request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if(error != nil){
                            print("Error occured during /login RESTAPI request")
                            DispatchQueue.main.async {
                                self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                            }
                        }
                        else{
                            
                            //                        DispatchQueue.main.async {
                            //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
                            //                        }
                            
                            
                            print("Response:")
                            print(response!)
                            print("Data:")
                            print(String(decoding: data!, as: UTF8.self))
                            
                            if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
                                DispatchQueue.main.async {
                                    self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
                                }
                                
                                return //return from function - end sync
                            }
                        }
                        
                        
                    }
                    
                    task.resume()
                    
                }
            } catch{
                print("Error during fetch request")
                DispatchQueue.main.async {
                    self.showToast(controller: self, message: "Error", seconds: 1)
                }
                return
            }
            
            
            //fetch all cows
            let cowFetchRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
            var savedCowArray: [Cow]? = nil
            
            do{
                savedCowArray = try self.appDelegate?.persistentContainer.viewContext.fetch(cowFetchRequest)
                
                //upload Cows
                for cowToUpload in savedCowArray! {
                    
                    
                    let jsonCowObject: [String: Any] = [
                        "id": cowToUpload.id as Any,
                        "daysInMilk": cowToUpload.daysInMilk as Any,
                        "dryOffDay": cowToUpload.dryOffDay as Any,
                        "mastitisHistory": cowToUpload.mastitisHistory as Any,
                        "methodOfDryOff": cowToUpload.methodOfDryOff as Any,
                        "name": cowToUpload.name as Any,
                        "parity": cowToUpload.parity as Any,
                        "reproductionStatus": cowToUpload.reproductionStatus as Any,
                        "herdID": cowToUpload.herd!.id as Any,
                        "userID": KeychainWrapper.standard.string(forKey: "User-ID-Token") as Any
                    ]
                    
                    var cowJsonData: Data? = nil
                    
                    if(JSONSerialization.isValidJSONObject(jsonCowObject)){
                        do{
                            cowJsonData = try JSONSerialization.data(withJSONObject: jsonCowObject, options: [])
                        }catch{
                            print("Problem while serializing jsonLoginObject")
                        }
                    }
                    
                    
                    
                    var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/cow")!)
                    request.httpMethod = "POST"
                    request.httpBody = cowJsonData
                    request.setValue("application/json", forHTTPHeaderField: "Content-type")
                    request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if(error != nil){
                            print("Error occured during /login RESTAPI request")
                            DispatchQueue.main.async {
                                self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                            }
                            
                        }
                        else{
                            
                            //                        DispatchQueue.main.async {
                            //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
                            //
                            //                        }
                            //
                            
                            print("Response:")
                            print(response!)
                            print("Data:")
                            print(String(decoding: data!, as: UTF8.self))
                            
                            if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
                                DispatchQueue.main.async {
                                    self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
                                }
                                return //return from function - end sync
                            }
                            
                        }
                    }
                    
                    task.resume()
                    
                    
                }
            } catch{
                print("Error during fetch request")
                DispatchQueue.main.async {
                    self.showToast(controller: self, message: "Error", seconds: 1)
                }
                return
            }
            
            ///////////////////////////////////////////////
            
        //fetch all cows
        let testFetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
        var savedTestArray: [Test]? = nil
        
        do{
            savedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(testFetchRequest)
            
//            print("saved test first value: " + savedTestArray![0].dataType!)
//            print("saved test first value cow id: " + savedTestArray![0].cow!.id!)
            
            //upload Cows
            for testToUpload in savedTestArray! {
                
                let jsonTestObject: [String: Any] = [
                    "date": testToUpload.date as Any,
                    "dataType": testToUpload.dataType as Any,
                    "runtime": testToUpload.runtime as Any,
                    "testType": testToUpload.testType as Any,
                    "units": testToUpload.units as Any,
                    "value": testToUpload.value as Any,
                    "cowID": testToUpload.cow!.id as Any,
                    "userID": KeychainWrapper.standard.string(forKey: "User-ID-Token") as Any
                ]
                
                var testJsonData: Data? = nil
                
                if(JSONSerialization.isValidJSONObject(jsonTestObject)){
                    do{
                        testJsonData = try JSONSerialization.data(withJSONObject: jsonTestObject, options: [])
                    }catch{
                        print("Problem while serializing jsonLoginObject")
                    }
                }
                
                
                
                var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/test")!)
                request.httpMethod = "POST"
                request.httpBody = testJsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-type")
                request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if(error != nil){
                        print("Error occured during /login RESTAPI request")
                        DispatchQueue.main.async {
                            self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                        }
                        
                    }
                    else{
                        
                        //                        DispatchQueue.main.async {
                        //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
                        //
                        //                        }
                        //
                        
                        print("Response:")
                        print(response!)
                        print("Data:")
                        print(String(decoding: data!, as: UTF8.self))
                        
                        if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
                            DispatchQueue.main.async {
                                self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
                            }
                            return //return from function - end sync
                        }
                        
                    }
                }
                
                task.resume()
                
                
            }
        } catch{
            print("Error during fetch request")
            DispatchQueue.main.async {
                self.showToast(controller: self, message: "Error", seconds: 1)
            }
            return
        }

        
        //}
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        defaults.set(formatter.string(from: Date()), forKey: "PreviousSyncDateDefault")
        previousSyncDateLabel.text = "  " + defaults.string(forKey: "PreviousSyncDateDefault")!
        appDelegate!.setSyncUpToDate(upToDate: true) //do this at the end in case the token expires during the sync and a request is rejected then it will return from this function and never update this - so it will not say that the sync has falsely been completed
        
    }
    
    @objc private func backupCloudBtnPressed(){
        //FILL OUT
    }
    
    @objc private func accountDetailsBtnPressed(){
        //FILL OUT
    }
    
    
    //GETTERS / SETTERS
    
    public func setSyncStatus(needsSync: Bool){
        if(needsSync){
            DispatchQueue.main.async {
                self.syncStatusLabel.text = "    Sync Required"
                self.syncStatusLabel.textColor = .red
                self.previousSyncDateLabel.textColor = .red
                self.syncCloudBtn.isEnabled = true
                self.syncCloudBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                self.syncCloudBtn.setTitleColor(.black, for: .normal)
            }
        }
        else{
            DispatchQueue.main.async {
                self.syncStatusLabel.text = "    Up to Date"
                self.syncStatusLabel.textColor = .green
                self.previousSyncDateLabel.textColor = .green
                self.syncCloudBtn.isEnabled = false
                self.syncCloudBtn.layer.borderColor = UIColor.lightGray.cgColor
                self.syncCloudBtn.setTitleColor(.lightGray, for: .normal)
            }
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
