//
//  LoginViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-29.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController, UITextFieldDelegate {

    //views
    private var registerView: RegisterAccountViewController? = nil
    private var accountView: AccountPageViewController? = nil
    private var appDelegate: AppDelegate? = nil
    
    //UIImageView
    let logoImage = UIImageView()
    
    //UITextViews
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    //UIBarButtons
    private var registerBtn = UIBarButtonItem()
    
    //UIButtons
    let loginBtn = UIButton()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupComponents()
        setLayoutConstraints()
    }
    
    private func setupComponents(){
        logoImage.image = UIImage(named: "CPSLogo")
        view.addSubview(logoImage)
        
        emailTextField.backgroundColor = .white
        emailTextField.textColor = .black
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.tag = 0
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        passwordTextField.backgroundColor = .white
        passwordTextField.textColor = .black
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true //dots entered characters
        passwordTextField.borderStyle = .roundedRect
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
    
    private func setLayoutConstraints(){
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.35)).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.2)).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.03)).isActive = true
    
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginBtn.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
        loginBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3)).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        //scanningIndicator
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scanningIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        scanningIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
    }
    
    
    
    
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.appDelegate = appDelegate
        registerView = RegisterAccountViewController()
        accountView = AccountPageViewController()
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
                    }
                    print("Error occured during /login RESTAPI request")
                }
                else{
                    DispatchQueue.main.async {
                        self.scanningIndicator.stopAnimating()
                    }
                    print("Response:")
                    print(response!)
                    print("Data:")
                    print(String(decoding: data!, as: UTF8.self))
                
                    let jwtToken = ((response! as! HTTPURLResponse).allHeaderFields["Auth-Token"] as? String)
                    
                    print("Auth Token: ")
                    print(jwtToken)
                    
                    if(jwtToken == nil){ //not authenticated - let user know and return
                        DispatchQueue.main.async {
                            self.showToast(controller: self, message: "Email or Password is Incorrect", seconds: 1)
                        }
                        return
                    }
                        
                    else{ //authenticated - save JWT authencation token into iOS Keychain & set authorizedSession in AppDelegate to true
                        let jwtSavedSuccessfully = KeychainWrapper.standard.set(jwtToken!, forKey: "JWT-Auth-Token")
                        
                        if(jwtSavedSuccessfully){
                            self.appDelegate?.setAuthorizedSession(auth: true)
                            
                            DispatchQueue.main.async {
                                self.navigationController?.pushViewController(self.accountView!, animated: true)
                            }
                        }
                    }
                    
                }
            }
            
            task.resume()
        }
        
        
    }
    
    @objc private func registerBtnPressed(){
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

}
