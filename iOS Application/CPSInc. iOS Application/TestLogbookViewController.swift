//
//  TestLogbookViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-26.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS TABLE VIEW CONTROLLER DEALS WITH THE TABLE OF TESTS IN THE LOGBOOK

import UIKit
import WatchConnectivity
import CoreData
import SwiftKeychainWrapper

public class TestLogbookViewController: UITableViewController, WCSessionDelegate, UITextFieldDelegate{
    
    private var selectedCow: Cow? = nil
    private var timeFrame: Date? = nil
    private var testList = [Test]()
    
    public var cowLogbook: CowLogbookViewController? = nil
    private var testInfoView: TestInfoViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var testChartView: TestChartViewController? = nil
    
    //UIBarButtonItems
//    private var chartBtn = UIBarButtonItem()
    private var filterBtn = UIBarButtonItem()
    private var graphSelectedBtn = UIBarButtonItem()
    private var cancelSelectionBtn = UIBarButtonItem()
    
    //UIDatePicker
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private var startDate: String? = nil
    private var endDate: String? = nil
    
    var dateTextAlert: UIAlertController? = nil
    
    private var selectingValuesFlag = 0
    
    private var selectedTestResults = [Test]()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Test Logbook"
        //view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        setupLayoutItems()

        
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        fetchSavedData()
    }
    
    
    private func fetchSavedData(){
        DispatchQueue.main.async{
            self.testList.removeAll()
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
        
        var backupRequest = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user-test-app?userID=" + KeychainWrapper.standard.string(forKey: "User-ID-Token")! + "&cowID=" + (selectedCow?.id)! as String + "&herdID=" + (selectedCow?.herd?.id)! as String)!)
        backupRequest.httpMethod = "GET"
        backupRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        backupRequest.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
        backupRequest.setValue(KeychainWrapper.standard.string(forKey: "User-ID-Token"), forHTTPHeaderField: "user-id")
        
        let backupTask = URLSession.shared.dataTask(with: backupRequest) { data, response, error in
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
                        
                        
                        let toSave = Test(context: (self.appDelegate?.persistentContainer.viewContext)!)
                            
                        toSave.cow = self.selectedCow
                        toSave.herd = self.selectedCow?.herd
                        toSave.date = object["date"] as? NSDate
                        toSave.followUpNum = object["followUpNum"] as? NSNumber
                        toSave.milkFever = object["milkFever"] as! Bool
                        toSave.testID = object["testID"] as? String
                        toSave.testType = object["testType"] as? String
                        toSave.units = object["units"] as? String
                        toSave.value = object["value"] as! Float
                            
                        print("HERE TEST: ")
                        
                        
                    }
                    
                    self.testList.sort(by: {$0.testID!.localizedStandardCompare($1.testID!) == .orderedAscending})
                    
                    DispatchQueue.main.async {
                        self.scanningIndicator.stopAnimating()
                        print(self.testList.isEmpty)
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
    
    
    
    private func setupLayoutItems(){
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testTableViewCell")
        
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
        
//        chartBtn = UIBarButtonItem.init(title: "Chart", style: .done, target: self, action: #selector(graphResults))
        filterBtn = UIBarButtonItem.init(title: "Filter", style: .done, target: self, action: #selector(filterResults))
        graphSelectedBtn = UIBarButtonItem.init(title: "Graph Selected", style: .done, target: self, action: #selector(graphFromSelected))
        cancelSelectionBtn = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(cancelSelected))
        
        navigationItem.rightBarButtonItems = [/*chartBtn, */filterBtn]
        
        startDatePicker.datePickerMode = .date
        startDatePicker.tag = 0
        startDatePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
        
        endDatePicker.datePickerMode = .date
        endDatePicker.tag = 1
        endDatePicker.addTarget(self, action: #selector(datePickerChangedValue(sender:)), for: .valueChanged)
    }

    
    public convenience init(cowLogbook: CowLogbookViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.cowLogbook = cowLogbook
        testInfoView = TestInfoViewController(testLogbook: self, appDelegate: appDelegate)
        self.appDelegate = appDelegate
        testChartView = TestChartViewController(testLogbook: self)
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }
    
    @objc private func cancelSelected(){
        DispatchQueue.main.async { //reset bar buttons
            self.navigationItem.rightBarButtonItems =  [/*self.chartBtn, */self.filterBtn]
        }
        
        selectedTestResults.removeAll() //reset selectedTestResults after graphing
        selectingValuesFlag = 0 //reset selected values flag
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
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
    
    @objc private func graphResults(){
        //graph by selected rows or by date span
        let graphingAlert = UIAlertController(title: "Graph Results", message: "Please Select One of the Following", preferredStyle: .actionSheet)
        
        graphingAlert.addAction(UIAlertAction(title: "Graph Selected Results", style: .default, handler: { action in
            self.selectingValuesFlag = 1
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItems = [self.cancelSelectionBtn, self.graphSelectedBtn]
            }
        }))
        
        graphingAlert.addAction(UIAlertAction(title: "Graph Results Between Selected Date/Time", style: .default, handler: { action in
            //show date/time picker to choose inital date, show date/time picker to show final date, fetch all resuts between these two dates and graph those
            //let dateTextAlert = UIAlertController(title: "Graph Results", message: "Select Date Range", preferredStyle: .alert) - declare this globally to be able to graph results
            if(self.dateTextAlert == nil){
            
                self.dateTextAlert = UIAlertController(title: "Graph Results", message: "Select Date Range", preferredStyle: .alert)
            
                self.dateTextAlert?.addTextField{ (textField) in
                    textField.placeholder = "Start Date"
                    textField.inputView = self.startDatePicker
                }
                    self.dateTextAlert?.addTextField{ (textField) in
                    textField.placeholder = "End Date"
                    textField.inputView = self.endDatePicker
                }
            
                self.dateTextAlert?.addAction(UIAlertAction(title: "Generate Graph", style: .default, handler: { action in
                    if(self.startDate == nil && self.endDate == nil){
                        self.showToast(controller: self, message: "Please Select a Start and End Date", seconds: 1)
                    }
                    else if(self.startDate == nil){
                        self.showToast(controller: self, message: "Please Select a Start Date", seconds: 1)
                    }
                    else if(self.endDate == nil){
                        self.showToast(controller: self, message: "Please Select an End Date", seconds: 1)
                    }
                
                    //graph results
                    
                    let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateStyle = DateFormatter.Style.short
                    //dateformatter.timeStyle = DateFormatter.Style.short
                    
                    let startDateString = dateformatter.string(from: self.startDatePicker.date) + ", 12:00 AM"
                    let endDateString = dateformatter.string(from: self.endDatePicker.date) + ", 11:59 PM"
                    
                    print(endDateString)
                    
                    dateformatter.timeStyle = DateFormatter.Style.short
                    
                    let predicateStartDate = NSPredicate(format: "date >= %@", dateformatter.date(from: startDateString)! as NSDate) //need to add times to these dates
                    let predicateEndDate = NSPredicate(format: "date <= %@", dateformatter.date(from: endDateString)! as NSDate)
                    let predicateCow = NSPredicate(format: "cow == %@", self.selectedCow!)
                    let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateStartDate, predicateEndDate, predicateCow])
                        
                    fetchRequest.predicate = fetchPredicate
                    
                    var savedTestArray = [Test]()
                    
                    do{
                        savedTestArray = try (self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest))!
                        //print(savedTestArray![0])
                        
                        self.graphTestResults(testResults: savedTestArray)
                        
                        savedTestArray.removeAll() //reset test array after graphing
                    } catch{
                        print("Error during fetch request")
                    }
                
                }))
            
                self.dateTextAlert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
            }
            
            self.startDatePicker.date = Date() //set to current date
            self.endDatePicker.date = Date() //set to current date
            self.dateTextAlert?.textFields![0].text = "" //clear textField
            self.dateTextAlert?.textFields![1].text = "" //cear textField
            self.present(self.dateTextAlert!, animated: true)
        }))
        
        graphingAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(graphingAlert, animated: true)
        
    }
    
    
    
    @objc private func graphFromSelected(){
        DispatchQueue.main.async { //reset bar buttons
            self.navigationItem.rightBarButtonItems =  [/*self.chartBtn, */self.filterBtn]
        }
        
        self.graphTestResults(testResults: selectedTestResults)
        
        selectedTestResults.removeAll() //reset selectedTestResults after graphing
        selectingValuesFlag = 0 //reset selected values flag
    }
    
    
    
    
    private func graphTestResults(testResults: [Test]){
        testChartView!.setTestList(testList: testResults)
        navigationController?.pushViewController(testChartView!, animated: true)
    }
    
    
    
    
    
    
    
    @objc private func filterResults(){
        let filterResultAlert = UIAlertController(title: "Filter Results", message: "Please Select One of the Following", preferredStyle: .actionSheet) //actionSheet shows on the bottom of the screen while alert comes up in the middle
        
        filterResultAlert.addAction(UIAlertAction(title: "Immunoglobulins", style: .default, handler: { action in
            let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
            
            let predicateCow = NSPredicate(format: "cow == %@", self.selectedCow!)
            let predicateType = NSPredicate(format: "testType == %@", "Immunoglobulins")
            let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateCow, predicateType])
            
            fetchRequest.predicate = fetchPredicate
            
            do{
                let savedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
                self.testList = savedTestArray!
            } catch{
                print("Error during fetch request")
            }
            
            self.tableView.reloadData()
        }))
        
        filterResultAlert.addAction(UIAlertAction(title: "Lactoferrin", style: .default, handler: { action in
            let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
            
            let predicateCow = NSPredicate(format: "cow == %@", self.selectedCow!)
            let predicateType = NSPredicate(format: "testType == %@", "Lactoferrin")
            let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateCow, predicateType])
            
            fetchRequest.predicate = fetchPredicate
            
            do{
                let savedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
                self.testList = savedTestArray!
            } catch{
                print("Error during fetch request")
            }
            
            self.tableView.reloadData()
        }))
        
        filterResultAlert.addAction(UIAlertAction(title: "Blood Calcium", style: .default, handler: { action in
            let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
            
            let predicateCow = NSPredicate(format: "cow == %@", self.selectedCow!)
            let predicateType = NSPredicate(format: "testType == %@", "Blood Calcium")
            let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateCow, predicateType])
            
            fetchRequest.predicate = fetchPredicate
            
            do{
                let savedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
                self.testList = savedTestArray!
            } catch{
                print("Error during fetch request")
            }
            
            self.tableView.reloadData()
        }))
        
        filterResultAlert.addAction(UIAlertAction(title: "Glucose", style: .default, handler: { action in
            let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
            
            let predicateCow = NSPredicate(format: "cow == %@", self.selectedCow!)
            let predicateType = NSPredicate(format: "testType == %@", "Glucose")
            let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateCow, predicateType])
            
            fetchRequest.predicate = fetchPredicate
            
            do{
                let savedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
                self.testList = savedTestArray!
            } catch{
                print("Error during fetch request")
            }
            
            self.tableView.reloadData()
        }))
        
        filterResultAlert.addAction(UIAlertAction(title: "All Tests", style: .default, handler: { action in
            let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "cow == %@", self.selectedCow!) //list the tests from the selected cow
            
            do{
                let savedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
                self.testList = savedTestArray!
            } catch{
                print("Error during fetch request")
            }
            
           self.tableView.reloadData()
        }))
        
        self.present(filterResultAlert, animated: true)
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
        return testList.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testTableViewCell", for: indexPath)
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        
        
        cell.textLabel?.text = dateformatter.string(from: testList[indexPath.row].date! as Date)
        
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // if(tableView.cellForRow(at: indexPath)?.isSelected == false){ //cannot select a row twice
            if(selectingValuesFlag == 0){
                tableView.allowsMultipleSelection = false
                self.testInfoView!.setSelectedTest(test: self.testList[indexPath.row])
                self.navigationController?.pushViewController(self.testInfoView!, animated: true)
            }
            else{
                tableView.allowsMultipleSelection = true
                selectedTestResults.append(testList[indexPath.row])
            }
       // }
        
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(selectingValuesFlag == 1){
           var index = 0
            for test in selectedTestResults{
                if(test == testList[indexPath.row]){
                    selectedTestResults.remove(at: index)
                }
                index += 1
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
    
    
    
    //getters/setters
    public func setSelectedCow(cow: Cow?){
        self.selectedCow = cow
    }
    
    public func getSelectedCow() -> Cow{
        return selectedCow!
    }
    
    public func getTestList() -> [Test]{
        return testList
    }
    
    public func setTimeFrame(date: Date?){
        self.timeFrame = date
    }
    
}
