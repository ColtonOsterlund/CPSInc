//
//  RegisterAccountViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-30.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE REGISTER ACCOUNT SCREEN WHEN PUSHING THE "CREATE ACCOUNT" BUTTON FROM THE LOGIN SCREEN

import UIKit
import SwiftKeychainWrapper
import MobileBuySDK
import PhoneNumberKit


class RegisterAccountViewController: UIViewController, UITextFieldDelegate{
    
    //views
    private var appDelegate: AppDelegate? = nil
    private var menuView: MenuViewController? = nil
    
    //UIImageView
    let logoImage = UIImageView()
    
    //UIScrollView
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    //UITextFields
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let emailTextField = UITextField()
//    let phoneCountryCodeTextField = UITextField()
//    let phoneAreaCodeTextField = UITextField()
//    let phoneFirstThreeDigitTextField = UITextField()
//    let phoneLastFourDigitTextField = UITextField()
//    let phonePlusLabel = UILabel()
//    let phoneDashOneLabel = UILabel()
//    let phoneDashTwoLabel = UILabel()
//    let phoneDashThreeLabel = UILabel()
//    let phoneLabel = UILabel()
    
    let address1TextField = UITextField()
    let address2TextField = UITextField()
    let cityTextField = UITextField()
    let countryTextField = UITextField()
    let provinceTextField = UITextField()
    let zipCodeTextField = UITextField()
    let phoneTextField = UITextField() //this using an "AsYouTypeFormatter"
    
    private var currentPhoneNumberText: String = ""
    
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordCompareTextField = UITextField()
    
    //UIButtons
    let registerAccountBtn = UIButton()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    //Buy SDK client
    let client = Graph.Client(shopDomain: "creative-protein-solutions.myshopify.com", apiKey: "28893d9e78d310dde27dde211fa414d7")
    
    let phoneNumberKit = PhoneNumberKit()
    
    
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
//        logoImage.image = UIImage(named: "CPSLogo")
//        view.addSubview(logoImage)
        
        scrollView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.7)
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        contentView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        scrollView.addSubview(contentView)
        
        firstNameTextField.backgroundColor = .white
        firstNameTextField.textColor = .black
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.autocapitalizationType = .words
        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.tag = 0
        firstNameTextField.delegate = self
        firstNameTextField.becomeFirstResponder()
        contentView.addSubview(firstNameTextField)
        
        lastNameTextField.backgroundColor = .white
        lastNameTextField.textColor = .black
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.autocapitalizationType = .words
        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.tag = 4
        lastNameTextField.delegate = self
        contentView.addSubview(lastNameTextField)
        
        emailTextField.backgroundColor = .white
        emailTextField.textColor = .black
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.tag = 5
        emailTextField.delegate = self
        contentView.addSubview(emailTextField)
        
//        phonePlusLabel.text = "+"
//        phonePlusLabel.textColor = .black
//        phonePlusLabel.textAlignment = .center
//        phonePlusLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//        contentView.addSubview(phonePlusLabel)
//
//        phoneLabel.text = "Phone:"
//        phoneLabel.textColor = .gray
//        phoneLabel.textAlignment = .center
//        //phoneLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//        contentView.addSubview(phoneLabel)
//
//        phoneDashOneLabel.text = "-"
//        phoneDashOneLabel.textColor = .black
//        phoneDashOneLabel.textAlignment = .center
//        phoneDashOneLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//        contentView.addSubview(phoneDashOneLabel)
//
//        phoneDashTwoLabel.text = "-"
//        phoneDashTwoLabel.textColor = .black
//        phoneDashTwoLabel.textAlignment = .center
//        phoneDashTwoLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//        contentView.addSubview(phoneDashTwoLabel)
//
//        phoneDashThreeLabel.text = "-"
//        phoneDashThreeLabel.textColor = .black
//        phoneDashThreeLabel.textAlignment = .center
//        phoneDashThreeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//        contentView.addSubview(phoneDashThreeLabel)
        
//        phoneLastFourDigitTextField.backgroundColor = .white
//        phoneLastFourDigitTextField.textColor = .black
//        phoneLastFourDigitTextField.placeholder = "Phone Number"
//        phoneLastFourDigitTextField.keyboardType = .numberPad
//        phoneLastFourDigitTextField.autocapitalizationType = .none
//        phoneLastFourDigitTextField.borderStyle = .roundedRect
//        phoneLastFourDigitTextField.tag = 6
//        phoneLastFourDigitTextField.delegate = self
//        contentView.addSubview(phoneLastFourDigitTextField)
        
        phoneTextField.backgroundColor = .white
        phoneTextField.textColor = .black
        phoneTextField.placeholder = "Phone Number"
        phoneTextField.keyboardType = .numberPad
        phoneTextField.autocapitalizationType = .none
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.tag = 6
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(editPhoneTextFieldRealTime), for: .editingChanged)
        contentView.addSubview(phoneTextField)
        
//        phoneAreaCodeTextField.backgroundColor = .white
//        phoneAreaCodeTextField.textColor = .black
//        phoneAreaCodeTextField.placeholder = "xxx"
//        phoneAreaCodeTextField.keyboardType = .numberPad
//        phoneAreaCodeTextField.autocapitalizationType = .none
//        phoneAreaCodeTextField.borderStyle = .roundedRect
//        phoneAreaCodeTextField.tag = 13
//        phoneAreaCodeTextField.delegate = self
//        contentView.addSubview(phoneAreaCodeTextField)
//
//        phoneFirstThreeDigitTextField.backgroundColor = .white
//        phoneFirstThreeDigitTextField.textColor = .black
//        phoneFirstThreeDigitTextField.placeholder = "xxx"
//        phoneFirstThreeDigitTextField.keyboardType = .numberPad
//        phoneFirstThreeDigitTextField.autocapitalizationType = .none
//        phoneFirstThreeDigitTextField.borderStyle = .roundedRect
//        phoneFirstThreeDigitTextField.tag = 14
//        phoneFirstThreeDigitTextField.delegate = self
//        contentView.addSubview(phoneFirstThreeDigitTextField)
//
//        phoneLastFourDigitTextField.backgroundColor = .white
//        phoneLastFourDigitTextField.textColor = .black
//        phoneLastFourDigitTextField.placeholder = "xxxx"
//        phoneLastFourDigitTextField.keyboardType = .numberPad
//        phoneLastFourDigitTextField.autocapitalizationType = .none
//        phoneLastFourDigitTextField.borderStyle = .roundedRect
//        phoneLastFourDigitTextField.tag = 15
//        phoneLastFourDigitTextField.delegate = self
//        contentView.addSubview(phoneLastFourDigitTextField)
        
        address1TextField.backgroundColor = .white
        address1TextField.textColor = .black
        address1TextField.placeholder = "Street Address"
        address1TextField.autocapitalizationType = .words
        address1TextField.borderStyle = .roundedRect
        address1TextField.tag = 7
        address1TextField.delegate = self
        contentView.addSubview(address1TextField)
        
        address2TextField.backgroundColor = .white
        address2TextField.textColor = .black
        address2TextField.placeholder = "Unit Number (if applicable)"
        address2TextField.autocapitalizationType = .words
        address2TextField.borderStyle = .roundedRect
        address2TextField.tag = 8
        address2TextField.delegate = self
        contentView.addSubview(address2TextField)
        
        cityTextField.backgroundColor = .white
        cityTextField.textColor = .black
        cityTextField.placeholder = "City"
        cityTextField.autocapitalizationType = .words
        cityTextField.borderStyle = .roundedRect
        cityTextField.tag = 9
        cityTextField.delegate = self
        contentView.addSubview(cityTextField)
        
        countryTextField.backgroundColor = .white
        countryTextField.textColor = .black
        countryTextField.placeholder = "Country"
        countryTextField.autocapitalizationType = .words
        countryTextField.borderStyle = .roundedRect
        countryTextField.tag = 10
        countryTextField.delegate = self
        contentView.addSubview(countryTextField)
        
        provinceTextField.backgroundColor = .white
        provinceTextField.textColor = .black
        provinceTextField.placeholder = "Province/State"
        provinceTextField.autocapitalizationType = .words
        provinceTextField.borderStyle = .roundedRect
        provinceTextField.tag = 11
        provinceTextField.delegate = self
        contentView.addSubview(provinceTextField)
        
        zipCodeTextField.backgroundColor = .white
        zipCodeTextField.textColor = .black
        zipCodeTextField.placeholder = "Zip Code"
        zipCodeTextField.autocapitalizationType = .allCharacters
        zipCodeTextField.borderStyle = .roundedRect
        zipCodeTextField.tag = 12
        zipCodeTextField.delegate = self
        contentView.addSubview(zipCodeTextField)
        
        usernameTextField.backgroundColor = .white
        usernameTextField.textColor = .black
        usernameTextField.placeholder = "Username"
        usernameTextField.autocapitalizationType = .none
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.tag = 1
        usernameTextField.delegate = self
        contentView.addSubview(usernameTextField)
        
        passwordTextField.backgroundColor = .white
        passwordTextField.textColor = .black
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true //dots entered characters
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.tag = 2
        passwordTextField.delegate = self
        contentView.addSubview(passwordTextField)
        
        passwordCompareTextField.backgroundColor = .white
        passwordCompareTextField.textColor = .black
        passwordCompareTextField.placeholder = "Re-Enter Password"
        passwordCompareTextField.autocapitalizationType = .none
        passwordCompareTextField.isSecureTextEntry = true //dots entered characters
        passwordCompareTextField.borderStyle = .roundedRect
        passwordCompareTextField.tag = 3
        passwordCompareTextField.delegate = self
        contentView.addSubview(passwordCompareTextField)
        
        registerAccountBtn.setTitle("Register Account", for: .normal)
        registerAccountBtn.backgroundColor = .blue
        registerAccountBtn.setTitleColor(.white, for: .normal)
        registerAccountBtn.layer.borderWidth = 2
        registerAccountBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor //white
        registerAccountBtn.addTarget(self, action: #selector(registerAccountBtnPressed), for: .touchUpInside)
        contentView.addSubview(registerAccountBtn)
        
        
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator)
        
    }
    
    private func setupLayoutConstraints(){
//        logoImage.translatesAutoresizingMaskIntoConstraints = false
//        logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
//        logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.1)).isActive = true
//        logoImage.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.15)).isActive = true
//        logoImage.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.35)).isActive = true
        
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        firstNameTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        lastNameTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
//        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
//        phoneLabel.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
//        phoneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phoneLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.15)).isActive = true
//        phoneLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//
//        phonePlusLabel.translatesAutoresizingMaskIntoConstraints = false
//        phonePlusLabel.leftAnchor.constraint(equalTo: phoneLabel.rightAnchor, constant: (UIScreen.main.bounds.width * 0.01)).isActive = true
//        phonePlusLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phonePlusLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.03)).isActive = true
//        phonePlusLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//
//        phoneCountryCodeTextField.translatesAutoresizingMaskIntoConstraints = false
//        phoneCountryCodeTextField.leftAnchor.constraint(equalTo: phonePlusLabel.rightAnchor, constant: (UIScreen.main.bounds.width * 0.01)).isActive = true
//        phoneCountryCodeTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phoneCountryCodeTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.075)).isActive = true
//        phoneCountryCodeTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//
//        phoneDashOneLabel.translatesAutoresizingMaskIntoConstraints = false
//        phoneDashOneLabel.leftAnchor.constraint(equalTo: phoneCountryCodeTextField.rightAnchor).isActive = true
//        phoneDashOneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phoneDashOneLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//        phoneDashOneLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//
//        phoneAreaCodeTextField.translatesAutoresizingMaskIntoConstraints = false
//        phoneAreaCodeTextField.leftAnchor.constraint(equalTo: phoneDashOneLabel.rightAnchor).isActive = true
//        phoneAreaCodeTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phoneAreaCodeTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.14)).isActive = true
//        phoneAreaCodeTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//
//        phoneDashTwoLabel.translatesAutoresizingMaskIntoConstraints = false
//        phoneDashTwoLabel.leftAnchor.constraint(equalTo: phoneAreaCodeTextField.rightAnchor).isActive = true
//        phoneDashTwoLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phoneDashTwoLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//        phoneDashTwoLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//
//        phoneFirstThreeDigitTextField.translatesAutoresizingMaskIntoConstraints = false
//        phoneFirstThreeDigitTextField.leftAnchor.constraint(equalTo: phoneDashTwoLabel.rightAnchor).isActive = true
//        phoneFirstThreeDigitTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phoneFirstThreeDigitTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.14)).isActive = true
//        phoneFirstThreeDigitTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//
//        phoneDashThreeLabel.translatesAutoresizingMaskIntoConstraints = false
//        phoneDashThreeLabel.leftAnchor.constraint(equalTo: phoneFirstThreeDigitTextField.rightAnchor).isActive = true
//        phoneDashThreeLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phoneDashThreeLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.025)).isActive = true
//        phoneDashThreeLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
//
//        phoneLastFourDigitTextField.translatesAutoresizingMaskIntoConstraints = false
//        phoneLastFourDigitTextField.leftAnchor.constraint(equalTo: phoneDashThreeLabel.rightAnchor).isActive = true
//        phoneLastFourDigitTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
//        phoneLastFourDigitTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.17)).isActive = true
//        phoneLastFourDigitTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        passwordCompareTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordCompareTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordCompareTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        passwordCompareTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        passwordCompareTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        address1TextField.translatesAutoresizingMaskIntoConstraints = false
        address1TextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        address1TextField.topAnchor.constraint(equalTo: passwordCompareTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        address1TextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        address1TextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        address2TextField.translatesAutoresizingMaskIntoConstraints = false
        address2TextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        address2TextField.topAnchor.constraint(equalTo: address1TextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        address2TextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        address2TextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        cityTextField.topAnchor.constraint(equalTo: address2TextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        cityTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        cityTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        provinceTextField.translatesAutoresizingMaskIntoConstraints = false
        provinceTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        provinceTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        provinceTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        provinceTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        countryTextField.translatesAutoresizingMaskIntoConstraints = false
        countryTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        countryTextField.topAnchor.constraint(equalTo: provinceTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        countryTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        countryTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        zipCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        zipCodeTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        zipCodeTextField.topAnchor.constraint(equalTo: countryTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        zipCodeTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        zipCodeTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        registerAccountBtn.translatesAutoresizingMaskIntoConstraints = false
        registerAccountBtn.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        registerAccountBtn.topAnchor.constraint(equalTo: zipCodeTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.08)).isActive = true
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
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
        passwordCompareTextField.text = ""
        address1TextField.text = ""
        address2TextField.text = ""
        cityTextField.text = ""
        provinceTextField.text = ""
        countryTextField.text = ""
        zipCodeTextField.text = ""
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
        
//        do{
//            //TODO parse number string
//            var numberString = phoneTextField.text!
//
//            numberString = numberString.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
//            numberString = numberString.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
//            numberString = numberString.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
//            numberString = numberString.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
//
//            let validatedPhoneNumber = try phoneNumberKit.parse(numberString)
//        }catch {
//
//            print(error)
//
//            DispatchQueue.main.async {
//                self.scanningIndicator.stopAnimating()
//            }
//
//            self.showToast(controller: self, message: "Must Enter a Valid Phone Number", seconds: 1)
//
//            phoneTextField.text = ""
//
//            return
//        }
        
        
        //client side checks
        if(firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || usernameTextField.text == "" || passwordTextField.text == "" || passwordCompareTextField.text == "" || address1TextField.text == "" || cityTextField.text == "" || countryTextField.text == "" || provinceTextField.text == "" ||
            zipCodeTextField.text == ""){
            
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
        
        
        
        var numberString = phoneTextField.text!
        //parse phone string
        numberString = numberString.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        numberString = numberString.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        numberString = numberString.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        numberString = numberString.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        
        
        let jsonRegisterObject: [String: Any] = [
            "username": usernameTextField.text!,
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "firstName": firstNameTextField.text!,
            "lastName": lastNameTextField.text!,
            "phone": numberString,
            "address1": address1TextField.text!,
            "address2": address2TextField.text!,
            "city": cityTextField.text!,
            "country": countryTextField.text!,
            "province": provinceTextField.text!,
            "zipCode": zipCodeTextField.text!
        ]
        
        
        var registerJSONData: Data? = nil
        
        if(JSONSerialization.isValidJSONObject(jsonRegisterObject)){
            do{
                registerJSONData = try JSONSerialization.data(withJSONObject: jsonRegisterObject, options: [])
            }catch{
                print("Problem while serializing jsonLoginObject")
                self.showToast(controller: self, message: "A problem occured", seconds: 1)
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
                    return
                }
                print("Error occured during /register RESTAPI request")
            }
            else{
                DispatchQueue.main.async {
                    self.scanningIndicator.stopAnimating()
                    //self.showToast(controller: self, message: String(decoding: data!, as: UTF8.self), seconds: 1)
                }
                
                
                print("Response:")
                print(response!)
                print("Data:")
                print(String(decoding: data!, as: UTF8.self))
                
                let userID = ((response! as! HTTPURLResponse).allHeaderFields["User-Id"] as? String)
                
                
                if(userID == nil){ //something happened - username/email already taken or not verified- let user know and return
                    DispatchQueue.main.async {
                        self.emailTextField.text = ""
                        self.firstNameTextField.text = ""
                        self.lastNameTextField.text = ""
                        self.phoneTextField.text = ""
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.passwordCompareTextField.text = ""
                        self.address1TextField.text = ""
                        self.address2TextField.text = ""
                        self.cityTextField.text = ""
                        self.countryTextField.text = ""
                        self.provinceTextField.text = ""
                        self.zipCodeTextField.text = ""
                        
                        self.showToast(controller: self, message: "An error happened, please retry", seconds: 1)
                    }
                    return
                }
                    
                else{ //authenticated - save JWT authencation token into iOS Keychain & set authorizedSession in AppDelegate to true
                    
                    print("User ID: ")
                    print(userID!)
                    
                    var email: String? = nil
                    var password: String? = nil
                    var firstName: String? = nil
                    var lastName: String? = nil
                    var phone: String? = nil
                    var address1: String? = nil
                    var address2: String? = nil
                    var city: String? = nil
                    var country: String? = nil
                    var province: String? = nil
                    var zipCode: String? = nil
                    
                    DispatchQueue.main.sync{
                        email = self.emailTextField.text
                        password = self.passwordTextField.text
                        firstName = self.firstNameTextField.text
                        lastName = self.lastNameTextField.text
                        phone = self.phoneTextField.text!
                        //parse phone string
                        phone = phone!.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
                        phone = phone!.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
                        phone = phone!.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
                        phone = phone!.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                        address1 = self.address1TextField.text
                        address2 = self.address2TextField.text
                        city = self.cityTextField.text
                        country = self.countryTextField.text
                        province = self.provinceTextField.text
                        zipCode = self.zipCodeTextField.text
                    }
                    
                    //CREATE THE USER'S SHOPIFY ACCOUNT RIGHT HERE - WHEN THEY REGISTER AN ACCOUNT THIS REGISTERS A NEW SHOPIFY ACCOUNT FOR THEM AS WELL
                    let customerCreateInput = Storefront.CustomerCreateInput.create(
                        email: email!,
                        password: password!,
                        firstName: .value(firstName!),
                        lastName: .value(lastName!),
                        phone: .value(phone!),
                        acceptsMarketing: .value(true)
                    )
                    
                    let customerCreateMutation = Storefront.buildMutation{ $0
                        .customerCreate(input: customerCreateInput){ $0
                            .customer{ $0
                                .id()
                                .email()
                                .firstName()
                                .lastName()
                                .phone()
                                .acceptsMarketing()
                            }
                            .customerUserErrors{ $0
                                .field()
                                .message()
                            }
                        }
                    
                    }
                    
                    
                    let customerCreateTask = self.client.mutateGraphWith(customerCreateMutation) { result, error in

                        print(result)

                        if(error != nil){
                            //handle request errors
                            print("A request error occured creating Shopify customer account")
                            print(error!)
                            
                            DispatchQueue.main.async {
                                                   self.emailTextField.text = ""
                                                   self.firstNameTextField.text = ""
                                                   self.lastNameTextField.text = ""
                                                   self.phoneTextField.text = ""
                                                   self.usernameTextField.text = ""
                                                   self.passwordTextField.text = ""
                                                   self.passwordCompareTextField.text = ""
                                                   self.address1TextField.text = ""
                                                   self.address2TextField.text = ""
                                                   self.cityTextField.text = ""
                                                   self.countryTextField.text = ""
                                                   self.provinceTextField.text = ""
                                                   self.zipCodeTextField.text = ""
                                                   
                                self.showToast(controller: self, message: "An error happened, please retry", seconds: 1)
                                               }
                            
                            
                            var userDeleteRequest = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user/delete")!)
                            userDeleteRequest.httpMethod = "POST"
                            userDeleteRequest.httpBody = registerJSONData
                            userDeleteRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
                            userDeleteRequest.setValue(userID!, forHTTPHeaderField: "user-id")
                            
                            let userDeleteTask = URLSession.shared.dataTask(with: userDeleteRequest) { data, response, error in
                                if(error != nil){
                                    DispatchQueue.main.async {
                                        self.scanningIndicator.stopAnimating()
                                        self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                                        return
                                    }
                                    print("Error occured during /user/delete RESTAPI request")
                                }
                                else{
                                    print("Response:")
                                    print(response!)
                                    print("Data:")
                                    print(String(decoding: data!, as: UTF8.self))
                                    
                                    
                                    if(String(decoding: data!, as: UTF8.self) != "Success"){
                                         print("error occured deleting user")
                                                           
                                        return
                                    }
                                    else{
                                        print("Succesfully deleted customer from CPS account")
                                    }
                                }
                            }
                            userDeleteTask.resume()
                            
                            
                            
                            return
                        }
                        
                        if(result?.customerCreate?.customerUserErrors.isEmpty == false){
                            //handle user errors
                            print("A user error occured creating Shopify customer account")
                            print(result?.customerCreate?.customerUserErrors.first?.message)
                            
                            
                            DispatchQueue.main.async {
                                                   self.emailTextField.text = ""
                                                   self.firstNameTextField.text = ""
                                                   self.lastNameTextField.text = ""
                                                   self.phoneTextField.text = ""
                                                   self.usernameTextField.text = ""
                                                   self.passwordTextField.text = ""
                                                   self.passwordCompareTextField.text = ""
                                                   self.address1TextField.text = ""
                                                   self.address2TextField.text = ""
                                                   self.cityTextField.text = ""
                                                   self.countryTextField.text = ""
                                                   self.provinceTextField.text = ""
                                                   self.zipCodeTextField.text = ""
                                                   
                                self.showToast(controller: self, message: (result?.customerCreate?.customerUserErrors.first!.message)!, seconds: 1)
                                               }
                            
                            var userDeleteRequest = URLRequest(url: URL(string: "https://pacific-ridge-88217.herokuapp.com/user/delete")!)
                            userDeleteRequest.httpMethod = "POST"
                            userDeleteRequest.httpBody = registerJSONData
                            userDeleteRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
                            userDeleteRequest.setValue(userID!, forHTTPHeaderField: "user-id")
                            
                            let userDeleteTask = URLSession.shared.dataTask(with: userDeleteRequest) { data, response, error in
                                if(error != nil){
                                    DispatchQueue.main.async {
                                        self.scanningIndicator.stopAnimating()
                                        self.showToast(controller: self, message: "Error: " + (error as! String), seconds: 1)
                                        return
                                    }
                                    print("Error occured during /user/delete RESTAPI request")
                                }
                                else{
                                    print("Response:")
                                    print(response!)
                                    print("Data:")
                                    print(String(decoding: data!, as: UTF8.self))
                                    
                                    
                                    if(String(decoding: data!, as: UTF8.self) != "Success"){
                                         print("error occured deleting user")
                                                           
                                        return
                                    }
                                    else{
                                        print("Succesfully deleted customer from CPS account")
                                    }
                                }
                            }
                            userDeleteTask.resume()
                            
                            return
                        }
                        
                        //print(result?.customerCreate?.customerUserErrors.first?.message)
                        
                        let loginInput = Storefront.CustomerAccessTokenCreateInput.create(
                            email: self.emailTextField.text!,
                            password: self.passwordTextField.text!
                        )
                        
                        let loginMutation = Storefront.buildMutation{ $0
                            .customerAccessTokenCreate(input: loginInput){ $0
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
                        
                        let loginTask = self.client.mutateGraphWith(loginMutation) { result, error in
                            
                            print(result)
                            
                                if(error != nil){
                                    //handle request errors
                                    print("A request error occured creating Shopify customer account")
                                    print(error!)
                                    
                                    DispatchQueue.main.async {
                                                           self.emailTextField.text = ""
                                                           self.firstNameTextField.text = ""
                                                           self.lastNameTextField.text = ""
                                                           self.phoneTextField.text = ""
                                                           self.usernameTextField.text = ""
                                                           self.passwordTextField.text = ""
                                                           self.passwordCompareTextField.text = ""
                                                           self.address1TextField.text = ""
                                                           self.address2TextField.text = ""
                                                           self.cityTextField.text = ""
                                                           self.countryTextField.text = ""
                                                           self.provinceTextField.text = ""
                                                           self.zipCodeTextField.text = ""
                                                           
                                                           self.showToast(controller: self, message: "An error happened, please retry", seconds: 1)
                                                       }
                                    
                                    
                                    return
                                }
                                               
                            if(result?.customerAccessTokenCreate?.customerUserErrors.isEmpty == false){
                                    //handle user errors
                                    print("A user error occured creating Shopify customer account")
                                    
                                    DispatchQueue.main.async {
                                                           self.emailTextField.text = ""
                                                           self.firstNameTextField.text = ""
                                                           self.lastNameTextField.text = ""
                                                           self.phoneTextField.text = ""
                                                           self.usernameTextField.text = ""
                                                           self.passwordTextField.text = ""
                                                           self.passwordCompareTextField.text = ""
                                                           self.address1TextField.text = ""
                                                           self.address2TextField.text = ""
                                                           self.cityTextField.text = ""
                                                           self.countryTextField.text = ""
                                                           self.provinceTextField.text = ""
                                                           self.zipCodeTextField.text = ""
                                                           
                                                           self.showToast(controller: self, message: "An error happened, please retry", seconds: 1)
                                                       }
                                    
                                    return
                                }
                            
                            let accessToken = (result?.customerAccessTokenCreate?.customerAccessToken!.accessToken)!
                            
                            let addressInput = Storefront.MailingAddressInput.create(
                                address1: .value(address1!),
                                address2: .value(address2!),
                                city: .value(city!),
                                country: .value(country!),
                                firstName: .value(firstName!),
                                lastName: .value(lastName!),
                                phone: .value(phone!),
                                province: .value(province!),
                                zip: .value(zipCode!)
                            )
                            
                            let addressMutation = Storefront.buildMutation{ $0
                                .customerAddressCreate(customerAccessToken: accessToken, address: addressInput){ $0
                                    .customerAddress{ $0
                                        .id()
                                        .address1()
                                    }
                                    .customerUserErrors { $0
                                        .field()
                                        .message()
                                    }
                                }
                                
                            }
                            
                            let addressTask = self.client.mutateGraphWith(addressMutation) { result, error in
                                if(error != nil){
                                    //handle request errors
                                    print("A request error occured creating Shopify customer account")
                                    print(error!)
                                    
                                    DispatchQueue.main.async {
                                                           self.emailTextField.text = ""
                                                           self.firstNameTextField.text = ""
                                                           self.lastNameTextField.text = ""
                                                           self.phoneTextField.text = ""
                                                           self.usernameTextField.text = ""
                                                           self.passwordTextField.text = ""
                                                           self.passwordCompareTextField.text = ""
                                                           self.address1TextField.text = ""
                                                           self.address2TextField.text = ""
                                                           self.cityTextField.text = ""
                                                           self.countryTextField.text = ""
                                                           self.provinceTextField.text = ""
                                                           self.zipCodeTextField.text = ""
                                                           
                                                           self.showToast(controller: self, message: "An error happened, please retry", seconds: 1)
                                                       }
                                    
                                    return
                                }
                                           
                                if(result?.customerAddressCreate?.customerUserErrors.isEmpty == false){
                                    //handle user errors
                                    print("A user error occured creating Shopify customer account")
                                    
                                    DispatchQueue.main.async {
                                                           self.emailTextField.text = ""
                                                           self.firstNameTextField.text = ""
                                                           self.lastNameTextField.text = ""
                                                           self.phoneTextField.text = ""
                                                           self.usernameTextField.text = ""
                                                           self.passwordTextField.text = ""
                                                           self.passwordCompareTextField.text = ""
                                                           self.address1TextField.text = ""
                                                           self.address2TextField.text = ""
                                                           self.cityTextField.text = ""
                                                           self.countryTextField.text = ""
                                                           self.provinceTextField.text = ""
                                                           self.zipCodeTextField.text = ""
                                                           
                                                           self.showToast(controller: self, message: "An error happened, please retry", seconds: 1)
                                                       }
                                    
                                    return
                                }
                                
                                //handle proper creation
                                print("Shopify customer account succesfully created")
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ //go after 1 second from now you that you know the toast is complete
                                    self.navigationController?.popViewController(animated: true)
                                }
                                
                            }
                            addressTask.resume()
                            
                        }
                        loginTask.resume()
                        
                    }
                    
                    customerCreateTask.resume()
                    
                    
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
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag == 6 && textField.text == ""){ //if its the phone number text field and its empty add the country code to it
            let countryCode = NSLocale.current.regionCode
            phoneTextField.text = "+" + self.getCountryPhonceCode(countryCode!)
        }
    }

    
    @objc private func editPhoneTextFieldRealTime(){
        
        if(phoneTextField.text!.count > currentPhoneNumberText.count){ //checks that things are not being deleted
            if(phoneTextField.text!.count == (self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 4)){
                let strOriginal = phoneTextField.text
                var strNew = strOriginal
                strNew?.insert(contentsOf: " (", at: (strOriginal?.index(strOriginal!.startIndex, offsetBy: self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 1))!)
                let strMid = strNew
                strNew?.insert(contentsOf: ") ", at: (strMid?.index(strMid!.startIndex, offsetBy: self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 6))!)
                phoneTextField.text = strNew
            }

            else if(phoneTextField.text!.count == (self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 11)){
                let strOriginal = phoneTextField.text
                var strNew = strOriginal
                strNew?.insert(contentsOf: "-", at: (strOriginal?.index(strOriginal!.startIndex, offsetBy: self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 11))!)
                phoneTextField.text = strNew
            }
        }
        else{ //if stuff is being deleted
            if(phoneTextField.text!.count == (self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 12)){
                let strOriginal = phoneTextField.text
                var strNew = strOriginal
                strNew?.remove(at: (strOriginal?.index(strOriginal!.startIndex, offsetBy: self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 11))!)
                phoneTextField.text = strNew
            }
            
            else if(phoneTextField.text!.count == (self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 8)){
                let strOriginal = phoneTextField.text
                var strNew = strOriginal
                strNew?.remove(at: (strOriginal?.index(strOriginal!.startIndex, offsetBy: self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 7))!)
                
                let strMid = strNew
                strNew?.remove(at: (strMid?.index(strMid!.startIndex, offsetBy: self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 6))!)
                
                phoneTextField.text = strNew
            }

            else if(phoneTextField.text!.count == (self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 3)){
                let strOriginal = phoneTextField.text
                var strNew = strOriginal
                strNew?.remove(at: (strOriginal?.index(strOriginal!.startIndex, offsetBy: self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 2))!)
                
                let strMid = strNew
                strNew?.remove(at: (strMid?.index(strMid!.startIndex, offsetBy: self.getCountryPhonceCode(NSLocale.current.regionCode!).count + 1))!)
                
                phoneTextField.text = strNew
            }
            
        }
        
        
        self.currentPhoneNumberText = phoneTextField.text!
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
        else if(textField.tag == 4){
            firstNameTextField.endEditing(true)
        }
        else if(textField.tag == 5){
            lastNameTextField.endEditing(true)
        }
        else if(textField.tag == 6){
            phoneTextField.endEditing(true)
          
        }
        else if(textField.tag == 7){
            address1TextField.endEditing(true)
        }
        else if(textField.tag == 8){
            address2TextField.endEditing(true)
        }
        else if(textField.tag == 9){
            cityTextField.endEditing(true)
        }
        else if(textField.tag == 10){
            countryTextField.endEditing(true)
        }
        else if(textField.tag == 11){
            provinceTextField.endEditing(true)
        }
        else if(textField.tag == 12){
            zipCodeTextField.endEditing(true)
        }
//        else if(textField.tag == 13){
//            phoneAreaCodeTextField.endEditing(true)
//        }
//        else if(textField.tag == 14){
//            phoneFirstThreeDigitTextField.endEditing(true)
//        }
//        else if(textField.tag == 15){
//            phoneLastFourDigitTextField.endEditing(true)
//        }
        return true
    }
    
    
    
    
    func getCountryPhonceCode (_ country : String) -> String
    {
        var countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
                                  "AI":"1",
                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
                                  "DM":"1",
                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
                                  "GD":"1",
                                  "GP":"590",
                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
                                  "KN":"1",
                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340"]
        if let countryCode = countryDictionary[country] {
            return countryCode
        }
        return ""
    }
    
    
    
    
}



