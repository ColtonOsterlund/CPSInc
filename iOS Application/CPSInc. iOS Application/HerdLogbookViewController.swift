//
//  LogbookViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-26.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS TABLE VIEW CONTROLLER DEALS WITH THE TABLE OF HERDS IN THE LOGBOOK

import UIKit
import WatchConnectivity
import CoreData
import SwiftyDropbox
import UserNotifications
import SwiftKeychainWrapper
import MessageUI


public class HerdLogbookViewController: UITableViewController, WCSessionDelegate, UISearchResultsUpdating, MFMailComposeViewControllerDelegate {
    
    private let scanningIndicator = UIActivityIndicatorView()
    
    private var herdList = [Herd]()
    private var filteredHerds = [Herd]()
    
    private var selectingFromList: Bool = false
    
    
    //UIDatePicker
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    var dateTextAlert: UIAlertController? = nil
    private var startDate: String? = nil
    private var endDate: String? = nil
    
    
    //ViewControllers
    public var menuView: MenuViewController? = nil
    private var cowLogbook: CowLogbookViewController? = nil
    private var herdInfoView: HerdInfoViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var addHerdView: AddHerdViewController? = nil
    
    //UISearchControllers
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    //dropbox client
    private var dropboxClient: DropboxClient? = nil
    
    //UIBarButtonItems
    private var addBtn = UIBarButtonItem()
    private var importBtn = UIBarButtonItem()
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Herd Logbook"
        //view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        setupLayoutItems()
        
    }
    
    
    
    
    
    
    private func fetchSavedData(){
        
        //remove all and reload data in tableView so that you don't click on one that no longer exits in the list and get an index out of range exception
        DispatchQueue.main.async{
            self.herdList.removeAll()
            self.tableView.reloadData()
            self.scanningIndicator.startAnimating()
        }
        
        
//        let fetchRequest: NSFetchRequest<Herd> = Herd.fetchRequest()
//
//        do{
//            let savedHerdArray = try appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
//            self.herdList = savedHerdArray!
//        } catch{
//            print("Error during fetch request")
//        }
        
        var backupRequest = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user-herd-app?userID=" + KeychainWrapper.standard.string(forKey: "User-ID-Token")!)!)
        backupRequest.httpMethod = "GET"
        backupRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        backupRequest.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
        backupRequest.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
        
        let backupTask = URLSession.shared.dataTask(with: backupRequest) { data, response, error in
            if(error != nil){
                print("Error occured during /herd RESTAPI request")
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    self.showToast(controller: self, message: "Network Error", seconds: 1)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
                    return
                }
            }
            else{
                
                print("Response:")
                print(response!)
                print("Data:")
                print(String(decoding: data!, as: UTF8.self))
                
                
                if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
                     DispatchQueue.main.async {
                        self.scanningIndicator.stopAnimating()
                        self.showToast(controller: self, message: "Error: Must login to access logbook", seconds: 2)
                        self.navigationController?.popToRootViewController(animated: true)
                        //self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
                    }
                                       
                    return
                }
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
                    
                    
                    
                    for object in json! {
                        
                        
                            let toSave = Herd(context: (self.appDelegate?.persistentContainer.viewContext)!)
                            
                            toSave.id = object["id"] as? String
                            toSave.location = object["location"] as? String
                            toSave.milkingSystem = object["milkingSystem"] as? String
                            toSave.pin = object["pin"] as? String
                                
                            self.herdList.append(toSave)
                            
                            print("HERE HERD: ")
                        
                        
                    }
                    
                    self.herdList.sort(by: {$0.id!.localizedStandardCompare($1.id!) == .orderedAscending})
                    
                    DispatchQueue.main.async {
                        self.scanningIndicator.stopAnimating()
                        print(self.herdList.isEmpty)
                        self.tableView.reloadData()
                    }
                    
                    
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        self.scanningIndicator.stopAnimating()
                        self.showToast(controller: self, message: "Network Error", seconds: 1)
                    }
                    print(error.localizedDescription)
                }
                
            }
        }
        
        backupTask.resume()
        
  
    }
    
    
    
    
    
    
    
    
    public override func viewWillAppear(_ animated: Bool) {
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        fetchSavedData() //fetch saved data when view appears
    }
    
    private func setupLayoutItems(){
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "herdTableViewCell")
        
        addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        importBtn = UIBarButtonItem.init(title: "Import", style: .plain, target: self, action: #selector(importBtnPressed))
        
        navigationItem.rightBarButtonItems = [addBtn/*, importBtn*/]
        
        
        
        startDatePicker.datePickerMode = .date
        startDatePicker.tag = 0
        startDatePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
        
        endDatePicker.datePickerMode = .date
        endDatePicker.tag = 1
        endDatePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
        
        
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
        
        //searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Herd by ID"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    @objc private func addBtnPressed(){
        navigationController?.pushViewController(addHerdView!, animated: true)
        
//        let herd = Herd(context: (appDelegate?.persistentContainer.viewContext)!)
//        herd.id = "12345"
//        herd.location = "Calgary"
//        herd.milkingSystem = "Pulling the utters"
//        herd.pin = "dunno what this is"
//        herd.addToCow(Cow(context: (appDelegate?.persistentContainer.viewContext)!))
        
//        herdList.append(herd)
        
        
        
//        appDelegate?.saveContext()
//
//        fetchSavedData()
        
        //print("done")
    }
    
    @objc private func importBtnPressed(){
        
        if(Reachability.isConnectedToNetwork() == false){
            showToast(controller: self, message: "No Internet Connection", seconds: 1)
            return
        }
        
        //import data from excel/csv file or google sheets document
        if(dropboxClient == nil){ //authorize client
            DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: {
                (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
        }
        else{
            self.importAfterDropboxConnection()
        }
        
    }
    
    //not sure this is the best way to handle this - look into it
    public func importAfterDropboxConnection(){
        
        if(dropboxClient == nil){
            dropboxClient = DropboxClientsManager.authorizedClient
            dropboxClient!.files.createFolderV2(path: "/CSV Uploads")
        }
        
        
        let listFiles = dropboxClient!.files.listFolder(path: "/CSV Uploads")
        let importAlert = UIAlertController(title: "Import", message: "Add Files to /App/Creative Protein Solutions Inc./CSV Uploads in Dropbox to Import (only .csv files entered into this directory will appear here)", preferredStyle: .actionSheet)
        
        importAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        listFiles.response{ responseList, error in
        
            if(responseList != nil){
                
            var existsCSV = false
                
            for entry in responseList!.entries{
                print(entry)
                if(String(entry.name.suffix(4)).lowercased() == ".csv"){ //check that it is a .csv file
                    existsCSV = true
                    importAlert.addAction(UIAlertAction(title: entry.name, style: .default, handler: { action in
                        //download and parse file here
                        
                        
                        self.dropboxClient!.files.download(path: entry.pathDisplay!)
                            .response { response, error in
                                if let response = response {
                                    
                                    let fileMetadata = response.0
                                    //print(fileMetadata)
                                    let fileData = response.1
                                    //print(fileData)
                                    
                                    let fileString = String(data: fileData, encoding: .utf8)
                                    
                                    self.parseCSVFileData(csvString: fileString!, bytes: fileMetadata.size) //parse data and load into cows
                                    
                                    
                                } else if let error = error {
                                    print(error)
                                }
                            }
                            .progress { progressData in
                                print(progressData)
                        }
                       
                        
                        
                    }))
                }
                }
            }
            
        }
        
        self.present(importAlert, animated: true)
    }
    
    private func parseCSVFileData(csvString: String, bytes: UInt64){
        
        let parsingQueue: DispatchQueue? = DispatchQueue(label: "Parsing Data Queue", qos: .background) //create a background thread to parse the data as this can be a slow process
        
        self.scanningIndicator.startAnimating()
        
        parsingQueue!.async{
            
            //create a herd for the cow
            let importedHerd = Herd(context: (self.appDelegate?.persistentContainer.viewContext)!)
            importedHerd.id = "Imported Herd"
            importedHerd.location = ""
            importedHerd.milkingSystem = ""
            importedHerd.pin = ""
            self.addToHerdList(herdToAppend: importedHerd)
            self.cowLogbook?.setSelectedHerd(herd: importedHerd)
            
            
            //separate csvString into rows
            var csvRowArray = csvString.components(separatedBy: "\r")
            
            //seperate header row into columns
            let csvHeaderColumnArray = csvRowArray[0].components(separatedBy: ",")
            
            //remove first row from csv row array to be left with only cow data
            csvRowArray.removeFirst()
            
            //variable to keep track of whether end of cow info was reached in file
            
            //iterate through csvRowArray creating a new cow for each row
            for row in csvRowArray{
                //separate row into cow attribute array
                var cowAttributeArray = row.components(separatedBy: CharacterSet(charactersIn: ",\n\r"))
                
                
                print(cowAttributeArray[0])
                
                cowAttributeArray = cowAttributeArray.filter{$0 != ""}
                
                
                if(cowAttributeArray.isEmpty == false){
                DispatchQueue.main.sync {
                    print("-" + cowAttributeArray[0] + "-")
                }
                
                
                
                //create new cow
                let cow: Cow? = Cow(context: (self.appDelegate?.persistentContainer.viewContext)!)
                
                
                //itterate through cowAttributeArray keeping track of the index to compare with the header values to know where to place the attribute
                for (index, attribute) in cowAttributeArray.enumerated(){
                    //switch through the header values to know where to place the attribute
                    
                    switch(csvHeaderColumnArray[index]){
                        case "ID":
                            print("id: " + attribute)
                            cow!.id = attribute
                            
                        case "DIM":
                            print("dim: " + attribute)
                            cow!.daysInMilk = attribute
                            
                            cow!.dryOffDay = String(305 - Int(attribute)!)
                            
                        case "MAVG":
                            print("mavg: " + attribute)
                            cow!.dailyMilkAverage = attribute
                            
//                        case "dry off day":
//                            cow!.dryOffDay = attribute
//                        case "mastitis history":
//                            cow!.mastitisHistory = attribute
//                        case "dry off":
//                            cow!.methodOfDryOff = attribute
//                        case "name":
//                            cow!.name = attribute
                        case "LACT":
                            print("lact: " + attribute)
                            cow!.parity = attribute
                            
                        case "RPRO":
                            print("rpro: " + attribute)
                            cow!.reproductionStatus = attribute
                            
                        case "TBRD":
                            print("tbrd: " + attribute)
                            cow!.numberTimesBred = attribute
                            
                        case "MFI":
                            print("mfi: " + attribute)
                            cow!.farmBreedingIndex = attribute
                          
                        default:
                            //print("default case")
                            break
                    }
                }
                
                
                    cow!.mastitisHistory = ""
                    cow!.methodOfDryOff = ""

                cow!.herd = importedHerd
                    
                }
                
//                if(bytes >= 8000){ //find actual number that this would be beneficial - SAVES STACK MEMORY
//                    self.appDelegate?.saveContext() //saves cow to disk memory
//                    cow = nil //removes cow from stack memory
//                }
                
            }
            
            //if(bytes < 8000){ //find actual number that this would be beneficial - SAVES EXECUTION TIME
                self.appDelegate?.saveContext() //saves all cows that were created in memory to context
           // }
            
            DispatchQueue.main.async {
                self.fetchSavedData() //execute on main thread at end of background thread running
                self.scanningIndicator.stopAnimating()
               // print("got here")
            }
            
        }
    
        
        
    }

    public convenience init(menuView: MenuViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.menuView = menuView
        cowLogbook = CowLogbookViewController(herdLogbook: self, appDelegate: appDelegate)
        herdInfoView = HerdInfoViewController(herdLogbook: self, appDelegate: appDelegate)
        self.appDelegate = appDelegate
        addHerdView = AddHerdViewController(herdLogbook: self, appDelegate: appDelegate)
        
        setupLayoutItems()
        
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
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
            default:
                print("Default case - do nothing")
            }
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
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredHerds.count
        }
        else{
            return herdList.count
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "herdTableViewCell", for: indexPath)
//        let peripheral = peripheralDevices[indexPath.row]
//        cell.textLabel?.text = peripheral.name
        if(isFiltering()){
            cell.textLabel?.text = "Herd ID: " + filteredHerds[indexPath.row].id!
        }
        else{
            cell.textLabel?.text = "Herd ID: " + herdList[indexPath.row].id!
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var herdToUse: Herd? = nil
        if(isFiltering()){
            herdToUse = filteredHerds[indexPath.row]
        }
        else{
            herdToUse = herdList[indexPath.row]
        }
        
        if(selectingFromList == false){
        
        let selectedRowAlert = UIAlertController(title: tableView.cellForRow(at: indexPath)?.textLabel?.text, message: "Please Select One of the Following", preferredStyle: .actionSheet) //actionSheet shows on the bottom of the screen while alert comes up in the middle
        
        selectedRowAlert.addAction(UIAlertAction(title: "Herd Info", style: .default, handler: { action in
            self.herdInfoView?.setSelectedHerd(herd: herdToUse)
            self.navigationController?.pushViewController(self.herdInfoView!, animated: true)
        }))
        selectedRowAlert.addAction(UIAlertAction(title: "Cow Listing", style: .default, handler: { action in
                self.cowLogbook!.setSelectedHerd(herd: herdToUse)
                self.navigationController?.pushViewController(self.cowLogbook!, animated: true)
            
        }))
        selectedRowAlert.addAction(UIAlertAction(title: "Herd Report", style: .default, handler: { action in
            self.reportBtnPressed(selectedHerd: herdToUse)
        }))
        selectedRowAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        selectedRowAlert.addAction(UIAlertAction(title: "Delete Herd", style: .destructive, handler: { action in
            let confirmationAlert = UIAlertController(title: tableView.cellForRow(at: indexPath)?.textLabel?.text, message: "Delete Herd?", preferredStyle: .alert)
            
            confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                DispatchQueue.main.async{
                    self.scanningIndicator.startAnimating()
                }
                
                
        //        let fetchRequest: NSFetchRequest<Herd> = Herd.fetchRequest()
        //
        //        do{
        //            let savedHerdArray = try appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
        //            self.herdList = savedHerdArray!
        //        } catch{
        //            print("Error during fetch request")
        //        }
                
                var backupRequest = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user-herd-delete-app?userID=" + KeychainWrapper.standard.string(forKey: "User-ID-Token")! + "&herdID=" + (herdToUse?.id)!)!)
                backupRequest.httpMethod = "GET"
                backupRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
                backupRequest.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                backupRequest.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
                
                let backupTask = URLSession.shared.dataTask(with: backupRequest) { data, response, error in
                    if(error != nil){
                        print("Error occured during /herd RESTAPI request")
                        DispatchQueue.main.async {
                            self.scanningIndicator.stopAnimating()
                            self.showToast(controller: self, message: "Network Error", seconds: 1)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
                            return
                        }
                    }
                    else{
                        
                        print("Response:")
                        print(response!)
                        print("Data:")
                        print(String(decoding: data!, as: UTF8.self))
                        
                        
                        if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
                             DispatchQueue.main.async {
                                self.scanningIndicator.stopAnimating()
                                self.showToast(controller: self, message: "Error: Must login to access logbook", seconds: 2)
                                self.navigationController?.popToRootViewController(animated: true)
                                //self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
                            }
                                               
                            return
                        }
                        
                        
                        do {
                            DispatchQueue.main.async {
                                self.scanningIndicator.stopAnimating()
                                self.fetchSavedData()
                            }
                            
                            
                        } catch let error as NSError {
                            DispatchQueue.main.async {
                                self.scanningIndicator.stopAnimating()
                                self.showToast(controller: self, message: "Network Error", seconds: 1)
                            }
                            print(error.localizedDescription)
                        }
                        
                    }
                }
                
                backupTask.resume()
                
            }))
            
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(confirmationAlert, animated: true)
            
        }))
        
        
        self.present(selectedRowAlert, animated: true)
            
        }
        else{
            self.cowLogbook!.setSelectedHerd(herd: herdToUse)
            self.cowLogbook!.setSelectingCowFromList(select: true)
            self.navigationController?.pushViewController(self.cowLogbook!, animated: true)
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
    
    
    
    
    
    
    
    
    
    @objc private func reportBtnPressed(selectedHerd: Herd?){
        //TODO generate Herd analytics report
        
        self.dateTextAlert = UIAlertController(title: "Generate Herd Report", message: "Select Date Range", preferredStyle: .alert)
        
            self.dateTextAlert?.addTextField{ (textField) in
                textField.placeholder = "Start Date"
                textField.inputView = self.startDatePicker
            }
                self.dateTextAlert?.addTextField{ (textField) in
                textField.placeholder = "End Date"
                textField.inputView = self.endDatePicker
            }
        
            self.dateTextAlert?.addAction(UIAlertAction(title: "Generate Report", style: .default, handler: { action in
                if(self.startDate == nil && self.endDate == nil){
                    self.showToast(controller: self, message: "Please Select a Start and End Date", seconds: 1)
                    return
                }
                else if(self.startDate == nil){
                    self.showToast(controller: self, message: "Please Select a Start Date", seconds: 1)
                    return
                }
                else if(self.endDate == nil){
                    self.showToast(controller: self, message: "Please Select an End Date", seconds: 1)
                    return
                }
                
                self.scanningIndicator.startAnimating()
                
                
                //FETCH ALL COWS IN THE HERD
//                let fetchCowRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
//                fetchCowRequest.predicate = NSPredicate(format: "herd == %@", selectedHerd!)
                var savedCowArray = [Cow]()
                
                var backupRequestFetchCows = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user-cow-app?userID=" + KeychainWrapper.standard.string(forKey: "User-ID-Token")! + "&herdID=" + (selectedHerd?.id)! as String)!)
                backupRequestFetchCows.httpMethod = "GET"
                backupRequestFetchCows.setValue("application/json", forHTTPHeaderField: "Content-type")
                backupRequestFetchCows.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                backupRequestFetchCows.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
                
                let backupTaskFetchCows = URLSession.shared.dataTask(with: backupRequestFetchCows) { data, response, error in
                    if(error != nil){
                        print("Error occured during /user-cow RESTAPI request")
                        DispatchQueue.main.async {
                            self.scanningIndicator.stopAnimating()
                            self.showToast(controller: self, message: "Network Error", seconds: 1)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
                            return
                        }
                    }
                    else{
                        
                        print("Response:")
                        print(response!)
                        print("Data:")
                        print(String(decoding: data!, as: UTF8.self))
                        
                        
                        if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
                             DispatchQueue.main.async {
                                self.scanningIndicator.stopAnimating()
                                self.showToast(controller: self, message: "Must login to view your logbook", seconds: 2)
                                self.navigationController?.popToRootViewController(animated: true)
                                //self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
                            }
                                               
                            return
                        }
                        
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
                            
                                                
                            for object in json! {
                                
                                
                                let toSave = Cow(context: (self.appDelegate?.persistentContainer.viewContext)!)
                                    
                                toSave.id = object["id"] as? String
                                toSave.daysInMilk = object["daysInMilk"] as? String
                                toSave.dryOffDay = object["dryOffDay"] as? String
                                toSave.mastitisHistory = ""//object["mastitisHistory"] as? String
                                toSave.methodOfDryOff = ""//object["methodOfDryOff"] as? String
                                toSave.dailyMilkAverage = ""//object["dailyMilkAverage"] as? String
                                toSave.parity = ""//object["parity"] as? String
                                toSave.reproductionStatus = ""//object["reproductionStatus"] as? String
                                toSave.numberTimesBred = ""//object["numberOfTimesBred"] as? String
                                toSave.farmBreedingIndex = ""//object["farmBreedingIndex"] as? String
                                toSave.herd = selectedHerd
                                toSave.lactationNumber = object["lactationNumber"] as? String
                                toSave.daysCarriedCalfIfPregnant = object["daysCarriedCalfIfPregnant"] as? String
                                toSave.projectedDueDate = object["projectedDueDate"] as? String
                                toSave.current305DayMilk = object["current305DayMilk"] as? String
                                toSave.currentSomaticCellCount = object["currentSomaticCellCount"] as? String
                                toSave.linearScoreAtLastTest = object["linearScoreAtLastTest"] as? String
                                toSave.dateOfLastClinicalMastitis = object["dateOfLastClinicalMastitis"] as? String
                                toSave.chainVisibleID = object["chainVisibleId"] as? String
                                toSave.animalRegistrationNoNLID = object["animalRegistrationNoNLID"] as? String
                                toSave.damBreed = object["damBreed"] as? String
                                
                                var culled = object["culled"] as! Int
                                toSave.culled = String(culled)
                            
                                        
                                savedCowArray.append(toSave)
                                    
                                
                            }
                            
                            savedCowArray.sort(by: {$0.id!.localizedStandardCompare($1.id!) == .orderedAscending})
                            
                            DispatchQueue.main.async {
                                self.scanningIndicator.stopAnimating()
                            }
                            
                            
                            
                            
                            
                            let dateformatter = DateFormatter()
                            dateformatter.dateStyle = DateFormatter.Style.short
                            var startDateString: String? = nil;
                            var endDateString: String? = nil;
                            DispatchQueue.main.sync {
                                startDateString = dateformatter.string(from: self.startDatePicker.date) + ", 12:00:00 AM"
                                endDateString = dateformatter.string(from: self.endDatePicker.date) + ", 11:59:59 PM"
                            }
                            dateformatter.timeStyle = DateFormatter.Style.short
                            
            //                let predicateStartDate = NSPredicate(format: "date >= %@", dateformatter.date(from: startDateString)! as NSDate) //need to add times to these dates
            //                let predicateEndDate = NSPredicate(format: "date <= %@", dateformatter.date(from: endDateString)! as NSDate)
            //                let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateStartDate, predicateEndDate])
            //                fetchTestRequest.predicate = fetchPredicate
                            var savedTestArray = [Test]()
                            
                            var testFetchString = "https://pacific-ridge-88217.herokuapp.com/user-test-app"
                            testFetchString.append("?userID=" + KeychainWrapper.standard.string(forKey: "User-ID-Token")!)
                            testFetchString.append("&startDate=" + startDateString!)
                            testFetchString.append("&endDate=" + endDateString!)
                            testFetchString.append("&herdID=" + ((selectedHerd?.id!)!))
                            
                            var backupRequestFetchTests = URLRequest(url: URL(string: testFetchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
                            backupRequestFetchTests.httpMethod = "GET"
                            backupRequestFetchTests.setValue("application/json", forHTTPHeaderField: "Content-type")
                            backupRequestFetchTests.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                            backupRequestFetchTests.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
                            
                            let backupTaskFetchTests = URLSession.shared.dataTask(with: backupRequestFetchTests) { [self] data, response, error in
                                if(error != nil){
                                    print("Error occured during /user-test RESTAPI request")
                                    DispatchQueue.main.async {
                                        self.scanningIndicator.stopAnimating()
                                        self.showToast(controller: self, message: "Network Error", seconds: 1)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
                                        return
                                    }
                                }
                                else{
                                    
                                    print("Response:")
                                    print(response!)
                                    print("Data:")
                                    print(String(decoding: data!, as: UTF8.self))
                                    
                                    
                                    if(String(decoding: data!, as: UTF8.self) == "Invalid Token"){
                                         DispatchQueue.main.async {
                                            self.scanningIndicator.stopAnimating()
                                            self.showToast(controller: self, message: "Must login to view your logbook", seconds: 2)
                                            self.navigationController?.popToRootViewController(animated: true)
                                            //self.navigationController?.pushViewController(self.menuView!.getLoginView(), animated: true)
                                        }
                                                           
                                        return
                                    }
                                    
                                    
                                    do {
                                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
                                        
                                        
                                                            
                                        for object in json! {
                                            
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                            
                                            let toSave = Test(context: (self.appDelegate?.persistentContainer.viewContext)!)
                                            
                                            //find cow with proper ID to save to test
                                            for cow in savedCowArray{
                                                
                                                
                                                if(cow.id == object["cowID"] as! String){
                                                    toSave.cow = cow
                                                }
                                            }

                                            toSave.herd = selectedHerd
                                            toSave.date = formatter.date(from: object["date"] as! String) as NSDate?
                                            toSave.followUpNum = object["followUpNum"] as? NSNumber
                                            toSave.milkFever = (object["milkFever"] as! NSString).boolValue
                                            toSave.testID = object["testID"] as? String
                                            toSave.testType = object["testType"] as? String
                                            toSave.units = object["units"] as? String
                                            toSave.value = (object["value"] as! NSString).floatValue
                                                
                                            print(toSave.date)
                                            
                                            savedTestArray.append(toSave)
                                            
                                        }
                                        
                                        savedTestArray.sort(by: {$0.testID!.localizedStandardCompare($1.testID!) == .orderedAscending})
                                        
                                        DispatchQueue.main.async {
                                            self.scanningIndicator.stopAnimating()
                                            //print(self.testList.isEmpty)
                                        }
                                        
                                        let GenerateEmailQueue = DispatchQueue(label: "Generate Email Queue", attributes: .concurrent)
                                            
                                        GenerateEmailQueue.async {
                                            self.GenerateEmail(selectedHerd: selectedHerd, savedCowArray: savedCowArray, savedTestArray: savedTestArray)
                                        }
                                        
                                    } catch let error as NSError {
                                        DispatchQueue.main.async {
                                            self.scanningIndicator.stopAnimating()
                                            self.showToast(controller: self, message: "Network Error", seconds: 1)
                                        }
                                        print(error.localizedDescription)
                                    }
                                    
                                }
                            }
                            
                            backupTaskFetchTests.resume()
                            
                            
                            
                            
                            
                            
                            
                        } catch let error as NSError {
                            DispatchQueue.main.async {
                                self.scanningIndicator.stopAnimating()
                                self.showToast(controller: self, message: "Network Error", seconds: 1)
                            }
                            print(error.localizedDescription)
                        }
                        
                    }
                }
                
                backupTaskFetchCows.resume()
                
//                do{
//                    savedCowArray = try (self.appDelegate?.persistentContainer.viewContext.fetch(fetchCowRequest))!
//                } catch{
//                    print("Error during fetch request")
//                }
                
                //FETCH TESTS FOR EACH COW BETWEEN THE SPECIFIED DATES
//                let fetchTestRequest: NSFetchRequest<Test> = Test.fetchRequest()
                
                
                
//                do{
//                    savedTestArray = try (self.appDelegate?.persistentContainer.viewContext.fetch(fetchTestRequest))!
//                    
//                    //remove all tests from the array that do not correspond to the cows in the herd being analyzed (farmer may have multiple herds)
//                    var index = 0
//                    
//                    for test in savedTestArray{
//                        var inCowArray: Bool = false
//                        
//                        for cow in savedCowArray{
//                            if(test.cow == cow){
//                                inCowArray = true
//                            }
//                        }
//                        
//                        if(inCowArray == false){
//                            savedTestArray.remove(at: index)
//                        }
//                        
//                        index += 1
//                    }
//                    
//                } catch{
//                    print("Error during fetch request")
//                }
                
                //savedCowArray
                //savedTestArray
                
                //FULL HERD ANALYTICS
                //count number of cows tested in full herd
                
                
                
            }))
            
                //generate results
        
        self.dateTextAlert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.startDate = nil
        self.endDate = nil
        self.startDatePicker.date = Date() //set to current date
        self.endDatePicker.date = Date() //set to current date
        self.dateTextAlert?.textFields![0].text = "" //clear textField
        self.dateTextAlert?.textFields![1].text = "" //cear textField
        self.present(self.dateTextAlert!, animated: true)
    }
    
    
    
    
    
    func GenerateEmail(selectedHerd: Herd?, savedCowArray: [Cow], savedTestArray: [Test]){
        var fullHerdNumCowsTested: Int = 0
//        var parity1NumCowsTested: Int = 0
//        var parity2NumCowsTested: Int = 0
//        var parity3NumCowsTested: Int = 0
//        var parity4NumCowsTested: Int = 0
//        var parity5NumCowsTested: Int = 0
//        var parity6NumCowsTested: Int = 0
        
        
        for cow in savedCowArray{
            
            for test in savedTestArray{
                if(cow.id == test.cow!.id){
                    
                    fullHerdNumCowsTested += 1
                    break
//                    if(test.cow!.parity! == String(1)){
//                        parity1NumCowsTested += 1
//                    }
//                    else if(test.cow!.parity! == String(2)){
//                        parity2NumCowsTested += 1
//                    }
//                    else if(test.cow!.parity! == String(3)){
//                        parity3NumCowsTested += 1
//                    }
//                    else if(test.cow!.parity! == String(4)){
//                        parity4NumCowsTested += 1
//                    }
//                    else if(test.cow!.parity! == String(5)){
//                        parity5NumCowsTested += 1
//                    }
//                    else if(test.cow!.parity! == String(6)){
//                        parity6NumCowsTested += 1
//                    }
                }
            }
            
        }
        
        //count number of cows in each category
        var fullHerdNumCowsTestedSubclinical: Int = 0
        var fullHerdNumCowsTestedClinical: Int = 0
        var fullHerdNumCowsTestedNormal: Int = 0
//        var parity1NumCowsTestedSubclinical: Int = 0
//        var parity1NumCowsTestedClinical: Int = 0
//        var parity1NumCowsTestedNormal: Int = 0
//        var parity2NumCowsTestedSubclinical: Int = 0
//        var parity2NumCowsTestedClinical: Int = 0
//        var parity2NumCowsTestedNormal: Int = 0
//        var parity3NumCowsTestedSubclinical: Int = 0
//        var parity3NumCowsTestedClinical: Int = 0
//        var parity3NumCowsTestedNormal: Int = 0
//        var parity4NumCowsTestedSubclinical: Int = 0
//        var parity4NumCowsTestedClinical: Int = 0
//        var parity4NumCowsTestedNormal: Int = 0
//        var parity5NumCowsTestedSubclinical: Int = 0
//        var parity5NumCowsTestedClinical: Int = 0
//        var parity5NumCowsTestedNormal: Int = 0
//        var parity6NumCowsTestedSubclinical: Int = 0
//        var parity6NumCowsTestedClinical: Int = 0
//        var parity6NumCowsTestedNormal: Int = 0
        
        for cow in savedCowArray{
            var testFlag: Int = -1 // -1 = no test, 0 = normal, 1 = subclinical, 2 = clinical
            
            for test in savedTestArray{
                if(test.cow!.id == cow.id){
                    if(test.units == "mg/dL"){
                        if(test.value < 5.5){
                            testFlag = 2
                        }
                        else if(test.value >= 5.5 && test.value <= 8.0 && testFlag != 2){
                            testFlag = 1
                        }
                        else if(test.value > 8.0 && testFlag != 1 && testFlag != 2){
                            testFlag = 0
                        }
                    }
                    else if(test.units == "mM"){
                        if(test.value < 1.375){
                            testFlag = 2
                        }
                        else if(test.value >= 1.375 && test.value <= 2.0 && testFlag != 2){
                            testFlag = 1
                        }
                        else if(test.value > 2.0 && testFlag != 1 && testFlag != 2){
                            testFlag = 0
                        }
                    }
                }
            }
            
            if(testFlag == 0){
                fullHerdNumCowsTestedNormal += 1
                
//                if(cow.parity! == String(1)){
//                    parity1NumCowsTestedNormal += 1
//                }
//                else if(cow.parity! == String(2)){
//                    parity2NumCowsTestedNormal += 1
//                }
//                else if(cow.parity! == String(3)){
//                    parity3NumCowsTestedNormal += 1
//                }
//                else if(cow.parity! == String(4)){
//                    parity4NumCowsTestedNormal += 1
//                }
//                else if(cow.parity! == String(5)){
//                    parity5NumCowsTestedNormal += 1
//                }
//                else if(cow.parity! >= String(6)){
//                    parity6NumCowsTestedNormal += 1
//                }
            }
            else if(testFlag == 1 || testFlag == 2){
                fullHerdNumCowsTestedSubclinical += 1
                
//                if(cow.parity! == String(1)){
//                    parity1NumCowsTestedSubclinical += 1
//                }
//                else if(cow.parity! == String(2)){
//                    parity2NumCowsTestedSubclinical += 1
//                }
//                else if(cow.parity! == String(3)){
//                    parity3NumCowsTestedSubclinical += 1
//                }
//                else if(cow.parity! == String(4)){
//                    parity4NumCowsTestedSubclinical += 1
//                }
//                else if(cow.parity! == String(5)){
//                    parity5NumCowsTestedSubclinical += 1
//                }
//                else if(cow.parity! >= String(6)){
//                    parity6NumCowsTestedSubclinical += 1
//                }
            }
            //else if(testFlag == 2){
                //fullHerdNumCowsTestedClinical += 1
                
//                if(cow.parity! == String(1)){
//                    parity1NumCowsTestedClinical += 1
//                }
//                else if(cow.parity! == String(2)){
//                    parity2NumCowsTestedClinical += 1
//                }
//                else if(cow.parity! == String(3)){
//                    parity3NumCowsTestedClinical += 1
//                }
//                else if(cow.parity! == String(4)){
//                    parity4NumCowsTestedClinical += 1
//                }
//                else if(cow.parity! == String(5)){
//                    parity5NumCowsTestedClinical += 1
//                }
//                else if(cow.parity! >= String(6)){
//                    parity6NumCowsTestedClinical += 1
//                }
           // }
        }
        
        //Write Herd report text file
        let url = self.getDocumentsDirectory().appendingPathComponent("HerdReport.txt")

        do {
            try String("Herd Report | " + self.startDate! + " - " + self.endDate! + "\n").write(to: url, atomically: true, encoding: .utf8)
            self.appendStringToFile(url: url, string: ("--------------------------------------\n\n"))
            if((selectedHerd?.id!)! == ""){
                self.appendStringToFile(url: url, string: ("Herd ID: N/A\n"))
            }
            else{
                self.appendStringToFile(url: url, string: ("Herd ID: " + (selectedHerd?.id!)! + "\n"))
            }
            if((selectedHerd?.location!)! == ""){
                self.appendStringToFile(url: url, string: ("Herd Location: N/A\n"))
            }
            else{
                self.appendStringToFile(url: url, string: ("Herd Location: " + (selectedHerd?.location!)! + "\n"))
            }
            if((selectedHerd?.milkingSystem!)! == ""){
                self.appendStringToFile(url: url, string: ("Herd Milking System: N/A\n"))
            }
            else{
                self.appendStringToFile(url: url, string: ("Herd Milking System: " + (selectedHerd?.milkingSystem!)! + "\n"))
            }
            if((selectedHerd?.pin!)! == ""){
                self.appendStringToFile(url: url, string: ("Herd Pin: N/A\n\n\n"))
            }
            else{
                self.appendStringToFile(url: url, string: ("Herd Pin: " + (selectedHerd?.pin!)! + "\n\n\n"))
            }
            self.appendStringToFile(url: url, string: ("Full Herd Analytics" + "\n"))
            self.appendStringToFile(url: url, string: ("--------------------\n\n"))
            self.appendStringToFile(url: url, string: ("Number of Cows in Herd: " + String(savedCowArray.count) + "\n"))
            self.appendStringToFile(url: url, string: ("Number of Tests Ran: " + String(savedTestArray.count) + "\n"))
            self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(fullHerdNumCowsTested) + "\n"))
            self.appendStringToFile(url: url, string: ("Number of Cows Tested Displaying no Signs of Milk Fever: " + String(fullHerdNumCowsTestedNormal) + "\n"))
            self.appendStringToFile(url: url, string: ("Number of Cows Tested Displaying Signs of Subclinical Milk Fever: " + String(fullHerdNumCowsTestedSubclinical) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Tested Displaying Signs of Clinical Milk Fever: " + String(fullHerdNumCowsTestedClinical) + "\n\n\n"))
            
            var prevalenceWholeHerdUnrounded = Double((Double(fullHerdNumCowsTestedSubclinical) / Double(savedCowArray.count)) * 100.0)
            var prevalenceWholeHerdRounded = Double(round(prevalenceWholeHerdUnrounded * 1000) / 1000)
            
            var prevalenceTestsUnrounded = Double((Double(fullHerdNumCowsTestedSubclinical) / Double(fullHerdNumCowsTested)) * 100.0)
            var prevalenceTestsRounded = Double(round(prevalenceTestsUnrounded * 1000) / 1000)
            
            self.appendStringToFile(url: url, string: ("\nPercentage of cows over the cows tested displaying signs of Subclinical Milk Fever \n(*may be a skewed value based on what percentage of the herd was tested*): " + String(prevalenceTestsRounded) + "%\n"))
            
            self.appendStringToFile(url: url, string: ("\nPercentage of cows over the whole herd displaying signs of Subclinical Milk Fever \n(*may be a skewed value based on what percentage of the herd was tested*): " + String(prevalenceWholeHerdRounded) + "%\n"))
            //self.appendStringToFile(url: url, string: ("Prevalence of Clinical Milk Fever in Herd: " + String(prevalenceClinical) + "%\n\n\n"))
//            self.appendStringToFile(url: url, string: ("Parity Based Herd Analytics" + "\n"))
//            self.appendStringToFile(url: url, string: ("----------------------------\n\n"))
//            self.appendStringToFile(url: url, string: ("Parity 1:" + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity1NumCowsTested) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity1NumCowsTestedNormal) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity1NumCowsTestedSubclinical) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity1NumCowsTestedClinical) + "\n\n"))
//            self.appendStringToFile(url: url, string: ("Parity 2:" + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity2NumCowsTested) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity2NumCowsTestedNormal) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity2NumCowsTestedSubclinical) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity2NumCowsTestedClinical) + "\n\n"))
//            self.appendStringToFile(url: url, string: ("Parity 3:" + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity3NumCowsTested) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity3NumCowsTestedNormal) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity3NumCowsTestedSubclinical) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity3NumCowsTestedClinical) + "\n\n"))
//            self.appendStringToFile(url: url, string: ("Parity 4:" + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity4NumCowsTested) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity4NumCowsTestedNormal) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity4NumCowsTestedSubclinical) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity4NumCowsTestedClinical) + "\n\n"))
//            self.appendStringToFile(url: url, string: ("Parity 5:" + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity5NumCowsTested) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity5NumCowsTestedNormal) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity5NumCowsTestedSubclinical) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity5NumCowsTestedClinical) + "\n\n"))
//            self.appendStringToFile(url: url, string: ("Parity 6+:" + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity6NumCowsTested) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity6NumCowsTestedNormal) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity6NumCowsTestedSubclinical) + "\n"))
//            self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity6NumCowsTestedClinical) + "\n\n"))
            
            let input = try String(contentsOf: url)
            print(input)
            
            
            
            DispatchQueue.main.async {
                self.scanningIndicator.stopAnimating()
                
                if( MFMailComposeViewController.canSendMail() ) {
                    let mailComposer = MFMailComposeViewController()
                    mailComposer.mailComposeDelegate = self

                    //Set the subject and message of the email
                    mailComposer.setSubject("Herd Report | " + self.startDate! + " - " + self.endDate!)
                    mailComposer.setMessageBody("", isHTML: false)

    //                        guard let filePath = Bundle.main.path(forResource: "HerdReport.txt", ofType: "txt") else {
    //                            print("here")
    //                            return
    //                        }
                    let fileURL = self.getDocumentsDirectory().appendingPathComponent("HerdReport.txt")
                    
                    
                    do {
                    let attachmentData = try Data(contentsOf: fileURL)
                        mailComposer.addAttachmentData(attachmentData, mimeType: "text/txt", fileName: "HerdReport")
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
                
            }
            
            
            
            
        } catch {
            print(error.localizedDescription)
        }
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
    
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    @objc private func datePickerChangedValue(sender: UIDatePicker){
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        
        if(sender.tag == 0){
            startDate = dateformatter.string(from: startDatePicker.date as Date)
            dateTextAlert?.textFields![0].text = startDate
        }
        else if(sender.tag == 1){
            endDate = dateformatter.string(from: endDatePicker.date as Date)
            dateTextAlert?.textFields![1].text = endDate
        }
    }
    
    
    
    
    
    
    //searchController methods
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredHerds = herdList.filter({( herd : Herd) -> Bool in
            return herd.id!.contains(searchText)
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
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
            break

        case .failed:
            print("Sending mail is failed")
            break
        default:
            break
        }

        controller.dismiss(animated: true)

    }
    
    
    //GETTERS/SETTERS
    
    public func getWCSession() -> WCSession{
        return wcSession!
    }
    
    public func setWCSession(session: WCSession?){
        wcSession = session
    }
    
    public func addToHerdList(herdToAppend: Herd){
        herdList.append(herdToAppend)
    }

    public func getHerdList() -> [Herd]{
        return herdList
    }
    
    public func getCowLogbookView() -> CowLogbookViewController{
        return cowLogbook!
    }
    
    public func setSelectingHerdFromList(select: Bool){
        self.selectingFromList = select
    }
    
}
