//
//  AccountPageViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-30.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//
//THIS VIEW CONTROLLER DEALS WITH THE ACCOUNT SCREEN SEEN AFTER LOGGING INTO YOUR ACCOUNT

import UIKit
import SwiftKeychainWrapper
import CoreData
import WatchConnectivity


class AccountPageViewController: UIViewController, WCSessionDelegate {
    
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
    
    
    //ImageView
    private let userLogoImageView = UIImageView()
    
    //UIButtons
    private let accountDetailsBtn = UIButton()
    
    //WCSessions
    private var wcSession: WCSession? = nil
    
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
        
        
        let group = DispatchGroup()
        group.enter()

        var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user/logout")!)
        request.httpMethod = "POST"
        request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                print("Error occured during /logout RESTAPI request")
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


                if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                        self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
                    }
                    
                    return
                }


                if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
                    DispatchQueue.main.async {
                        self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
                    }
                }
                else{
                    print("Blacklisted JWT Token")
                    group.leave()
                }
            }
        }

        task.resume()

        group.wait()
        
        
        //let removeJWTSuccessfull = KeychainWrapper.standard.removeObject(forKey: "JWT-Auth-Token") //remove jwt token
        
        //let removeUserIDSuccessfull = KeychainWrapper.standard.removeObject(forKey: "User-ID-Token") //remove userID token
        
        //if(removeJWTSuccessfull && removeUserIDSuccessfull){
            navigationController?.popToViewController(menuView!, animated: true)
        //}
        
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
    
    
    
    
  
    
    

//    @objc private func syncCloudBtnPressed(){ //start a sync logo
//
//        var returnToMain = false
//
//
//        if(Reachability.isConnectedToNetwork() == false){
//            self.showToast(controller: self, message: "No Internet Connection", seconds: 1)
//            return
//        }
//
//
//
//        DispatchQueue.main.async{
//            self.scanningIndicator.startAnimating()
//        }
//        //let syncQueue = DispatchQueue(label: "SyncQueue", qos: .background)
//       // syncQueue.async {
//        let group = DispatchGroup()
//        group.enter()
//
//        //delete previous records
//        var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/sync")!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-type")
//        request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
//        request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if(error != nil){
//                print("Error occured during /login RESTAPI request")
//                DispatchQueue.main.async {
//                    self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
//                }
//
//            }
//            else{
//
//                //                        DispatchQueue.main.async {
//                //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
//                //
//                //                        }
//                //
//
//                print("Response:")
//                print(response!)
//                print("Data:")
//                print(String(decoding: data!, as: UTF8.self))
//
//
//
//                if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
//                    DispatchQueue.main.async {
//                        self.navigationController?.popToRootViewController(animated: true)
//                        self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
//
//                    }
//                    return
//
//                }
//
//
//
//                if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
//                    DispatchQueue.main.async {
//                        self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
//                    }
//                    return //return from function - end sync
//                }
//
//                group.leave()
//
//            }
//
//
//            //                    print("left group - syncing tests")
//        }
//
//        task.resume()
//
//        group.wait()
//
//
//            //fetch all Herds
//            let herdFetchRequest: NSFetchRequest<Herd> = Herd.fetchRequest()
//            var savedHerdArray: [Herd]? = nil
//
//            do{
//                savedHerdArray = try self.appDelegate?.persistentContainer.viewContext.fetch(herdFetchRequest)
//
//                if(savedHerdArray!.isEmpty){
//
//                    var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/herd")!)
//                    request.httpMethod = "POST"
//                    request.setValue("application/json", forHTTPHeaderField: "Content-type")
//                    request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
//                    request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
//
//                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                        if(error != nil){
//                            print("Error occured during /login RESTAPI request")
//                            DispatchQueue.main.async {
//                                self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
//                            }
//
//                        }
//                        else{
//
//                            //                        DispatchQueue.main.async {
//                            //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
//                            //
//                            //                        }
//                            //
//
//                            print("Response:")
//                            print(response!)
//                            print("Data:")
//                            print(String(decoding: data!, as: UTF8.self))
//
//
//
//                            if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
//                                DispatchQueue.main.async {
//                                    self.navigationController?.popToRootViewController(animated: true)
//                                    self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
//
//                                }
//                                return
//
//                            }
//
//
//
//                            if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
//                                DispatchQueue.main.async {
//                                    self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
//                                }
//                                return //return from function - end sync
//                            }
//
//                        }
//
//                        //                    group.leave()
//                        //                    print("left group - syncing tests")
//                    }
//
//                    task.resume()
//
//                }
//
//                //upload Herds
//                for herdToUpload in savedHerdArray! {
//
//
//                let jsonHerdObject: [String: Any] = [
//                    "id": herdToUpload.id as Any,
//                    "location": herdToUpload.location as Any,
//                    "milkingSystem": herdToUpload.milkingSystem as Any,
//                    "pin": herdToUpload.pin as Any,
//                    "userID": KeychainWrapper.standard.string(forKey: "User-ID-Token") as Any
//                ]
//
//                var herdJsonData: Data? = nil
//
//                if(JSONSerialization.isValidJSONObject(jsonHerdObject)){
//                    do{
//                        herdJsonData = try JSONSerialization.data(withJSONObject: jsonHerdObject, options: [])
//                    }catch{
//                        print("Problem while serializing jsonLoginObject")
//                    }
//                }
//
//
//
//                    var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/herd")!)
//                    request.httpMethod = "POST"
//                    request.httpBody = herdJsonData
//                    request.setValue("application/json", forHTTPHeaderField: "Content-type")
//                    request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
//                    request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
//
//                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                        if(error != nil){
//                            print("Error occured during /login RESTAPI request")
//                            DispatchQueue.main.async {
//                                self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
//                            }
//                        }
//                        else{
//
//                            //                        DispatchQueue.main.async {
//                            //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
//                            //                        }
//
//
//                            print("Response:")
//                            print(response!)
//                            print("Data:")
//                            print(String(decoding: data!, as: UTF8.self))
//
//
//                            if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
//                                returnToMain = true
//                                return
//                            }
//
//
//                            if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
//                                DispatchQueue.main.async {
//                                    self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
//                                }
//
//                                return //return from function - end sync
//                            }
//                        }
//
//                        print("left group - syncing herds")
//                    }
//
//                    task.resume()
//
//
//                }
//            } catch{
//                print("Error during fetch request")
//                DispatchQueue.main.async {
//                    self.showToast(controller: self, message: "Error", seconds: 1)
//                }
//                return
//            }
//
//
//
//        if(returnToMain == true){
//            DispatchQueue.main.async {
//                self.navigationController?.popToViewController(self.menuView!, animated: true)
//            }
//        }
//
//        else{
//
//        print("entered group - syncing cows")
//
//            //fetch all cows
//            let cowFetchRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
//            var savedCowArray: [Cow]? = nil
//
//            do{
//                savedCowArray = try self.appDelegate?.persistentContainer.viewContext.fetch(cowFetchRequest)
//
//
//                if(savedCowArray!.isEmpty){
//
//                    var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/cow")!)
//                    request.httpMethod = "POST"
//                    request.setValue("application/json", forHTTPHeaderField: "Content-type")
//                    request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
//                    request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
//
//                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                        if(error != nil){
//                            print("Error occured during /login RESTAPI request")
//                            DispatchQueue.main.async {
//                                self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
//                            }
//
//                        }
//                        else{
//
//                            //                        DispatchQueue.main.async {
//                            //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
//                            //
//                            //                        }
//                            //
//
//                            print("Response:")
//                            print(response!)
//                            print("Data:")
//                            print(String(decoding: data!, as: UTF8.self))
//
//
//
//                            if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
//                                DispatchQueue.main.async {
//                                    self.navigationController?.popToRootViewController(animated: true)
//                                    self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
//
//                                }
//                                return
//
//                            }
//
//
//
//                            if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
//                                DispatchQueue.main.async {
//                                    self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
//                                }
//                                return //return from function - end sync
//                            }
//
//                        }
//
//                        //                    group.leave()
//                        //                    print("left group - syncing tests")
//                    }
//
//                    task.resume()
//
//                }
//
//
//                //upload Cows
//                for cowToUpload in savedCowArray! {
//
//
//                    let jsonCowObject: [String: Any] = [
//                        "id": cowToUpload.id as Any,
//                        "daysInMilk": cowToUpload.daysInMilk as Any,
//                        "dryOffDay": cowToUpload.dryOffDay as Any,
//                        "mastitisHistory": cowToUpload.mastitisHistory as Any,
//                        "methodOfDryOff": cowToUpload.methodOfDryOff as Any,
//                        "dailyMilkAverage": cowToUpload.dailyMilkAverage as Any,
//                        "parity": cowToUpload.parity as Any,
//                        "reproductionStatus": cowToUpload.reproductionStatus as Any,
//                        "numberOfTimesBred": cowToUpload.numberTimesBred as Any,
//                        "farmBreedingIndex": cowToUpload.farmBreedingIndex as Any,
//                        "herdID": cowToUpload.herd!.id as Any,
//                        "userID": KeychainWrapper.standard.string(forKey: "User-ID-Token") as Any
//                    ]
//
//                    var cowJsonData: Data? = nil
//
//                    if(JSONSerialization.isValidJSONObject(jsonCowObject)){
//                        do{
//                            cowJsonData = try JSONSerialization.data(withJSONObject: jsonCowObject, options: [])
//                        }catch{
//                            print("Problem while serializing jsonLoginObject")
//                        }
//                    }
//
//
//                    var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/cow")!)
//                    request.httpMethod = "POST"
//                    request.httpBody = cowJsonData
//                    request.setValue("application/json", forHTTPHeaderField: "Content-type")
//                    request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
//                    request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
//
//                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                        if(error != nil){
//                            print("Error occured during /login RESTAPI request")
//                            DispatchQueue.main.async {
//                                self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
//                            }
//
//                        }
//                        else{
//
//                            //                        DispatchQueue.main.async {
//                            //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
//                            //
//                            //                        }
//                            //
//
//                            print("Response:")
//                            print(response!)
//                            print("Data:")
//                            print(String(decoding: data!, as: UTF8.self))
//
//
//
//                            if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
//                                returnToMain = true
//                                return
//
//                            }
//
//
//
//                            if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
//                                DispatchQueue.main.async {
//                                    self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
//                                }
//                                return //return from function - end sync
//                            }
//
//                        }
//
//                        print("left group - syncing cows")
//                    }
//
//                    task.resume()
//
//
//                }
//            } catch{
//                print("Error during fetch request")
//                DispatchQueue.main.async {
//                    self.showToast(controller: self, message: "Error", seconds: 1)
//                }
//                return
//            }
//
//            ///////////////////////////////////////////////
//
//
//        }
//
//        if(returnToMain == true){
//            DispatchQueue.main.async {
//                self.navigationController?.popToViewController(self.menuView!, animated: true)
//            }
//        }
//        else{
////        group.enter()
////        print("entered group - syncing tests")
//
//        //fetch all cows
//        let testFetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
//        var savedTestArray: [Test]? = nil
//
//        do{
//            savedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(testFetchRequest)
//
//
//            if(savedTestArray!.isEmpty){
//
//                var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/test")!)
//                request.httpMethod = "POST"
//                request.setValue("application/json", forHTTPHeaderField: "Content-type")
//                request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
//                request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
//
//                let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    if(error != nil){
//                        print("Error occured during /login RESTAPI request")
//                        DispatchQueue.main.async {
//                            self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
//                        }
//
//                    }
//                    else{
//
//                        //                        DispatchQueue.main.async {
//                        //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
//                        //
//                        //                        }
//                        //
//
//                        print("Response:")
//                        print(response!)
//                        print("Data:")
//                        print(String(decoding: data!, as: UTF8.self))
//
//
//
//                        if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
//                            DispatchQueue.main.async {
//                                self.navigationController?.popToRootViewController(animated: true)
//                                self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
//
//                            }
//                            return
//
//                        }
//
//
//
//                        if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
//                            DispatchQueue.main.async {
//                                self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
//                            }
//                            return //return from function - end sync
//                        }
//
//                    }
//
//                    //                    group.leave()
//                    //                    print("left group - syncing tests")
//                }
//
//                task.resume()
//
//            }
//
////            print("saved test first value: " + savedTestArray![0].dataType!)
////            print("saved test first value cow id: " + savedTestArray![0].cow!.id!)
//
//            //upload Cows
//            for testToUpload in savedTestArray! {
//
//                print(testToUpload.date as Any)
//                //print(testToUpload.dataType as Any)
//                //print(testToUpload.runtime as Any)
//                print(testToUpload.testType as Any)
//                print(testToUpload.units as Any)
//                print(testToUpload.value as Any)
//                print(testToUpload.cow!.id as Any)
//                print(KeychainWrapper.standard.string(forKey: "User-ID-Token") as Any)
//
//
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let dateString = formatter.string(from: testToUpload.date! as Date)
//
//
//                let jsonTestObject: [String: Any] = [
//                    "date": dateString as Any,
//                    //"dataType": testToUpload.dataType as Any,
//                    //"runtime": testToUpload.runtime as Any,
//                    "testType": testToUpload.testType as Any,
//                    "units": testToUpload.units as Any,
//                    "value": testToUpload.value as Any,
//                    "cowID": testToUpload.cow!.id as Any,
//                    "userID": KeychainWrapper.standard.string(forKey: "User-ID-Token") as Any
//                ]
//
//
//                var testJsonData: Data? = nil
//
//                if(JSONSerialization.isValidJSONObject(jsonTestObject)){
//                    do{
//                        testJsonData = try JSONSerialization.data(withJSONObject: jsonTestObject, options: [])
//                    }catch{
//                        print("Problem while serializing jsonLoginObject")
//                    }
//                }
//
//                print("test json data: " + String(decoding: testJsonData!, as: UTF8.self))
//
//
//                var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/test")!)
//                request.httpMethod = "POST"
//                request.httpBody = testJsonData
//                request.setValue("application/json", forHTTPHeaderField: "Content-type")
//                request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
//                request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
//
//                let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    if(error != nil){
//                        print("Error occured during /login RESTAPI request")
//                        DispatchQueue.main.async {
//                            self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
//                        }
//
//                    }
//                    else{
//
//                        //                        DispatchQueue.main.async {
//                        //                            self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
//                        //
//                        //                        }
//                        //
//
//                        print("Response:")
//                        print(response!)
//                        print("Data:")
//                        print(String(decoding: data!, as: UTF8.self))
//
//
//
//                        if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
//                            DispatchQueue.main.async {
//                                self.navigationController?.popToRootViewController(animated: true)
//                                self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
//
//                            }
//                            return
//
//                        }
//
//
//
//                        if(String(decoding: data!, as: UTF8.self) != "Success"){ //error occured
//                            DispatchQueue.main.async {
//                                self.showToast(controller: self, message: "Error: " + String(decoding: data!, as: UTF8.self), seconds: 1)
//                            }
//                            return //return from function - end sync
//                        }
//
//                    }
//
////                    group.leave()
////                    print("left group - syncing tests")
//                }
//
//                task.resume()
//
//
//            }
//        } catch{
//            print("Error during fetch request")
//            DispatchQueue.main.async {
//                self.showToast(controller: self, message: "Error", seconds: 1)
//            }
//            return
//        }
//
//
//
//        //}
////        group.wait()
//
//
//        //UPDATE PREVIOUS SYNC LABEL
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd/yyyy HH:mm"
//        defaults.set(formatter.string(from: Date()), forKey: "PreviousSyncDateDefault")
//        previousSyncDateLabel.text = "  " + defaults.string(forKey: "PreviousSyncDateDefault")!
//            DispatchQueue.main.async {
//                self.appDelegate!.setSyncUpToDate(upToDate: true) //do this at the end in case the token expires during the sync and a request is rejected then it will return from this function and never update this - so it will not say that the sync has falsely been completed
//            }
//
//
//
//        }
//
//        DispatchQueue.main.async{
//            self.scanningIndicator.stopAnimating()
//        }
//    }
    
   
    
    
    

    
    @objc private func accountDetailsBtnPressed(){
        //FILL OUT
    }
    
    
    //GETTERS / SETTERS

    
    public func setWCSession(session: WCSession?){
        self.wcSession = session
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
    
    
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if(applicationContext["ChangeScreens"] != nil){
            switch(applicationContext["ChangeScreens"] as! String){
            case "Main":
                DispatchQueue.main.async {
                    self.wcSession!.delegate = self.menuView
                    self.menuView?.setWCSession(session: self.wcSession)
                    
                    self.menuView?.setInQueueView(flag: 0)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            default:
                print("Default case - do nothing")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //fill out
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //fill out
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //fill out
    }
}
