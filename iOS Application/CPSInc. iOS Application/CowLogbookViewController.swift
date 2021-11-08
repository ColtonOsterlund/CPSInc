//
//  CowLogbookViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-26.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS TABLE VIEW CONTROLLER DEALS WITH THE TABLE OF COWS IN THE LOGBOOK

import UIKit
import WatchConnectivity
import CoreData
import MessageUI
import SwiftKeychainWrapper

public class CowLogbookViewController: UITableViewController, WCSessionDelegate, UISearchResultsUpdating, MFMailComposeViewControllerDelegate {
    
    private var selectedHerd: Herd? = nil
    private var cowList = [Cow]()
    private var filteredCows = [Cow]()
    
    private var selectingFromList: Bool = false
    
    public var herdLogbook: HerdLogbookViewController? = nil
    private var testLogbook: TestLogbookViewController? = nil
    private var cowInfoView: CowInfoViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var addCowView: AddCowViewController? = nil
    
    //UISearchControllers
    let searchController = UISearchController(searchResultsController: nil)
    
    //UIBarButtonItems
    private var addBtn = UIBarButtonItem()
    private var reportBtn = UIBarButtonItem()
    
//    //UIDatePicker
//    private let startDatePicker = UIDatePicker()
//    private let endDatePicker = UIDatePicker()
//    var dateTextAlert: UIAlertController? = nil
//    private var startDate: String? = nil
//    private var endDate: String? = nil
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cow Logbook"
        //view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        setupLayoutItems()

    }
    
    private func fetchSavedData(){
       
        
        
        DispatchQueue.main.async{
            self.cowList.removeAll()
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
        
        var backupRequest = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user-cow-app?userID=" + KeychainWrapper.standard.string(forKey: "User-ID-Token")! + "&herdID=" + (selectedHerd?.id)! as String)!)
        backupRequest.httpMethod = "GET"
        backupRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        backupRequest.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
        backupRequest.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
        
        let backupTask = URLSession.shared.dataTask(with: backupRequest) { data, response, error in
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
                        toSave.herd = self.selectedHerd
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
                    
                                
                        self.cowList.append(toSave)
                            
                        print("HERE COW: ")
                        
                        
                    }
                    
                    self.cowList.sort(by: {$0.id!.localizedStandardCompare($1.id!) == .orderedAscending})
                    
                    DispatchQueue.main.async {
                        self.scanningIndicator.stopAnimating()
                        print(self.cowList.isEmpty)
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
        fetchSavedData()
    }
    
    
    private func setupLayoutItems(){
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cowTableViewCell")
        
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
        
        //reportBtn = UIBarButtonItem.init(title: "Report", style: .plain, target: self, action: #selector(reportBtnPressed))
        addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
     
        navigationItem.rightBarButtonItems = [addBtn/*, reportBtn*/]
        
//        startDatePicker.datePickerMode = .date
//        startDatePicker.tag = 0
//        startDatePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
//
//        endDatePicker.datePickerMode = .date
//        endDatePicker.tag = 1
//        endDatePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
        
        //searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cow by ID"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //SCANNING INDICATOR
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator)
    }
    
    
    
    public convenience init(herdLogbook: HerdLogbookViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.herdLogbook = herdLogbook
        testLogbook = TestLogbookViewController(cowLogbook: self, appDelegate: appDelegate)
        cowInfoView = CowInfoViewController(appDelegate: appDelegate, cowLogbook: self)
        self.appDelegate = appDelegate
        addCowView = AddCowViewController(appDelegate: appDelegate, cowLogbook: self)
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }
    
    
    
//    @objc private func reportBtnPressed(){
//        //TODO generate Herd analytics report
//
//        self.dateTextAlert = UIAlertController(title: "Generate Herd Report", message: "Select Date Range", preferredStyle: .alert)
//
//            self.dateTextAlert?.addTextField{ (textField) in
//                textField.placeholder = "Start Date"
//                textField.inputView = self.startDatePicker
//            }
//                self.dateTextAlert?.addTextField{ (textField) in
//                textField.placeholder = "End Date"
//                textField.inputView = self.endDatePicker
//            }
//
//            self.dateTextAlert?.addAction(UIAlertAction(title: "Generate Report", style: .default, handler: { action in
//                if(self.startDate == nil && self.endDate == nil){
//                    self.showToast(controller: self, message: "Please Select a Start and End Date", seconds: 1)
//                    return
//                }
//                else if(self.startDate == nil){
//                    self.showToast(controller: self, message: "Please Select a Start Date", seconds: 1)
//                    return
//                }
//                else if(self.endDate == nil){
//                    self.showToast(controller: self, message: "Please Select an End Date", seconds: 1)
//                    return
//                }
//
//                self.scanningIndicator.startAnimating()
//
//
//                //FETCH ALL COWS IN THE HERD
//                let fetchCowRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
//                fetchCowRequest.predicate = NSPredicate(format: "herd == %@", self.selectedHerd!)
//                var savedCowArray = [Cow]()
//                do{
//                    savedCowArray = try (self.appDelegate?.persistentContainer.viewContext.fetch(fetchCowRequest))!
//                } catch{
//                    print("Error during fetch request")
//                }
//
//                //FETCH TESTS FOR EACH COW BETWEEN THE SPECIFIED DATES
//                let fetchTestRequest: NSFetchRequest<Test> = Test.fetchRequest()
//                let dateformatter = DateFormatter()
//                dateformatter.dateStyle = DateFormatter.Style.short
//                let startDateString = dateformatter.string(from: self.startDatePicker.date) + ", 12:00 AM"
//                let endDateString = dateformatter.string(from: self.endDatePicker.date) + ", 11:59 PM"
//                dateformatter.timeStyle = DateFormatter.Style.short
//
//                let predicateStartDate = NSPredicate(format: "date >= %@", dateformatter.date(from: startDateString)! as NSDate) //need to add times to these dates
//                let predicateEndDate = NSPredicate(format: "date <= %@", dateformatter.date(from: endDateString)! as NSDate)
//                let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateStartDate, predicateEndDate])
//                fetchTestRequest.predicate = fetchPredicate
//                var savedTestArray = [Test]()
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
//
//                //savedCowArray
//                //savedTestArray
//
//                //FULL HERD ANALYTICS
//
//                //count number of cows tested in full herd
//                var fullHerdNumCowsTested: Int = 0
//                var parity1NumCowsTested: Int = 0
//                var parity2NumCowsTested: Int = 0
//                var parity3NumCowsTested: Int = 0
//                var parity4NumCowsTested: Int = 0
//                var parity5NumCowsTested: Int = 0
//                var parity6NumCowsTested: Int = 0
//
//                for test in savedTestArray{
//                    if(savedCowArray.contains(test.cow!)){
//                        fullHerdNumCowsTested += 1
//                        if(test.cow!.parity! == String(1)){
//                            parity1NumCowsTested += 1
//                        }
//                        else if(test.cow!.parity! == String(2)){
//                            parity2NumCowsTested += 1
//                        }
//                        else if(test.cow!.parity! == String(3)){
//                            parity3NumCowsTested += 1
//                        }
//                        else if(test.cow!.parity! == String(4)){
//                            parity4NumCowsTested += 1
//                        }
//                        else if(test.cow!.parity! == String(5)){
//                            parity5NumCowsTested += 1
//                        }
//                        else if(test.cow!.parity! == String(6)){
//                            parity6NumCowsTested += 1
//                        }
//                    }
//                }
//
//                //count number of cows in each category
//                var fullHerdNumCowsTestedSubclinical: Int = 0
//                var fullHerdNumCowsTestedClinical: Int = 0
//                var fullHerdNumCowsTestedNormal: Int = 0
//                var parity1NumCowsTestedSubclinical: Int = 0
//                var parity1NumCowsTestedClinical: Int = 0
//                var parity1NumCowsTestedNormal: Int = 0
//                var parity2NumCowsTestedSubclinical: Int = 0
//                var parity2NumCowsTestedClinical: Int = 0
//                var parity2NumCowsTestedNormal: Int = 0
//                var parity3NumCowsTestedSubclinical: Int = 0
//                var parity3NumCowsTestedClinical: Int = 0
//                var parity3NumCowsTestedNormal: Int = 0
//                var parity4NumCowsTestedSubclinical: Int = 0
//                var parity4NumCowsTestedClinical: Int = 0
//                var parity4NumCowsTestedNormal: Int = 0
//                var parity5NumCowsTestedSubclinical: Int = 0
//                var parity5NumCowsTestedClinical: Int = 0
//                var parity5NumCowsTestedNormal: Int = 0
//                var parity6NumCowsTestedSubclinical: Int = 0
//                var parity6NumCowsTestedClinical: Int = 0
//                var parity6NumCowsTestedNormal: Int = 0
//
//                for cow in savedCowArray{
//                    var testFlag: Int = -1 // -1 = no test, 0 = normal, 1 = subclinical, 2 = clinical
//
//                    for test in savedTestArray{
//                        if(test.cow == cow){
//                            if(test.units == "mg/dL"){
//                                if(test.value < 5.5){
//                                    testFlag = 2
//                                }
//                                else if(test.value >= 5.5 && test.value <= 8.0 && testFlag != 2){
//                                    testFlag = 1
//                                }
//                                else if(test.value > 8.0 && testFlag != 1 && testFlag != 2){
//                                    testFlag = 0
//                                }
//                            }
//                            else if(test.units == "mM"){
//                                if(test.value < 1.375){
//                                    testFlag = 2
//                                }
//                                else if(test.value >= 1.375 && test.value <= 2.0 && testFlag != 2){
//                                    testFlag = 1
//                                }
//                                else if(test.value > 2.0 && testFlag != 1 && testFlag != 2){
//                                    testFlag = 0
//                                }
//                            }
//                        }
//                    }
//
//                    if(testFlag == 0){
//                        fullHerdNumCowsTestedNormal += 1
//
//                        if(cow.parity! == String(1)){
//                            parity1NumCowsTestedNormal += 1
//                        }
//                        else if(cow.parity! == String(2)){
//                            parity2NumCowsTestedNormal += 1
//                        }
//                        else if(cow.parity! == String(3)){
//                            parity3NumCowsTestedNormal += 1
//                        }
//                        else if(cow.parity! == String(4)){
//                            parity4NumCowsTestedNormal += 1
//                        }
//                        else if(cow.parity! == String(5)){
//                            parity5NumCowsTestedNormal += 1
//                        }
//                        else if(cow.parity! >= String(6)){
//                            parity6NumCowsTestedNormal += 1
//                        }
//                    }
//                    else if(testFlag == 1){
//                        fullHerdNumCowsTestedSubclinical += 1
//
//                        if(cow.parity! == String(1)){
//                            parity1NumCowsTestedSubclinical += 1
//                        }
//                        else if(cow.parity! == String(2)){
//                            parity2NumCowsTestedSubclinical += 1
//                        }
//                        else if(cow.parity! == String(3)){
//                            parity3NumCowsTestedSubclinical += 1
//                        }
//                        else if(cow.parity! == String(4)){
//                            parity4NumCowsTestedSubclinical += 1
//                        }
//                        else if(cow.parity! == String(5)){
//                            parity5NumCowsTestedSubclinical += 1
//                        }
//                        else if(cow.parity! >= String(6)){
//                            parity6NumCowsTestedSubclinical += 1
//                        }
//                    }
//                    else if(testFlag == 2){
//                        fullHerdNumCowsTestedClinical += 1
//
//                        if(cow.parity! == String(1)){
//                            parity1NumCowsTestedClinical += 1
//                        }
//                        else if(cow.parity! == String(2)){
//                            parity2NumCowsTestedClinical += 1
//                        }
//                        else if(cow.parity! == String(3)){
//                            parity3NumCowsTestedClinical += 1
//                        }
//                        else if(cow.parity! == String(4)){
//                            parity4NumCowsTestedClinical += 1
//                        }
//                        else if(cow.parity! == String(5)){
//                            parity5NumCowsTestedClinical += 1
//                        }
//                        else if(cow.parity! >= String(6)){
//                            parity6NumCowsTestedClinical += 1
//                        }
//                    }
//                }
//
//                //Write Herd report text file
//                let url = self.getDocumentsDirectory().appendingPathComponent("HerdReport.txt")
//
//                do {
//                    try String("Herd Report | " + self.startDate! + " - " + self.endDate! + "\n").write(to: url, atomically: true, encoding: .utf8)
//                    self.appendStringToFile(url: url, string: ("--------------------------------------\n\n"))
//                    if((self.selectedHerd?.id!)! == ""){
//                        self.appendStringToFile(url: url, string: ("Herd ID: N/A\n"))
//                    }
//                    else{
//                        self.appendStringToFile(url: url, string: ("Herd ID: " + (self.selectedHerd?.id!)! + "\n"))
//                    }
//                    if((self.selectedHerd?.location!)! == ""){
//                        self.appendStringToFile(url: url, string: ("Herd Location: N/A\n"))
//                    }
//                    else{
//                        self.appendStringToFile(url: url, string: ("Herd Location: " + (self.selectedHerd?.location!)! + "\n"))
//                    }
//                    if((self.selectedHerd?.milkingSystem!)! == ""){
//                        self.appendStringToFile(url: url, string: ("Herd Milking System: N/A\n"))
//                    }
//                    else{
//                        self.appendStringToFile(url: url, string: ("Herd Milking System: " + (self.selectedHerd?.milkingSystem!)! + "\n"))
//                    }
//                    if((self.selectedHerd?.pin!)! == ""){
//                        self.appendStringToFile(url: url, string: ("Herd Pin: N/A\n"))
//                    }
//                    else{
//                        self.appendStringToFile(url: url, string: ("Herd Pin: " + (self.selectedHerd?.pin!)! + "\n\n\n"))
//                    }
//                    self.appendStringToFile(url: url, string: ("Full Herd Analytics" + "\n"))
//                    self.appendStringToFile(url: url, string: ("--------------------\n\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(fullHerdNumCowsTested) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(fullHerdNumCowsTestedNormal) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(fullHerdNumCowsTestedSubclinical) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(fullHerdNumCowsTestedClinical) + "\n\n\n"))
//                    self.appendStringToFile(url: url, string: ("Parity Based Herd Analytics" + "\n"))
//                    self.appendStringToFile(url: url, string: ("----------------------------\n\n"))
//                    self.appendStringToFile(url: url, string: ("Parity 1:" + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity1NumCowsTested) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity1NumCowsTestedNormal) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity1NumCowsTestedSubclinical) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity1NumCowsTestedClinical) + "\n\n"))
//                    self.appendStringToFile(url: url, string: ("Parity 2:" + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity2NumCowsTested) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity2NumCowsTestedNormal) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity2NumCowsTestedSubclinical) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity2NumCowsTestedClinical) + "\n\n"))
//                    self.appendStringToFile(url: url, string: ("Parity 3:" + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity3NumCowsTested) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity3NumCowsTestedNormal) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity3NumCowsTestedSubclinical) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity3NumCowsTestedClinical) + "\n\n"))
//                    self.appendStringToFile(url: url, string: ("Parity 4:" + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity4NumCowsTested) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity4NumCowsTestedNormal) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity4NumCowsTestedSubclinical) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity4NumCowsTestedClinical) + "\n\n"))
//                    self.appendStringToFile(url: url, string: ("Parity 5:" + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity5NumCowsTested) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity5NumCowsTestedNormal) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity5NumCowsTestedSubclinical) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity5NumCowsTestedClinical) + "\n\n"))
//                    self.appendStringToFile(url: url, string: ("Parity 6+:" + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Tested: " + String(parity6NumCowsTested) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying no Signs of Milk Fever: " + String(parity6NumCowsTestedNormal) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Subclinical Milk Fever: " + String(parity6NumCowsTestedSubclinical) + "\n"))
//                    self.appendStringToFile(url: url, string: ("Number of Cows Displaying Signs of Clinical Milk Fever: " + String(parity6NumCowsTestedClinical) + "\n\n"))
//
//                    let input = try String(contentsOf: url)
//                    print(input)
//
//                    self.scanningIndicator.stopAnimating()
//
//                    if( MFMailComposeViewController.canSendMail() ) {
//                        let mailComposer = MFMailComposeViewController()
//                        mailComposer.mailComposeDelegate = self
//
//                        //Set the subject and message of the email
//                        mailComposer.setSubject("Herd Report | " + self.startDate! + " - " + self.endDate!)
//                        mailComposer.setMessageBody("", isHTML: false)
//
////                        guard let filePath = Bundle.main.path(forResource: "HerdReport.txt", ofType: "txt") else {
////                            print("here")
////                            return
////                        }
//                        let fileURL = self.getDocumentsDirectory().appendingPathComponent("HerdReport.txt")
//
//
//                        do {
//                        let attachmentData = try Data(contentsOf: fileURL)
//                            mailComposer.addAttachmentData(attachmentData, mimeType: "text/txt", fileName: "HerdReport")
//                            mailComposer.mailComposeDelegate = self
//                            self.present(mailComposer, animated: true
//                                , completion: nil)
//                        } catch let error {
//                            print("We have encountered error \(error.localizedDescription)")
//                        }
//
//                        self.present(mailComposer, animated: true, completion: nil)
//                    }
//                    else{
//                        self.showToast(controller: self, message: "Cannot send email - Please make sure you have an email account set up on your device", seconds: 2)
//                    }
//
//                } catch {
//                    print(error.localizedDescription)
//                }
//
//            }))
//
//                //generate results
//
//        self.dateTextAlert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.startDate = nil
//        self.endDate = nil
//        self.startDatePicker.date = Date() //set to current date
//        self.endDatePicker.date = Date() //set to current date
//        self.dateTextAlert?.textFields![0].text = "" //clear textField
//        self.dateTextAlert?.textFields![1].text = "" //cear textField
//        self.present(self.dateTextAlert!, animated: true)
//    }
//
    
    
//    @objc private func datePickerChangedValue(sender: UIDatePicker){
//        let dateformatter = DateFormatter()
//        dateformatter.dateStyle = DateFormatter.Style.short
//
//        if(sender.tag == 0){
//            startDate = dateformatter.string(from: startDatePicker.date as Date)
//            dateTextAlert?.textFields![0].text = startDate
//        }
//        else if(sender.tag == 1){
//            endDate = dateformatter.string(from: endDatePicker.date as Date)
//            dateTextAlert?.textFields![1].text = endDate
//        }
//    }
    
    
    @objc private func addBtnPressed(){
        navigationController?.pushViewController(addCowView!, animated: true)
        
        
    }
    
    @objc private func removeBtnPressed(){
        //fill out
    }
    
    @objc private func editBtnPressed(){
        //fill out
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
        if(isFiltering()){
            return filteredCows.count
        }
        else{
            return cowList.count
        }
    }
        
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cowTableViewCell", for: indexPath)
        //        let peripheral = peripheralDevices[indexPath.row]
        //        cell.textLabel?.text = peripheral.name
        if(isFiltering()){
            cell.textLabel?.text = "Cow ID: " + filteredCows[indexPath.row].id!
        }
        else{
            cell.textLabel?.text = "Cow ID: " + cowList[indexPath.row].id!
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cowToUse: Cow? = nil
        if(isFiltering()){
            cowToUse = filteredCows[indexPath.row]
        }
        else{
            cowToUse = cowList[indexPath.row]
        }
        
        if(selectingFromList == false){
        
        let selectedRowAlert = UIAlertController(title: tableView.cellForRow(at: indexPath)?.textLabel?.text, message: "Please Select One of the Following", preferredStyle: .actionSheet) //actionSheet shows on the bottom of the screen while alert comes up in the middle
        
        selectedRowAlert.addAction(UIAlertAction(title: "Cow Info", style: .default, handler: { action in
            self.cowInfoView!.setSelectedCow(cow: cowToUse!)
            self.navigationController?.pushViewController(self.cowInfoView!, animated: true)
        }))
        selectedRowAlert.addAction(UIAlertAction(title: "Test Listing", style: .default, handler: { action in
            self.testLogbook!.setSelectedCow(cow: cowToUse)
            self.testLogbook!.setTimeFrame(date: nil)
            self.navigationController?.pushViewController(self.testLogbook!, animated: true)
        }))
            
        if(cowToUse?.culled == "0"){
            selectedRowAlert.addAction(UIAlertAction(title: "Set as Culled", style: .default, handler: { action in
                
                //Build HTTP Request
                var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/cow-update")!) //sync route on the server
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-type")
                request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
                
                //build JSON Body
                var jsonCowObject = [String: Any]()
                
                                    
                jsonCowObject = [
                    "objectType": "Cow" as Any,
                    "herdID": cowToUse!.herd?.id as Any,
                    "id": cowToUse!.id as Any,
                    "daysInMilk": cowToUse!.daysInMilk as Any,
                    "dryOffDay": cowToUse!.dryOffDay as Any,
                    "mastitisHistory": cowToUse!.mastitisHistory as Any,
                    "methodOfDryOff": cowToUse!.methodOfDryOff as Any,
                    "dailyMilkAverage": cowToUse!.dailyMilkAverage as Any,
                    "parity": cowToUse!.parity as Any,
                    "reproductionStatus": cowToUse!.reproductionStatus as Any,
                    "numberOfTimesBred": cowToUse!.numberTimesBred as Any,
                    "farmBreedingIndex": cowToUse!.farmBreedingIndex as Any,
                    "lactationNumber": cowToUse!.lactationNumber as Any,
                    "daysCarriedCalfIfPregnant": cowToUse!.daysCarriedCalfIfPregnant as Any,
                    "projectedDueDate": cowToUse!.projectedDueDate as Any,
                    "current305DayMilk": cowToUse!.current305DayMilk as Any,
                    "currentSomaticCellCount": cowToUse!.currentSomaticCellCount as Any,
                    "linearScoreAtLastTest": cowToUse!.linearScoreAtLastTest as Any,
                    "dateOfLastClinicalMastitis": cowToUse!.dateOfLastClinicalMastitis as Any,
                    "chainVisibleId": cowToUse!.chainVisibleID as Any,
                    "animalRegistrationNoNLID": cowToUse!.animalRegistrationNoNLID as Any,
                    "damBreed": cowToUse!.damBreed as Any,
                    "culled": 1,
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
                                    self.fetchSavedData()
                                    
                                    return //return from function - end sync
                                }
                            }
                        }
                
                    }
                
                    task.resume()
                
            }))
        }
        else if(cowToUse?.culled == "1"){
            selectedRowAlert.addAction(UIAlertAction(title: "Set as Non-Culled", style: .default, handler: { action in
                
                //Build HTTP Request
                var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/cow-update")!) //sync route on the server
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-type")
                request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                request.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
                
                //build JSON Body
                var jsonCowObject = [String: Any]()
                
                                    
                jsonCowObject = [
                    "objectType": "Cow" as Any,
                    "herdID": cowToUse!.herd?.id as Any,
                    "id": cowToUse!.id as Any,
                    "daysInMilk": cowToUse!.daysInMilk as Any,
                    "dryOffDay": cowToUse!.dryOffDay as Any,
                    "mastitisHistory": cowToUse!.mastitisHistory as Any,
                    "methodOfDryOff": cowToUse!.methodOfDryOff as Any,
                    "dailyMilkAverage": cowToUse!.dailyMilkAverage as Any,
                    "parity": cowToUse!.parity as Any,
                    "reproductionStatus": cowToUse!.reproductionStatus as Any,
                    "numberOfTimesBred": cowToUse!.numberTimesBred as Any,
                    "farmBreedingIndex": cowToUse!.farmBreedingIndex as Any,
                    "lactationNumber": cowToUse!.lactationNumber as Any,
                    "daysCarriedCalfIfPregnant": cowToUse!.daysCarriedCalfIfPregnant as Any,
                    "projectedDueDate": cowToUse!.projectedDueDate as Any,
                    "current305DayMilk": cowToUse!.current305DayMilk as Any,
                    "currentSomaticCellCount": cowToUse!.currentSomaticCellCount as Any,
                    "linearScoreAtLastTest": cowToUse!.linearScoreAtLastTest as Any,
                    "dateOfLastClinicalMastitis": cowToUse!.dateOfLastClinicalMastitis as Any,
                    "chainVisibleId": cowToUse!.chainVisibleID as Any,
                    "animalRegistrationNoNLID": cowToUse!.animalRegistrationNoNLID as Any,
                    "damBreed": cowToUse!.damBreed as Any,
                    "culled": 0,
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
                                    self.fetchSavedData()
                                    
                                    return //return from function - end sync
                                }
                            }
                        }
                
                    }
                
                    task.resume()
                
            }))
        }
            
            
            
        selectedRowAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        selectedRowAlert.addAction(UIAlertAction(title: "Delete Cow", style: .destructive, handler: { action in
            let confirmationAlert = UIAlertController(title: tableView.cellForRow(at: indexPath)?.textLabel?.text, message: "Delete Cow?", preferredStyle: .alert)
            
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
                
                var backupRequest = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user-cow-delete-app?userID=" + KeychainWrapper.standard.string(forKey: "User-ID-Token")! + "&herdID=" + (self.selectedHerd?.id)! as String + "&cowID=" + ((cowToUse?.id)!))!)
                backupRequest.httpMethod = "GET"
                backupRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
                backupRequest.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
                backupRequest.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
                
                let backupTask = URLSession.shared.dataTask(with: backupRequest) { data, response, error in
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
            self.herdLogbook?.menuView?.getTestPageView().getTestPages()[0].setHerd(herd: selectedHerd)
            self.herdLogbook?.menuView?.getTestPageView().getTestPages()[0].setCow(cow: cowToUse)
            //pop back 2 view controllers to runTestViewController
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
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
        filteredCows = cowList.filter({( cow : Cow) -> Bool in
            return cow.id!.contains(searchText)
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
    //getters/setters
    
    public func setSelectedHerd(herd: Herd?){
        self.selectedHerd = herd
    }
    
    public func getSelectedHerd() -> Herd{
        return selectedHerd!
    }
    
    public func addToCowList(cowToAppend: Cow){
        cowList.append(cowToAppend)
    }
    
    public func getCowList() -> [Cow]{
        return cowList
    }
    
    public func getTestLogbookView() -> TestLogbookViewController{
        return testLogbook!
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
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
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
    
    public func setSelectingCowFromList(select: Bool){
        self.selectingFromList = select
    }
    
}
