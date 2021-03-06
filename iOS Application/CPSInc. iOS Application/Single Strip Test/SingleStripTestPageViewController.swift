import Foundation
import UIKit
import WatchConnectivity
import CoreBluetooth


public class SingleStripTestPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CBPeripheralDelegate {

    //BLUETOOTH DATA
    private var centralManager: CBCentralManager? = nil
    private var peripheralDevice: CBPeripheral? = nil
    private var stripDetectVoltageCharacteristic: CBCharacteristic? = nil
    private var integratedVoltageCharacteristic: CBCharacteristic? = nil
    private var differentialVoltageCharacterisitc: CBCharacteristic? = nil
    private var startTestCharacteristic: CBCharacteristic? = nil
    private var stripDetectVoltageValue: Int? = nil
    private var integratedVoltageValue: Int? = nil
    private var differentialVoltageValue: Int? = nil
    
    
    
    private var menuView: MenuViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var wcSession: WCSession? = nil
    
    let initialPage = 0
    
    var pages = [SingleStripTestViewController]()
    let pageControl = UIPageControl()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Test"
        
        
        
        self.dataSource = self
        self.delegate = self
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.05)).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.1).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1).isActive = true
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = pages.firstIndex(of: viewController as! SingleStripTestViewController)!
        if(currentIndex == 0){
            return nil
        }
        
        return pages[currentIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = pages.firstIndex(of: viewController as! SingleStripTestViewController)!
        if(currentIndex == pages.count - 1){
            return nil
        }
        
        return pages[currentIndex + 1]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.firstIndex(of: pageContentViewController as! SingleStripTestViewController)!
    }

    
    
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        //print("discovering servies")
        
        for service in peripheral.services! {
            
            //print("Service found with UUID: " + service.uuid.uuidString)
            
            //device information service
            if (service.uuid.uuidString == "180A") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //GAP (Generic Access Profile) for Device Name
            // This replaces the deprecated CBUUIDGenericAccessProfileString
            if (service.uuid.uuidString == "1800") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //Custom Service
            if (service.uuid.uuidString == "FE283188-48DF-4A0C-8A52-8F05AEC9E4C1") { //this is the CBUUID for our custom GATT Votlage service
                
                print("discovered custom service")
                
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            if (service.uuid.uuidString == "1D14D6EE-FD63-4FA1-BFA4-8F47B42119F0") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //get device name
        
        //print("discovering characteristics")
        
        if (service.uuid.uuidString == "1800") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A00") {
                    peripheral.readValue(for: characteristic)
                    //print("Found Device Name Characteristic")
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == "180A") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A29") {
                    peripheral.readValue(for: characteristic)
                    print("Found a Device Manufacturer Name Characteristic")
                    //appDelegate!.addToPeripheralWhitelist(modelNumberToAdd: String(decoding: characteristic.value!, as: UTF8.self))
                } else if (characteristic.uuid.uuidString == "2A23") {
                    peripheral.readValue(for: characteristic)
                    print("Found System ID")
                    //appDelegate!.addToPeripheralWhitelist(modelNumberToAdd: String(decoding: characteristic.value!, as: UTF8.self))
                }
                else if (characteristic.uuid.uuidString == "2A24"){
                    peripheral.readValue(for: characteristic)
                    print("Found Model Number Characteristic")
                    //we now do the below with a service UUID so that it can be seen without having to connect
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
//                        print(characteristic.value)
//                        self.appDelegate!.addToPeripheralWhitelist(modelNumberToAdd: String(decoding: characteristic.value!, as: UTF8.self))
//                    }
                    
                    //print(self.appDelegate!)
                    //appDelegate!.addToPeripheralWhitelist(modelNumberToAdd: String(decoding: characteristic.value!, as: UTF8.self))
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == "FE283188-48DF-4A0C-8A52-8F05AEC9E4C1") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "646B19C6-F66D-4CC2-B2FE-8EFDC1E2CC1F") { //stripDetectVoltageCharacteristic
                    //we'll save the reference, we need it to write data
                    stripDetectVoltageCharacteristic = characteristic
                    
                    //print(characteristic.value) - this prints null also
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("found strip detect voltage charac")
                }
                
                if (characteristic.uuid.uuidString == "57D8F270-B6DC-4AE7-B23D-D15C36B6ED5D") { //integratedVoltageCharacteristic
                    //we'll save the reference, we need it to write data
                    integratedVoltageCharacteristic = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("found integrated voltage charac")
                }
                
                if (characteristic.uuid.uuidString == "215CBB55-C71C-42A8-BB41-066696B1AFF1") { //differentialVoltageCharacteristic
                    //we'll save the reference, we need it to write data
                    differentialVoltageCharacterisitc = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("found differential voltage charac")
                }
                
                if (characteristic.uuid.uuidString == "3DC78DC9-AEB6-4596-8D1B-FA76D76D5EA1") { //capacitorDischargeCharacteristic
                    //we'll save the reference, we need it to write data
                    startTestCharacteristic = characteristic
                    
                    //print(characteristic.value) - this prints null also
                    
                    print("found capacitor discharge charac")
                }
                
                if (characteristic.uuid.uuidString == "9F8E337A-5E94-4916-B725-3C1570B4C425") { //capacitorDischargeCharacteristic
                    //we'll save the reference, we need it to write data
                    peripheral.readValue(for: characteristic)
                    print("found device id charac")
                }
                
            }
            
        }
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (characteristic.uuid.uuidString == "646B19C6-F66D-4CC2-B2FE-8EFDC1E2CC1F") { //strip detect voltage
            if(characteristic.value != nil) {
                let stringValue = characteristic.value!.hexEncodedString()
                stripDetectVoltageValue = Int(exactly: Int(stringValue, radix: 16)!)
                //print(stripDetectVoltageValue!)
            }
        }
        else if(characteristic.uuid.uuidString == "57D8F270-B6DC-4AE7-B23D-D15C36B6ED5D"){ //integrated voltage
            if(characteristic.value != nil) {
                let stringValue = characteristic.value!.hexEncodedString()
                integratedVoltageValue = Int(exactly: Int(stringValue, radix: 16)!)
                //print("integrated vol = " + integratedVoltageValue!)
            }
        }
        else if(characteristic.uuid.uuidString == "215CBB55-C71C-42A8-BB41-066696B1AFF1"){ //differential voltage
            if(characteristic.value != nil) {
                let stringValue = characteristic.value!.hexEncodedString()
                differentialVoltageValue = Int(exactly: Int(stringValue, radix: 16)!)
                //print("differential vol = " + differentialVoltageValue!)
            }
        }
    }
    
    
    
    //getters/setters
    
    public func addPage(pageToAdd: SingleStripTestViewController?){
        //give the page a pageID unique to all the other pages
        var id: Int? = 0
        var idCleared = false
        while(!idCleared){
            idCleared = true
            for page in pages{
                if(page.getPageID()! == id!){
                    id! += 1
                    idCleared = false
                }
            }
        }
        
        pageToAdd?.setPageID(id: id)
        
        pages.append(pageToAdd!)
        pageControl.numberOfPages = pages.count
        //setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    public func setAppDelegate(appDelegate: AppDelegate?){
        print("setting app delegate")
        print(appDelegate!)
        self.appDelegate = appDelegate;
        print(self.appDelegate!)
    }
    
    public func removePage(pageIndexToRemove: Int){
        pages.remove(at: pageIndexToRemove)
        pageControl.numberOfPages = pages.count
    }
    
    public func getTestPages() -> [SingleStripTestViewController]{
        return pages
    }
    
    
    public func setCentralManager(centralManager: CBCentralManager){
        self.centralManager = centralManager
    }
    
    public func getCentralManager() -> CBCentralManager{
        return centralManager!
    }
    
    public func setPeripheralDevice(periphDevice: CBPeripheral?){
        self.peripheralDevice = periphDevice
        for page in pages{
            page.setPeripheralDevice(periphDevice: periphDevice)
        }
    }
    
    public func getPeripheralDevice() -> CBPeripheral?{
        return peripheralDevice
    }
    
    public func getStripDetectVoltageValue() -> Int?{
        return stripDetectVoltageValue
    }
    
    public func getIntegratedVoltageValue() -> Int?{
        return integratedVoltageValue
    }
    
    public func getDifferentialVoltageValue() -> Int?{
        return differentialVoltageValue
    }
    
    public func setStripDetectVoltageValue(value: Int?){
        self.stripDetectVoltageValue = value
    }
    
    public func setIntegratedVoltageValue(value: Int?){
        self.integratedVoltageValue = value
    }
    
    public func setDifferentialVoltageValue(value: Int?){
        self.differentialVoltageValue = value
    }
    
    public func getStartTestCharacteristic() -> CBCharacteristic{
        return startTestCharacteristic!
    }

    
}
