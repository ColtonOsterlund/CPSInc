//
//  TestLogbookViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-26.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreData

public class TestLogbookViewController: UITableViewController, WCSessionDelegate {
    
    private var selectedCow: Cow? = nil
    private var testList = [Test]()
    
    private var cowLogbook: CowLogbookViewController? = nil
    private var testInfoView: TestInfoViewController? = nil
    private var appDelegate: AppDelegate? = nil
    
    //UIBarButtonItems
    private var addBtn = UIBarButtonItem()
    private var chartBtn = UIBarButtonItem()
    private var filterBtn = UIBarButtonItem()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Test Logbook"
        //view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        setupLayoutItems()
        
        fetchSavedData()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        fetchSavedData()
    }
    
    
    private func fetchSavedData(){
        let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cow == %@", self.selectedCow!) //list the tests from the selected cow
        
        do{
            let savedTestArray = try appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
            self.testList = savedTestArray!
        } catch{
            print("Error during fetch request")
        }
        
        tableView.reloadData()
    }
    
    
    
    private func setupLayoutItems(){
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testTableViewCell")
        
        addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        chartBtn = UIBarButtonItem.init(title: "Chart", style: .done, target: self, action: #selector(graphResults))
        filterBtn = UIBarButtonItem.init(title: "Filter", style: .done, target: self, action: #selector(filterResults))
        
        navigationItem.rightBarButtonItems = [addBtn, chartBtn, filterBtn]
    }

    
    public convenience init(cowLogbook: CowLogbookViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.cowLogbook = cowLogbook
        testInfoView = TestInfoViewController(testLogbook: self, appDelegate: appDelegate)
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
    
    @objc private func graphResults(){
        //graph by selected rows or by date span
        let graphingAction = UIAlertController(title: "Graph Results", message: "Please Select One of the Following", preferredStyle: .actionSheet)
        
        graphingAction.addAction(UIAlertAction(title: "Graph Selected Results", style: .default, handler: { action in
            //fill out
        }))
        
        graphingAction.addAction(UIAlertAction(title: "Graph Results Between Selected Date/Time", style: .default, handler: { action in
            //fill out
        }))
        
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
    
    
    @objc private func addBtnPressed(){
        //fill out
        //RUN TEST STRAIGHT FROM COW RECORD IN LOGBOOK
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
        //        let peripheral = peripheralDevices[indexPath.row]
        //        cell.textLabel?.text = peripheral.name
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        
        
        cell.textLabel?.text = dateformatter.string(from: testList[indexPath.row].date! as Date) + " | " + testList[indexPath.row].dataType!
        
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.testInfoView!.setSelectedTest(test: testList[indexPath.row])
        self.navigationController?.pushViewController(self.testInfoView!, animated: true)
    }
    
    
    
    //getters/setters
    public func setSelectedCow(cow: Cow?){
        self.selectedCow = cow
    }
    
    public func getSelectedCow() -> Cow{
        return selectedCow!
    }
    
    
}
