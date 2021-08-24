//
//  LoginViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-29.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE LOGIN SCREEN WHEN PUSHING THE ACCOUNT BUTTON FROM THE MAIN SCREEN (IF DIRECTED TO THE LOGIN SCREEN)

import UIKit
import SwiftKeychainWrapper
import WatchConnectivity
import MobileBuySDK


public class LoginViewController: UIViewController, UITextFieldDelegate, WCSessionDelegate {

    private var accountOrStore: Bool = false //false = account, true = store
    
    //views
    private var registerView: RegisterAccountViewController? = nil
    private var accountView: AccountPageViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var menuView: MenuViewController? = nil
    private var storeView: ShopifyStorePagesViewController? = nil
    
    //UIImageView
    let logoImage = UIImageView()
    
    //UITextViews
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    //UIBarButtons
    private var registerBtn = UIBarButtonItem()
    
    //UIButtons
    let loginBtn = UIButton()
    
    //WCSession
    private var wcSession: WCSession? = nil
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    //Buy SDK client
    let client = Graph.Client(shopDomain: "creative-protein-solutions.myshopify.com", apiKey: "28893d9e78d310dde27dde211fa414d7")
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupComponents()
        setLayoutConstraints()
    }
    
    
    //SETUP ALL BUTTONS AND COMPONENTS
    private func setupComponents(){
        logoImage.image = UIImage(named: "CPSLogo")
        view.addSubview(logoImage)
        
        emailTextField.backgroundColor = .white
        emailTextField.textColor = .black
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.tag = 0
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        passwordTextField.backgroundColor = .white
        passwordTextField.textColor = .black
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true //dots entered characters
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.tag = 1
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.backgroundColor = .blue
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.borderWidth = 2
        loginBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor //white
        loginBtn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        view.addSubview(loginBtn)
        
        registerBtn = UIBarButtonItem.init(title: "Create Account", style: .done, target: self, action: #selector(registerBtnPressed))
        navigationItem.rightBarButtonItems = [registerBtn]

        
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator)
    }
    
    //SETUP ALL CONSTRAINTS FOR COMPONENTS
    private func setLayoutConstraints(){
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.35)).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.06)).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.06)).isActive = true
    
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginBtn.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        loginBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        //scanningIndicator
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scanningIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        scanningIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
    }
    
    
    override public func viewWillAppear(_ animated: Bool) { //RESET THE EMAIL AND PASSWORD TEXTS FIELDS TO NOTHING WHEN VIEW APPEARS
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    convenience init(appDelegate: AppDelegate?, accountView: AccountPageViewController?, menuView: MenuViewController?, storeView: ShopifyStorePagesViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.appDelegate = appDelegate
        self.menuView = menuView
        registerView = RegisterAccountViewController(appDelegate: appDelegate, menuView: menuView)
        self.accountView = accountView
        self.storeView = storeView
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.tag == 0){
            //email text field
            emailTextField.endEditing(true)
            passwordTextField.text = "" //must re-enter password every time you change email
        }
        else{
            //password text field
            passwordTextField.endEditing(true)

        }
        return true
    }
    
    
    
    @objc private func loginBtnPressed(){
        //ANIMATES THE BUTTON PRESS
        loginBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.loginBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        
        if(Reachability.isConnectedToNetwork() == false){ //CHECKS THAT THE APP HAS INTERNET CONNECTION
            self.showToast(controller: self, message: "No Internet Connection", seconds: 1)
            return
        }
        
        
        if(emailTextField.text == "" || passwordTextField.text == ""){
            self.showToast(controller: self, message: "Please Enter Email & Password", seconds: 1)
            return
        }
        else{            
            emailTextField.endEditing(true)
            passwordTextField.endEditing(true)
            
            scanningIndicator.startAnimating()
            
            let jsonLoginObject: [String: Any] = [
                "email": emailTextField.text!,
                "password": passwordTextField.text!
            ]
            
            var loginJsonData: Data? = nil
            
            if(JSONSerialization.isValidJSONObject(jsonLoginObject)){
                do{
                    loginJsonData = try JSONSerialization.data(withJSONObject: jsonLoginObject, options: [])
                }catch{
                    print("Problem while serializing jsonLoginObject")
                }
            }
            
            
            
            var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user/login")!)
            request.httpMethod = "POST"
            request.httpBody = loginJsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if(error != nil){
                    DispatchQueue.main.async {
                        self.scanningIndicator.stopAnimating()
                        self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                    }
                    print("Error occured during /login RESTAPI request")
                    
                }
                else{
                    DispatchQueue.main.async {
                        self.scanningIndicator.stopAnimating()
                        self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
                    }
                    
                    
                    
                    print("Response:")
                    print(response!)
                    print("Data:")
                    print(String(decoding: data!, as: UTF8.self))
                
                    let jwtToken = ((response! as! HTTPURLResponse).allHeaderFields["Auth-Token"] as? String)
                    let userID = ((response! as! HTTPURLResponse).allHeaderFields["User-Id"] as? String)
            
                    if(jwtToken == nil || userID == nil){ //not authenticated - let user know and return
                        DispatchQueue.main.async {
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                        }
                        return
                    }
                        
                    else{ //authenticated - save JWT authencation token into iOS Keychain & set authorizedSession in AppDelegate to true
                        
                        print("Auth Token: ")
                        print(jwtToken!)
                        
                        let jwtSavedSuccessfully = KeychainWrapper.standard.set(jwtToken!, forKey: "JWT-Auth-Token") //jwt gets saved to keychain upon login
                        
                        let userIDSavedSuccessfully = KeychainWrapper.standard.set(userID!, forKey: "User-ID-Token") //user id gets saved to keychain upon login
                        
                        print("LOGGED IN USER ID: " + userID!)
                        
                        if(jwtSavedSuccessfully && userIDSavedSuccessfully){
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ //go after 1 second from now you that you know the toast is complete
                                
                                
                                
                                
                                //login to shopify account and get the access token
                                print("Email: " + self.emailTextField.text!)
                                print("Password: " + self.passwordTextField.text!)
                                
                                let input = Storefront.CustomerAccessTokenCreateInput.create(
                                    email: self.emailTextField.text!,
                                    password: self.passwordTextField.text!
                                )
                                
                                let mutation = Storefront.buildMutation{ $0
                                    .customerAccessTokenCreate(input: input){ $0
                                        .customerAccessToken{ $0
                                            .accessToken()
                                            .expiresAt()
                                        }
                                        .customerUserErrors{ $0
                                            .field()
                                            .message()
                                        }
                                    }
                                }
                                
                                
                                
                                let task = self.client.mutateGraphWith(mutation) { result, error in
                                    guard error == nil else{
                                        //handle request errors
                                        print("A request error occured logging into Shopify customer account")
                                        print(error!)
                                        return
                                    }
                                    
                                    guard let userError = result?.customerAccessTokenCreate?.customerUserErrors else{
                                        //handle user errors
                                        print("A user error occured logging into Shopify customer account")
                                        return
                                    }
                                    
                                    //handle proper creation
                                    print("Shopify customer account succesfully authenticated")
                                    print(result?.customerAccessTokenCreate?.customerAccessToken?.accessToken)
                                    
                                    let shopifyAccessTokenSavedSuccessfully = KeychainWrapper.standard.set((result?.customerAccessTokenCreate?.customerAccessToken!.accessToken)!, forKey: "Shopify-Access-Token") //jwt gets saved to keychain upon login
                                    
                                    print((result?.customerAccessTokenCreate?.customerAccessToken!.expiresAt)!)
                                    
                                    if(shopifyAccessTokenSavedSuccessfully){
                                        print("Succesfully saved shopify access token to keychain")
                                    }
                                    else{
                                        print("error saving shopify access token to keychain")
                                        return
                                    }
                                    
                                    
                                    if(!self.accountOrStore){
                                        
                                        let emailSavedSuccessfully = KeychainWrapper.standard.set(self.emailTextField.text!, forKey: "UserEmail")
                                        
                                        if(emailSavedSuccessfully){
                                            self.accountView?.refreshUserEmail()
                                            self.navigationController?.pushViewController(self.accountView!, animated: true)
                                        }
                                        
                                    }
                                    else{
                                        
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
                                                self.storeView!.removePages()
                                                
                                                for product in response.products.edges{
                                                    self.storeView?.addPage(productIDToAdd: product.node.id.rawValue as String, variantIDToAdd: product.node.variants.edges[0].node.id.rawValue as String)
                                                }
                                                
                                                self.navigationController?.pushViewController(self.storeView!, animated: true) //pushes shopView onto the navigationController stack
                                                
                                            } else {
                                                print(error!)
                                            }
                                        }
                                        shopifyTask.resume()
                                        
                                    }
                                    
                                    
                                }
                                task.resume()
                                
                            }
                            
                        }
                    }
                    
                }
            }
            
            task.resume()
        }
        
        
    }
    
    @objc private func registerBtnPressed(){
        if(Reachability.isConnectedToNetwork() == false){
            self.showToast(controller: self, message: "No Internet Connection", seconds: 1)
            return
        }
        
        navigationController?.pushViewController(registerView!, animated: true)
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
    
    
    
    //getters/setters
    public func setWCSession(session: WCSession?){
        self.wcSession = session
    }
    
    public func setAccountOrStore(aOrS: Bool){
        accountOrStore = aOrS //false = account, true = store
    }

}
