//
//  RegisterAccountViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-30.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class RegisterAccountViewController: UIViewController, UITextFieldDelegate{
    
    //views
    private var appDelegate: AppDelegate? = nil
    private var menuView: MenuViewController? = nil
    
    //UIImageView
    let logoImage = UIImageView()
    
    //UITextFields
    let emailTextField = UITextField()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordCompareTextField = UITextField()
    
    //UIButtons
    let registerAccountBtn = UIButton()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(appDelegate: AppDelegate?, menuView: MenuViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.appDelegate = appDelegate
        self.menuView = menuView
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Register"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupLayoutComponents()
        setupLayoutConstraints()
    }
    
    
    private func setupLayoutComponents(){
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
        
        usernameTextField.backgroundColor = .white
        usernameTextField.textColor = .black
        usernameTextField.placeholder = "Username"
        usernameTextField.autocapitalizationType = .none
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.tag = 1
        usernameTextField.delegate = self
        view.addSubview(usernameTextField)
        
        passwordTextField.backgroundColor = .white
        passwordTextField.textColor = .black
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true //dots entered characters
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.tag = 2
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        passwordCompareTextField.backgroundColor = .white
        passwordCompareTextField.textColor = .black
        passwordCompareTextField.placeholder = "Re-Enter Password"
        passwordCompareTextField.autocapitalizationType = .none
        passwordCompareTextField.isSecureTextEntry = true //dots entered characters
        passwordCompareTextField.borderStyle = .roundedRect
        passwordCompareTextField.tag = 3
        passwordCompareTextField.delegate = self
        view.addSubview(passwordCompareTextField)
        
        registerAccountBtn.setTitle("Register Account", for: .normal)
        registerAccountBtn.backgroundColor = .blue
        registerAccountBtn.setTitleColor(.white, for: .normal)
        registerAccountBtn.layer.borderWidth = 2
        registerAccountBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor //white
        registerAccountBtn.addTarget(self, action: #selector(registerAccountBtnPressed), for: .touchUpInside)
        view.addSubview(registerAccountBtn)
        
        
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator)
        
    }
    
    private func setupLayoutConstraints(){
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.35)).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        passwordCompareTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordCompareTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordCompareTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        passwordCompareTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        passwordCompareTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        registerAccountBtn.translatesAutoresizingMaskIntoConstraints = false
        registerAccountBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registerAccountBtn.topAnchor.constraint(equalTo: passwordCompareTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        registerAccountBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.5)).isActive = true
        registerAccountBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        
        
        //scanningIndicator
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scanningIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        scanningIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
        passwordCompareTextField.text = ""
    }
    
    
    @objc private func registerAccountBtnPressed(){
        registerAccountBtn.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.70),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.registerAccountBtn.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        DispatchQueue.main.async {
            self.scanningIndicator.startAnimating()
        }
        
        
        //client side checks
        if(emailTextField.text == "" || usernameTextField.text == "" || passwordTextField.text == "" || passwordCompareTextField.text == ""){
            
            self.showToast(controller: self, message: "Please Fill in All Fields to Register Account", seconds: 1)
            
            DispatchQueue.main.async {
                self.scanningIndicator.stopAnimating()
            }
            
            return
        }
        else if(passwordTextField.text != passwordCompareTextField.text){
            
            self.showToast(controller: self, message: "Passwords do not Match", seconds: 1)
            
            passwordTextField.text = ""
            passwordCompareTextField.text = ""
            
            DispatchQueue.main.async {
                self.scanningIndicator.stopAnimating()
            }
            
            return
        }
        
        
        
        
        let jsonRegisterObject: [String: Any] = [
            "username": usernameTextField.text!,
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        
        var registerJSONData: Data? = nil
        
        if(JSONSerialization.isValidJSONObject(jsonRegisterObject)){
            do{
                registerJSONData = try JSONSerialization.data(withJSONObject: jsonRegisterObject, options: [])
            }catch{
                print("Problem while serializing jsonLoginObject")
            }
        }
        
        
        var request = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user/register")!)
        request.httpMethod = "POST"
        request.httpBody = registerJSONData
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                }
                print("Error occured during /register RESTAPI request")
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
                
                let userID = ((response! as! HTTPURLResponse).allHeaderFields["User-Id"] as? String)
                
                
                if(userID == nil){ //something happened - username/email already taken or not verified- let user know and return
                    DispatchQueue.main.async {
                        self.emailTextField.text = ""
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.passwordCompareTextField.text = ""
                    }
                    return
                }
                    
                else{ //authenticated - save JWT authencation token into iOS Keychain & set authorizedSession in AppDelegate to true
                    
                    print("User ID: ")
                    print(userID!)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ //go after 1 second from now you that you know the toast is complete
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }
        }
        
        task.resume()
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

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.tag == 0){
            //email text field
            emailTextField.endEditing(true)
            passwordTextField.text = "" //must re-enter password every time you change email
            passwordCompareTextField.text = ""
        }
        else if(textField.tag == 1){
            //usernametext field
            usernameTextField.endEditing(true)
            
        }
        else if(textField.tag == 2){
            //usernametext field
            passwordTextField.endEditing(true)
            
        }
        else if(textField.tag == 3){
            //usernametext field
            passwordCompareTextField.endEditing(true)
            
        }
        return true
    }
    
}
