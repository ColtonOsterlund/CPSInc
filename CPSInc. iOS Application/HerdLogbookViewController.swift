//
//  LogbookViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-26.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreData
import SwiftyDropbox
import UserNotifications

public class HerdLogbookViewController: UITableViewController, WCSessionDelegate {
    
    private var herdList = [Herd]()
    
    //ViewControllers
    private var menuView: MenuViewController? = nil
    private var cowLogbook: CowLogbookViewController? = nil
    private var herdInfoView: HerdInfoViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var addHerdView: AddHerdViewController? = nil
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    //dropbox client
    private var dropboxClient: DropboxClient? = nil
    
    //UIBarButtonItems
    private var addBtn = UIBarButtonItem()
    private var importBtn = UIBarButtonItem()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Herd Logbook"
        //view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        setupLayoutItems()
        
        fetchSavedData()
    }
    
    
    private func fetchSavedData(){
        let fetchRequest: NSFetchRequest<Herd> = Herd.fetchRequest()
        
        do{
            let savedHerdArray = try appDelegate?.persistentContainer.viewContext.fetch(fetchRequest)
            self.herdList = savedHerdArray!
        } catch{
            print("Error during fetch request")
        }
        
        tableView.reloadData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        fetchSavedData()
    }
    
    private func setupLayoutItems(){
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "herdTableViewCell")
        
        addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        importBtn = UIBarButtonItem.init(title: "Import", style: .plain, target: self, action: #selector(importBtnPressed))
        
        navigationItem.rightBarButtonItems = [addBtn, importBtn]
        
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
        let importAlert = UIAlertController(title: "Import", message: "Add Files to /App/Creative Protein Solutions Inc./CSV Uploads in Dropbox to Import (only .csv files will appear)", preferredStyle: .actionSheet)
        
        importAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        listFiles.response{ responseList, error in
        
            for entry in responseList!.entries{
                print(entry)
                if(String(entry.name.suffix(4)) == ".csv"){ //check that it is a .csv file
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
            
            //iterate through csvRowArray creating a new cow for each row
            for row in csvRowArray{
                //create new cow
                var cow: Cow? = Cow(context: (self.appDelegate?.persistentContainer.viewContext)!)
                //separate row into cow attribute array
                let cowAttributeArray = row.components(separatedBy: ",")
                
                //itterate through cowAttributeArray keeping track of the index to compare with the header values to know where to place the attribute
                for (index, attribute) in cowAttributeArray.enumerated(){
                    //switch through the header values to know where to place the attribute
                    switch(csvHeaderColumnArray[index]){
                        case "id":
                            cow!.id = attribute
                        case "days in milk":
                            cow!.daysInMilk = attribute
                        case "dry off day":
                            cow!.dryOffDay = attribute
                        case "mastitis history":
                            cow!.mastitisHistory = attribute
                        case "dry off":
                            cow!.methodOfDryOff = attribute
                        case "name":
                            cow!.name = attribute
                        case "parity":
                            cow!.parity = attribute
                        case "reproduction status":
                            cow!.reproductionStatus = attribute
                        default:
                            break
                    }
                }
                
                cow!.herd = importedHerd
                
                if(bytes >= 8000){ //find actual number that this would be beneficial - SAVES STACK MEMORY
                    self.appDelegate?.saveContext() //saves cow to disk memory
                    cow = nil //removes cow from stack memory
                }
                
            }
            
            if(bytes < 8000){ //find actual number that this would be beneficial - SAVES EXECUTION TIME
                self.appDelegate?.saveContext() //saves all cows that were created in memory to context
            }
            
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
        
        fetchSavedData()
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
        return herdList.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "herdTableViewCell", for: indexPath)
//        let peripheral = peripheralDevices[indexPath.row]
//        cell.textLabel?.text = peripheral.name
        cell.textLabel?.text = "Herd ID: " + herdList[indexPath.row].id!
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowAlert = UIAlertController(title: tableView.cellForRow(at: indexPath)?.textLabel?.text, message: "Please Select One of the Following", preferredStyle: .actionSheet) //actionSheet shows on the bottom of the screen while alert comes up in the middle
        
        selectedRowAlert.addAction(UIAlertAction(title: "Herd Info", style: .default, handler: { action in
            self.herdInfoView?.setSelectedHerd(herd: self.herdList[indexPath.row])
            self.navigationController?.pushViewController(self.herdInfoView!, animated: true)
        }))
        selectedRowAlert.addAction(UIAlertAction(title: "Cow Listing", style: .default, handler: { action in

                self.cowLogbook!.setSelectedHerd(herd: self.herdList[indexPath.row])
                self.navigationController?.pushViewController(self.cowLogbook!, animated: true)
            
        }))
        selectedRowAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        selectedRowAlert.addAction(UIAlertAction(title: "Delete Herd", style: .destructive, handler: { action in
            let confirmationAlert = UIAlertController(title: tableView.cellForRow(at: indexPath)?.textLabel?.text, message: "Delete Herd?", preferredStyle: .alert)
            
            confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                //delete all Cow records associated with that Herd in the database
                let fetchCowDeletionRequest: NSFetchRequest<Cow> = Cow.fetchRequest()
                fetchCowDeletionRequest.predicate = NSPredicate(format: "herd == %@", self.herdList[indexPath.row]) //get all cows associated with the herd being deleted
                
                do{
                    let fetchedCowArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchCowDeletionRequest)
                    
                    //delete all cows that return from the search
                    for cowToDelete in fetchedCowArray!{
                        
                        let fetchTestDeletionRequest: NSFetchRequest<Test> = Test.fetchRequest()
                        fetchTestDeletionRequest.predicate = NSPredicate(format: "cow == %@", cowToDelete) //get all cows associated with the herd being deleted
                        
                        do{
                            let fetchedTestArray = try self.appDelegate?.persistentContainer.viewContext.fetch(fetchTestDeletionRequest)
                            
                            for testToDelete in fetchedTestArray! {
                                self.appDelegate?.persistentContainer.viewContext.delete(testToDelete)
                            }
                        }
                        catch{
                            print("Error during fetch request")
                        }
                        
                        
                         self.appDelegate?.persistentContainer.viewContext.delete(cowToDelete)
                    }

                } catch{
                    print("Error during fetch request")
                }
                
                
                //Delete Herd record from database
                self.appDelegate?.persistentContainer.viewContext.delete(self.herdList[indexPath.row])
                self.appDelegate?.saveContext() //save context after element is deleted
                self.fetchSavedData()
                
            }))
            
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(confirmationAlert, animated: true)
            
        }))
        
        
        self.present(selectedRowAlert, animated: true)
        
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
}
