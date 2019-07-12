//
//  CowLogbookViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-26.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreData

public class CowLogbookViewController: UITableViewController, WCSessionDelegate {
    
    private var selectedHerd: Herd? = nil
    private var cowList = [Cow]()
    
    private var herdLogbook: HerdLogbookViewController? = nil
    private var testLogbook: TestLogbookViewController? = nil
    private var cowInfoView: CowInfoViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var addCowView: AddCowViewController? = nil
    
    
    //UIBarButtonItems
    private var addBtn = UIBarButtonItem()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cow Logbook"
        //view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        setupLayoutItems()
        
        fetchSavedData()
    }
    
    private func fetchSavedData(){
        let fetchRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "herd == %@", self.selectedHerd!) //list the cows from the selected herd
        
        do{
            let savedCowArray = try appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
            self.cowList = savedCowArray!
        } catch{
            print("Error during fetch request")
        }
        
        //IMPLEMENT SORTING ALGORITHM TO SORT COWS BY ID - NOT ALWAYS NECESSARILY SAVED IN ORDER IF USING THE EXECUTION TIME SAIVNG METHOD OF PARSING DATA
        
        tableView.reloadData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        fetchSavedData()
    }
    
    
    private func setupLayoutItems(){
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cowTableViewCell")
        
        addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
     
        navigationItem.rightBarButtonItems = [addBtn]
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
        return cowList.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cowTableViewCell", for: indexPath)
        //        let peripheral = peripheralDevices[indexPath.row]
        //        cell.textLabel?.text = peripheral.name
        cell.textLabel?.text = "Cow ID: " + cowList[indexPath.row].id!
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowAlert = UIAlertController(title: tableView.cellForRow(at: indexPath)?.textLabel?.text, message: "Please Select One of the Following", preferredStyle: .actionSheet) //actionSheet shows on the bottom of the screen while alert comes up in the middle
        
        selectedRowAlert.addAction(UIAlertAction(title: "Cow Info", style: .default, handler: { action in
             self.cowInfoView!.setSelectedCow(cow: self.cowList[indexPath.row])
            self.navigationController?.pushViewController(self.cowInfoView!, animated: true)
        }))
        selectedRowAlert.addAction(UIAlertAction(title: "Test Listing", style: .default, handler: { action in
            self.testLogbook!.setSelectedCow(cow: self.cowList[indexPath.row])
            self.navigationController?.pushViewController(self.testLogbook!, animated: true)
        }))
        selectedRowAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        selectedRowAlert.addAction(UIAlertAction(title: "Delete Cow", style: .destructive, handler: { action in
            let confirmationAlert = UIAlertController(title: tableView.cellForRow(at: indexPath)?.textLabel?.text, message: "Delete Cow?", preferredStyle: .alert)
            
            confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                //delete all Test records associated with that Cow in the database
                let fetchTestDeletionRequest: NSFetchRequest<Test> = Test.fetchRequest()
                fetchTestDeletionRequest.predicate = NSPredicate(format: "cow == %@", self.cowList[indexPath.row]) //get all cows associated with the herd being deleted
                
                do{
                    let fetchedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchTestDeletionRequest)
                    
                    //delete all cows that return from the search
                    for testToDelete in fetchedTestArray!{
                        self.appDelegate?.persistentContainer.viewContext.delete(testToDelete)
                    }
                    
                } catch{
                    print("Error during fetch request")
                }
                
                
                //Delete Cow record from database
                self.appDelegate?.persistentContainer.viewContext.delete(self.cowList[indexPath.row])
                self.appDelegate?.saveContext() //save context after cow is deleted
                self.fetchSavedData()
                
            }))
            
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(confirmationAlert, animated: true)
            
        }))
        
        
        self.present(selectedRowAlert, animated: true)
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
    
    
}
