//
//  LoginViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-29.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //UIImageView
    let logoImage = UIImageView()
    
    //UITextViews
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    //UIBarButtons
    private var loginBtn = UIBarButtonItem()
    private var registerBtn = UIBarButtonItem()
    
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
        
        loginBtn = UIBarButtonItem.init(title: "Login", style: .done, target: self, action: #selector(loginBtnPressed))
        navigationItem.rightBarButtonItems = [loginBtn]
        
        registerBtn = UIBarButtonItem.init(title: "Create Account", style: .done, target: self, action: #selector(registerBtnPressed))
        navigationItem.leftBarButtonItems = [registerBtn]
        
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
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
    
        //scanningIndicator
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
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
                    print("Error occured during /login RESTAPI request")
                }
                else{
                    print("Response:")
                    print(response!)
                    print("Data:")
                    print(String(decoding: data!, as: UTF8.self))
                    print("Session JWT:")
                    
                    
                }
            }
            
            task.resume()
            
        }
    }
    
    @objc private func registerBtnPressed(){
        //fill out
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
