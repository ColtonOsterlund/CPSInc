//
//  MenuView.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-05-24.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE MAIN MENU VIEW OF THE APPLICATION

import UIKit
import CoreBluetooth
import WatchConnectivity
import SwiftKeychainWrapper
import CoreGraphics
import MobileBuySDK

public class MenuViewController: UIViewController, CBCentralManagerDelegate, WCSessionDelegate{
    
    //scrolling
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    //Views
    private var connectView: ConnectViewController? = nil
    private var testView: /*OriginalTestViewController?*/ SingleStripTestViewController? = nil
    private var settingsView: SettingsViewControllerV2? = nil
    private var logbookView: HerdLogbookViewController? = nil
    private var instructionsView: InstructionPageViewController? = nil
    private var loginView: LoginViewController? = nil
    private var accountView: AccountPageViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var testPageController: /*OriginalTestPageViewController?*/ SingleStripTestPageViewController? = nil
    private var shopView: ShopifyStorePagesViewController? = nil
    private var recommendationView: RecommendationPageViewController? = nil
    
    //UIButtons
    //private let findDeviceBtn = UIButton()
    private let testBtn = UIButton()
    private let settingsBtn = UIButton()
    private let logbookBtn = UIButton()
    private let accountBtn = UIButton()
    private let shopBtn = UIButton()
    private let recommendationBtn = UIButton()
    private let correlationBtn = UIButton()
    
    //UIBarButtons
    private var instructionBtn = UIBarButtonItem()
    private var findDeviceBtn = UIBarButtonItem()
    
    //UIImages
    //private let findDeviceBtnImage = UIImage(named: "device")
    private let testBtnImage = UIImage(named: "bloodDropCartoonImage")
    private let settingsBtnImage = UIImage(named: "settingsWheel")
    private let logbookBtnImage = UIImage(named: "logbook")
    private let accountBtnImage = UIImage(named: "userLOGO")
    private let shopBtnImage = UIImage(named: "shoppingCart")
    private let greenCircleImage = UIImage(named: "green_circle")
    private let redCircleImage = UIImage(named: "red_circle")
    private let recommendationBtnImage = UIImage(named: "recommendationLOGO")
    private let correlationBtnImage = UIImage(named: "calculator")
    
    
    //UILabels
    private let findDeviceLabel = UILabel()
    private let testLabel = UILabel()
    private let settingsLabel = UILabel()
    private let logbookLabel = UILabel()
    private let logoLabel = UILabel()
    private let accountLabel = UILabel()
    private let shopLabel = UILabel()
    private let recommendationLabel = UILabel()
    private let correlationLabel = UILabel()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    //UITextViews for hyper link
    let attributedString = NSMutableAttributedString(string: "Visit Website")
    let url = URL(string: "https://creativeproteinsolutions.com")!
    let hyperlinkTextView = UITextView()
    
    
    //Bluetooth Data
    private var centralManager: CBCentralManager? = nil
    private var peripheralDevice: CBPeripheral? = nil
    private var stripDetectVoltageCharacteristic: CBCharacteristic? = nil
    private var differentialVoltageCharacteristic: CBCharacteristic? = nil
    private var integratedVoltageCharacteristic: CBCharacteristic? = nil
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    //Buy SDK client
    let client = Graph.Client(shopDomain: "creative-protein-solutions.myshopify.com", apiKey: "28893d9e78d310dde27dde211fa414d7")
    
    
    private var inQueueView = 0
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        //think these have to be here because it said the property initialization (global vars) are initialized before this init() function so self is not ready yet at that point
        connectView = ConnectViewController(menuView: self, appDelegate: appDelegate)
        testPageController = /*OriginalTestPageViewController*/SingleStripTestPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        testPageController?.setAppDelegate(appDelegate: appDelegate)
        testView = /*OriginalTestViewController(menuView: self, appDelegate: appDelegate, testPageController: testPageController)*/SingleStripTestViewController(appDelegate: appDelegate, menuView: self, testPageController: testPageController)
        settingsView = SettingsViewControllerV2(menuView: self, appDelegate: appDelegate)
        logbookView = HerdLogbookViewController(menuView: self, appDelegate: appDelegate)
        shopView = ShopifyStorePagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        shopView!.setMenuView(menuView: self)
        instructionsView = InstructionPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        accountView = AccountPageViewController(appDelegate: appDelegate, menuView: self)
        loginView = LoginViewController(appDelegate: appDelegate, accountView: accountView, menuView: self, storeView: shopView)
        recommendationView = RecommendationPageViewController(appDelegate: appDelegate, menuView: self)
        self.appDelegate = appDelegate
        testPageController?.addPage(pageToAdd: testView)
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        //if WCSession is supported by the device set up wcSession - when both sessions are open, they can communicate, when only one session is open - it may still send updates and transfer files, but those transferes happen opportunistically in the background (open the session on the phone side when the phone app is initially started)
        if(wcSession != nil){
            connectView!.setWCSession(session: self.wcSession!)
            //testView!.setWCSession(session: self.wcSession!)
            settingsView!.setWCSession(session: self.wcSession!)
            logbookView!.setWCSession(session: self.wcSession!)
        }
        
        createLayoutItems()
        setLayoutConstraints()
        setButtonListeners()
    
        //let bluetoothQueue: DispatchQueue = DispatchQueue(label: "bluetooth queue", attributes: .concurrent) //apparently cannot use a dispatch queue since UITableView MUST be updated from the main thread
        centralManager = CBCentralManager(delegate: self, queue: nil) //central manager for bluetooth connectivity
        
        //centralManager delegate can be set to connectView right away as nothing from menuView does anything with it before a device is connected (I believe) - this is redone when findDevice button is pressed for the sake of leaving it there in case this crashes and burns
        centralManager?.delegate = connectView //make connectView the delegate for centralManager
        connectView!.setCentralManager(centralManager: self.centralManager!)
        
        
        //this was used for if wanting to switch to a view controller from something that was not the menu, it would set it to the next inQueue view to not mess up the navigationController stack, this is not being used anymore i dont believe
        if(inQueueView == 0){
            //do nothing
        }
        else if(inQueueView == 1){
            DispatchQueue.main.async{
                self.findDeviceBtnPressed()
            }
            
            inQueueView = 0
        }
        else if(inQueueView == 2){
            DispatchQueue.main.async{
                self.testBtnPressed()
            }
            
            inQueueView = 0
        }
        else{
            DispatchQueue.main.async{
                self.settingsBtnPressed()
            }
            
            inQueueView = 0
        }
        
        
        //USE TO FIND THE FOLDER CONTAINING THE .sqlite DATABASE
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        //to print module name for heavyweight migration
        //print(NSStringFromClass(HerdToHerdV1ToV2CustomPolicy.self).components(separatedBy:".")[0])
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //complete this - called when central device updates bluetooth state
    }
    
    private func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        //complete this - called when peripheral device updates bluetooth state
    }
    
    private func createLayoutItems(){ //play with layout of buttons
        
        scrollView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.4)
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        contentView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        scrollView.addSubview(contentView)
        
        
        //findDeviceBtn.setBackgroundImage(findDeviceBtnImage, for: .normal)
        //contentView.addSubview(findDeviceBtn)
        
//        findDeviceLabel.text = "Find a Device"
//        findDeviceLabel.textColor = .black
//        findDeviceLabel.textAlignment = .center
//        contentView.addSubview(findDeviceLabel)
        
        testBtn.setBackgroundImage(testBtnImage, for: .normal)
        contentView.addSubview(testBtn)
        
        testLabel.text = "Run a Test"
        testLabel.textColor = .black
        testLabel.textAlignment = .center
        contentView.addSubview(testLabel)
        
        settingsBtn.setBackgroundImage(settingsBtnImage, for: .normal)
        contentView.addSubview(settingsBtn)
        
        settingsLabel.text = "Configure Settings"
        settingsLabel.textColor = .black
        settingsLabel.textAlignment = .center
        contentView.addSubview(settingsLabel)
        
        logbookBtn.setBackgroundImage(logbookBtnImage, for: .normal)
        contentView.addSubview(logbookBtn)
        
        logbookLabel.text = "Logbook"
        logbookLabel.textColor = .black
        logbookLabel.textAlignment = .center
        contentView.addSubview(logbookLabel)
        
        correlationBtn.setBackgroundImage(correlationBtnImage, for: .normal)
        contentView.addSubview(correlationBtn)
        
        correlationLabel.text = "Analysis"
        correlationLabel.textColor = .black
        correlationLabel.textAlignment = .center
        contentView.addSubview(correlationLabel)
        
        logoLabel.text = "Creative Protein Solutions Inc."
        logoLabel.textColor = .black
        logoLabel.textAlignment = .center
        logoLabel.font = logoLabel.font.withSize(25)
        contentView.addSubview(logoLabel)
        
        accountBtn.setBackgroundImage(accountBtnImage, for: .normal)
        contentView.addSubview(accountBtn)
        
        accountLabel.text = "Account"
        accountLabel.textColor = .black
        accountLabel.textAlignment = .center
        contentView.addSubview(accountLabel)
        
        shopBtn.setBackgroundImage(shopBtnImage, for: .normal)
        contentView.addSubview(shopBtn)
        
        shopLabel.text = "Store"
        shopLabel.textColor = .black
        shopLabel.textAlignment = .center
        contentView.addSubview(shopLabel)
        
        recommendationBtn.setBackgroundImage(recommendationBtnImage, for: .normal)
        contentView.addSubview(recommendationBtn)
        
        recommendationLabel.text = "Tx Recommendations"
        recommendationLabel.textColor = .black
        recommendationLabel.textAlignment = .center
        contentView.addSubview(recommendationLabel)
        
        
        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url], range: NSMakeRange(0, 13))
        hyperlinkTextView.attributedText = attributedString
        hyperlinkTextView.isUserInteractionEnabled = true
        hyperlinkTextView.isEditable = false
        // Set how links should appear: blue and underlined
        hyperlinkTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        hyperlinkTextView.font = hyperlinkTextView.font?.withSize(20)
        hyperlinkTextView.textAlignment = .center
        hyperlinkTextView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        contentView.addSubview(hyperlinkTextView)
        
        
        instructionBtn = UIBarButtonItem.init(title: "Software Manual", style: .done, target: self, action: #selector(instructionsBtnPressed))
        findDeviceBtn = UIBarButtonItem.init(title: "Find a Device", style: .done, target: self, action: #selector(findDeviceBtnPressed))
        
        navigationItem.rightBarButtonItems = [instructionBtn]
        navigationItem.leftBarButtonItems = [findDeviceBtn]
        
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator) //add to view because you always want it to be in the middle of the screen, you dont want it to scroll with the screen
        
    }
    
    private func setLayoutConstraints(){ //might not need constraints if everything is done in relation to screen size
        //view.translatesAutoresizingMaskIntoConstraints = false //need to do this individually for every component instead
        
        //findDeviceBtn
//        findDeviceBtn.translatesAutoresizingMaskIntoConstraints = false
//        findDeviceBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
//        //findDeviceBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true //this constant value is dependant on the screen resolution
//        findDeviceBtn.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.25) - ((UIScreen.main.bounds.height * 0.15) / 2)).isActive = true //this constant value is dependant on the screen resolution
//        findDeviceBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
//        findDeviceBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        //findDeviceLabel
//        findDeviceLabel.translatesAutoresizingMaskIntoConstraints = false
//        findDeviceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
//        findDeviceLabel.topAnchor.constraint(equalTo: findDeviceBtn.bottomAnchor, constant: 10).isActive = true
        
        //testBtn
        testBtn.translatesAutoresizingMaskIntoConstraints = false
        testBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
        //testBtn.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
         testBtn.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.25) - ((UIScreen.main.bounds.height * 0.15) / 2)).isActive = true //this
        testBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        testBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        //testLabel
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        testLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
        testLabel.topAnchor.constraint(equalTo: testBtn.bottomAnchor, constant: 10).isActive = true
        
        
        //settingsBtn
        accountBtn.translatesAutoresizingMaskIntoConstraints = false
        accountBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
        //settingsBtn.topAnchor.constraint(equalTo: testBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.15)).isActive = true //this constant value is dependant on the screen resolution
        //settingsBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -75).isActive = true //this constant value is dependant on the screen resolution
        accountBtn.topAnchor.constraint(equalTo: testLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.15)).isActive = true //this
        accountBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        accountBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        //settingsLabel
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25)).isActive = true
        accountLabel.topAnchor.constraint(equalTo: accountBtn.bottomAnchor, constant: 10).isActive = true
        
        
        logbookBtn.translatesAutoresizingMaskIntoConstraints = false
        logbookBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25) ).isActive = true
        logbookBtn.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.25) - ((UIScreen.main.bounds.height * 0.15) / 2)).isActive = true //this
        logbookBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        logbookBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        logbookLabel.translatesAutoresizingMaskIntoConstraints = false
        logbookLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25)).isActive = true
        logbookLabel.topAnchor.constraint(equalTo: logbookBtn.bottomAnchor, constant: 10).isActive = true
        
        
        settingsBtn.translatesAutoresizingMaskIntoConstraints = false
        settingsBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25) ).isActive = true
        settingsBtn.topAnchor.constraint(equalTo: logbookLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        settingsBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        settingsBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25)).isActive = true
        settingsLabel.topAnchor.constraint(equalTo: settingsBtn.bottomAnchor, constant: 10).isActive = true
        
        
        shopBtn.translatesAutoresizingMaskIntoConstraints = false
        shopBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
        shopBtn.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        shopBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        shopBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        
        shopLabel.translatesAutoresizingMaskIntoConstraints = false
        shopLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25)).isActive = true
        shopLabel.topAnchor.constraint(equalTo: shopBtn.bottomAnchor, constant: 10).isActive = true
        
        
        recommendationBtn.translatesAutoresizingMaskIntoConstraints = false
        recommendationBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25) ).isActive = true
        recommendationBtn.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        recommendationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        recommendationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        
        recommendationLabel.translatesAutoresizingMaskIntoConstraints = false
        recommendationLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: (UIScreen.main.bounds.width * 0.25)).isActive = true
        recommendationLabel.topAnchor.constraint(equalTo: recommendationBtn.bottomAnchor, constant: 10).isActive = true
        
        
        
        correlationBtn.translatesAutoresizingMaskIntoConstraints = false
        correlationBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25) ).isActive = true
        correlationBtn.topAnchor.constraint(equalTo: shopLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        correlationBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.4)).isActive = true
        correlationBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true

        correlationLabel.translatesAutoresizingMaskIntoConstraints = false
        correlationLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25)).isActive = true
        correlationLabel.topAnchor.constraint(equalTo: correlationBtn.bottomAnchor, constant: 10).isActive = true
        

        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
        
        
        hyperlinkTextView.translatesAutoresizingMaskIntoConstraints = false
        hyperlinkTextView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        hyperlinkTextView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.01)).isActive = true
        hyperlinkTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        hyperlinkTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        //scanningIndicator
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scanningIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        scanningIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
        
        
    }
    
    private func setButtonListeners(){
        //findDeviceBtn.addTarget(self, action: #selector(findDeviceBtnPressed), for: .touchUpInside) //see if you can put the action function in a seperate class like a listener class
        testBtn.addTarget(self, action: #selector(testBtnPressed), for: .touchUpInside) //see if you can put the action function in a seperate class like a listener class
        settingsBtn.addTarget(self, action: #selector(settingsBtnPressed), for: .touchUpInside) //see if you can put the action function in a seperate class like a listener class
        logbookBtn.addTarget(self, action: #selector(logbookBtnPressed), for: .touchUpInside)
        accountBtn.addTarget(self, action: #selector(accountBtnPressed), for: .touchUpInside)
        shopBtn.addTarget(self, action: #selector(shopBtnPressed), for: .touchUpInside)
        recommendationBtn.addTarget(self, action: #selector(recommendationBtnPressed), for: .touchUpInside)
    }
    
    
    @objc private func recommendationBtnPressed(){
        
        recommendationBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                        delay: 0,
                        usingSpringWithDamping: CGFloat(0.70),
                        initialSpringVelocity: CGFloat(5.0),
                        options: UIView.AnimationOptions.allowUserInteraction,
                        animations: {
                        self.recommendationBtn.transform = CGAffineTransform.identity
        },
                        completion: { Void in()  }
        )
        
        navigationController?.pushViewController(recommendationView!, animated: true) //pushes connectView onto the navigationController stack
    }
    
    @objc private func findDeviceBtnPressed(){ //see if you can put this in a seperate class like a listener class
        
        
        
        
//        findDeviceBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.70),
//                       initialSpringVelocity: CGFloat(5.0),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.findDeviceBtn.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in()  }
//        )
    
        
        
        
        navigationController?.pushViewController(connectView!, animated: true) //pushes connectView onto the navigationController stack
    
        centralManager?.delegate = connectView //make connectView the delegate for centralManager
        connectView!.setCentralManager(centralManager: self.centralManager!)
        //connectView.menuView = self
        //connectView.testView = self.testView
        //connectView.settingsView = self.settingsView
        if(wcSession != nil){
            wcSession!.delegate = connectView
            connectView?.setWCSession(session: wcSession)
        }
    }
    
    
    
    
    
    @objc private func shopBtnPressed(){
        shopBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                        delay: 0,
                        usingSpringWithDamping: CGFloat(0.70),
                        initialSpringVelocity: CGFloat(5.0),
                        options: UIView.AnimationOptions.allowUserInteraction,
                        animations: {
                        self.shopBtn.transform = CGAffineTransform.identity
        },
                        completion: { Void in()  }
        )
        
        //check that they have an internet connection first
        if(Reachability.isConnectedToNetwork() == false){
            showToast(controller: self, message: "No Internet Connection", seconds: 1)
            return
        }
        
        DispatchQueue.main.async {
            self.scanningIndicator.startAnimating()
        }
        
        //CHECK THAT JWT HAS NOT EXPIRED - IF IT HAS SET APPDELEGATES AUTHORIZEDSESSION TO FALSE
        var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user/authenticate")!) //authenticate path just used to check that the jwt has not expired
        request.httpMethod = "GET"
        request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    print("Error occured during /login RESTAPI request")
                    self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    //self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1) //not too useful for the user, instead just print to the console
                    print(String(decoding: data!, as: UTF8.self))
                }
                
                
                print("Response:")
                print(response!)
                print("Data:")
                print(String(decoding: data!, as: UTF8.self))
                
                if(String(decoding: data!, as: UTF8.self) == "Authenticated"){ //if authenticated switch to account view
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                        //authenticated, go to store
                        
                        //query for the number of products in the store and add this many pages to the page set
                        let query = Storefront.buildQuery { $0
                            .products(first: 10) { $0
                                .edges{$0
                                    .node{$0
                                        .id() //just get the id's of all products
                                        .variants(first: 10){ $0
                                            .edges{ $0
                                                .node{ $0
                                                    .id()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        let shopifyTask = self.client.queryGraphWith(query) { response, error in
                            if let response = response {
                                
                                //empty the page count before re-querying for pages
                                self.shopView!.removePages()
                                
                                for product in response.products.edges{
                                    self.shopView?.addPage(productIDToAdd: product.node.id.rawValue as String, variantIDToAdd: product.node.variants.edges[0].node.id.rawValue as String)
                                }
                                
                                self.navigationController?.pushViewController(self.shopView!, animated: true) //pushes shopView onto the navigationController stack
                                
                            } else {
                                print(error!)
                            }
                        }
                        shopifyTask.resume()
                        
                    }
                }
                
                else{
                    //IF LOGGED OUT GO TO LOGIN - IF LOGGED IN GO TO ACCOUNT SETTINGS/ACCOUNT INFO
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                        //not authenticated, set token on login to go to store and then go to login
                        self.loginView!.setAccountOrStore(aOrS: true)
                        
                        self.navigationController?.pushViewController(self.loginView!, animated: true)
                        
                    }
                }
                
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
    
    @objc private func testBtnPressed(){ //see if you can put this in a seperate class like a listener class
        
        
        testBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.testBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        //testPageController?.addPage(pageToAdd: testView)
        
        navigationController?.pushViewController(testPageController!, animated: true) //pushes testView onto the navigationController stack
        
        testPageController!.setCentralManager(centralManager: self.centralManager!)
        //peripheralDevice!.delegate = testView
        //testView.menuView = self
        //testView.connectView = self.connectView
        //testView.settingsView = self.settingsView
        if(wcSession != nil){
            wcSession!.delegate = testView
            //testView?.setWCSession(session: wcSession)
        }
        
    }

    @objc private func settingsBtnPressed(){ //see if you can put this in a seperate class like a listener class
        
//        settingsBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.70),
//                       initialSpringVelocity: CGFloat(5.0),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.settingsBtn.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in()  }
//        )
//
//        navigationController?.pushViewController(settingsView!, animated: true) //pushes settingsView onto the navigationController stack
//
//        //settingsView.menuView = self
//        //settingsView.connectView = self.connectView
//        //settingsView.testView = self.testView
//        if(wcSession != nil){
//        wcSession!.delegate = settingsView
//        settingsView?.setWCSession(session: wcSession)
//        }
        
        settingsBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    
        UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: CGFloat(0.70),
                   initialSpringVelocity: CGFloat(5.0),
                   options: UIView.AnimationOptions.allowUserInteraction,
                   animations: {
                    self.settingsBtn.transform = CGAffineTransform.identity
        },
                   completion: { Void in()  }
        )
        
        //NOT GOING TO SWITCH TO THIS ON APPLE WATCH
        if(Reachability.isConnectedToNetwork() == false){
            showToast(controller: self, message: "No Internet Connection", seconds: 1)
            return
        }
        
        DispatchQueue.main.async {
            self.scanningIndicator.startAnimating()
        }
        
        //CHECK THAT JWT HAS NOT EXPIRED - IF IT HAS SET APPDELEGATES AUTHORIZEDSESSION TO FALSE
        var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user/authenticate")!) //authenticate path just used to check that the jwt has not expired
        request.httpMethod = "GET"
        request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    print("Error occured during /login RESTAPI request")
                    self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    //self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1) //not too useful for the user, instead just print to the console
                    print(String(decoding: data!, as: UTF8.self))
                }
                
                
                print("Response:")
                print(response!)
                print("Data:")
                print(String(decoding: data!, as: UTF8.self))
                
                if(String(decoding: data!, as: UTF8.self) == "Authenticated"){ //if authenticated switch to account view
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                        //dont change admin flag
                        
                        self.navigationController?.pushViewController(self.settingsView!, animated: true)
                        if(self.wcSession != nil){
                            self.wcSession!.delegate = self.accountView
                            self.settingsView?.setWCSession(session: self.wcSession)
                        }
                    }
                }
                
                else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                        //change admin keychain flag to 0
                        let adminFlagSavedSuccesfully = KeychainWrapper.standard.set(0, forKey: "User-Admin-Flag")
                        
                        if(adminFlagSavedSuccesfully){
                            self.navigationController?.pushViewController(self.settingsView!, animated: true)
                        }
                        
                        if(self.wcSession != nil){
                            self.wcSession!.delegate = self.accountView
                            self.settingsView?.setWCSession(session: self.wcSession)
                        }
                    }
                }
                
            }
            
        }
        
        task.resume()
        
        
    }
    
    @objc private func logbookBtnPressed(){
        
        logbookBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.logbookBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        navigationController?.pushViewController(logbookView!, animated: true)
        if(wcSession != nil){
            wcSession!.delegate = logbookView
            logbookView?.setWCSession(session: wcSession)
        }
    
    }
    
    
    
    
    @objc private func accountBtnPressed(){
        accountBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    
        UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: CGFloat(0.70),
                   initialSpringVelocity: CGFloat(5.0),
                   options: UIView.AnimationOptions.allowUserInteraction,
                   animations: {
                    self.accountBtn.transform = CGAffineTransform.identity
        },
                   completion: { Void in()  }
        )
        
        //NOT GOING TO SWITCH TO THIS ON APPLE WATCH
        if(Reachability.isConnectedToNetwork() == false){
            showToast(controller: self, message: "No Internet Connection", seconds: 1)
            return
        }
        
        DispatchQueue.main.async {
            self.scanningIndicator.startAnimating()
        }
        
        //CHECK THAT JWT HAS NOT EXPIRED - IF IT HAS SET APPDELEGATES AUTHORIZEDSESSION TO FALSE
        var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user/authenticate")!) //authenticate path just used to check that the jwt has not expired
        request.httpMethod = "GET"
        request.setValue(KeychainWrapper.standard.string(forKey: "JWT-Auth-Token"), forHTTPHeaderField: "auth-token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    print("Error occured during /login RESTAPI request")
                    self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    //self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1) //not too useful for the user, instead just print to the console
                    print(String(decoding: data!, as: UTF8.self))
                }
                
                
                print("Response:")
                print(response!)
                print("Data:")
                print(String(decoding: data!, as: UTF8.self))
                
                if(String(decoding: data!, as: UTF8.self) == "Authenticated"){ //if authenticated switch to account view
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                        self.navigationController?.pushViewController(self.accountView!, animated: true)
                        if(self.wcSession != nil){
                            self.wcSession!.delegate = self.accountView
                            self.accountView?.setWCSession(session: self.wcSession)
                        }
                    }
                }
                
                else{
                    //IF LOGGED OUT GO TO LOGIN - IF LOGGED IN GO TO ACCOUNT SETTINGS/ACCOUNT INFO
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                        //set token in login to go to account view
                        self.loginView!.setAccountOrStore(aOrS: false)
                        
                        self.navigationController?.pushViewController(self.loginView!, animated: true)
                        if(self.wcSession != nil){
                            self.wcSession!.delegate = self.loginView
                            self.loginView?.setWCSession(session: self.wcSession)
                        }
                    }
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    @objc private func instructionsBtnPressed(){
       //navigationController?.pushViewController(instructionsView!, animated: true)
        UIApplication.shared.open(URL(string: "https://creativeproteinsolutions.com/instructions-app-%26-device")!, options: [:], completionHandler: nil)
        
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
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //fill in
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //fill in
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        //fill in
        //print("wcSession did deactivate on mobile")
    }
    
    //func to receive message
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void){ //needs to throw
        
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if(applicationContext["ChangeScreens"] != nil){
            switch(applicationContext["ChangeScreens"] as! String){
            case "Main":
                    //do nothing
                print("do nothing case")
            case "FindDevice":
                DispatchQueue.main.async {
                    self.findDeviceBtnPressed()
                }
            case "RunTest":
                DispatchQueue.main.async {
                    self.testBtnPressed()
                }
            case "Settings":
                DispatchQueue.main.async {
                    self.settingsBtnPressed()
                }
            case "Logbook":
                DispatchQueue.main.async {
                    self.logbookBtnPressed()
                }
            case "Account":
                DispatchQueue.main.async {
                    self.accountBtnPressed()
                }
            default:
                print("Default case - do nothing")
            }
        }
    }
    
    //GETTERS/SETTERS
    public func getTestPageView() -> /*OriginalTestPageViewController*/SingleStripTestPageViewController{
        return testPageController!
    }
    
    public func getConnectView() -> ConnectViewController{
        return connectView!
    }
    
    public func getSettingsView() -> SettingsViewControllerV2{
        return settingsView!
    }
    
    public func getHerdLogbookView() -> HerdLogbookViewController{
        return logbookView!
    }
    
    public func setPeripheralDevice(periphDevice: CBPeripheral?){
        self.peripheralDevice = periphDevice
    }
    
    public func setWCSession(session: WCSession?){
        self.wcSession = session
    }
    
    public func setInQueueView(flag: Int){
        inQueueView = flag
    }
    
    public func getLoginView() -> LoginViewController{
        return loginView!
    }
    
    
    
    public func getAppDelegate() -> AppDelegate{
        return appDelegate!
    }

    
}
