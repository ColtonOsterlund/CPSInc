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
import Buy


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
    let phoneCountryCodeTextField = UITextField()
    let phoneAreaCodeTextField = UITextField()
    let phoneFirstThreeDigitTextField = UITextField()
    let phoneLastFourDigitTextField = UITextField()
    let phonePlusLabel = UILabel()
    let phoneDashOneLabel = UILabel()
    let phoneDashTwoLabel = UILabel()
    let phoneDashThreeLabel = UILabel()
    let phoneLabel = UILabel()
    
    let address1TextField = UITextField()
    let address2TextField = UITextField()
    let cityTextField = UITextField()
    let countryTextField = UITextField()
    let provinceTextField = UITextField()
    let zipCodeTextField = UITextField()
    
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordCompareTextField = UITextField()
    
    //UIButtons
    let registerAccountBtn = UIButton()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    //Buy SDK client
    let client = Graph.Client(shopDomain: "creative-protein-solutions.myshopify.com", apiKey: "28893d9e78d310dde27dde211fa414d7")
    
    
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
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.4)
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
        
        phonePlusLabel.text = "+"
        phonePlusLabel.textColor = .black
        phonePlusLabel.textAlignment = .center
        phonePlusLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        contentView.addSubview(phonePlusLabel)
        
        phoneLabel.text = "Phone:"
        phoneLabel.textColor = .gray
        phoneLabel.textAlignment = .center
        //phoneLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        contentView.addSubview(phoneLabel)
        
        phoneDashOneLabel.text = "-"
        phoneDashOneLabel.textColor = .black
        phoneDashOneLabel.textAlignment = .center
        phoneDashOneLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        contentView.addSubview(phoneDashOneLabel)
        
        phoneDashTwoLabel.text = "-"
        phoneDashTwoLabel.textColor = .black
        phoneDashTwoLabel.textAlignment = .center
        phoneDashTwoLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        contentView.addSubview(phoneDashTwoLabel)
        
        phoneDashThreeLabel.text = "-"
        phoneDashThreeLabel.textColor = .black
        phoneDashThreeLabel.textAlignment = .center
        phoneDashThreeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        contentView.addSubview(phoneDashThreeLabel)
        
        phoneCountryCodeTextField.backgroundColor = .white
        phoneCountryCodeTextField.textColor = .black
        phoneCountryCodeTextField.placeholder = "x"
        phoneCountryCodeTextField.keyboardType = .numberPad
        phoneCountryCodeTextField.autocapitalizationType = .none
        phoneCountryCodeTextField.borderStyle = .roundedRect
        phoneCountryCodeTextField.tag = 6
        phoneCountryCodeTextField.delegate = self
        contentView.addSubview(phoneCountryCodeTextField)
        
        phoneAreaCodeTextField.backgroundColor = .white
        phoneAreaCodeTextField.textColor = .black
        phoneAreaCodeTextField.placeholder = "xxx"
        phoneAreaCodeTextField.keyboardType = .numberPad
        phoneAreaCodeTextField.autocapitalizationType = .none
        phoneAreaCodeTextField.borderStyle = .roundedRect
        phoneAreaCodeTextField.tag = 13
        phoneAreaCodeTextField.delegate = self
        contentView.addSubview(phoneAreaCodeTextField)
        
        phoneFirstThreeDigitTextField.backgroundColor = .white
        phoneFirstThreeDigitTextField.textColor = .black
        phoneFirstThreeDigitTextField.placeholder = "xxx"
        phoneFirstThreeDigitTextField.keyboardType = .numberPad
        phoneFirstThreeDigitTextField.autocapitalizationType = .none
        phoneFirstThreeDigitTextField.borderStyle = .roundedRect
        phoneFirstThreeDigitTextField.tag = 14
        phoneFirstThreeDigitTextField.delegate = self
        contentView.addSubview(phoneFirstThreeDigitTextField)
        
        phoneLastFourDigitTextField.backgroundColor = .white
        phoneLastFourDigitTextField.textColor = .black
        phoneLastFourDigitTextField.placeholder = "xxxx"
        phoneLastFourDigitTextField.keyboardType = .numberPad
        phoneLastFourDigitTextField.autocapitalizationType = .none
        phoneLastFourDigitTextField.borderStyle = .roundedRect
        phoneLastFourDigitTextField.tag = 15
        phoneLastFourDigitTextField.delegate = self
        contentView.addSubview(phoneLastFourDigitTextField)
        
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
        
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.15)).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phonePlusLabel.translatesAutoresizingMaskIntoConstraints = false
        phonePlusLabel.leftAnchor.constraint(equalTo: phoneLabel.rightAnchor, constant: (UIScreen.main.bounds.width * 0.01)).isActive = true
        phonePlusLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phonePlusLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.03)).isActive = true
        phonePlusLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phoneCountryCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneCountryCodeTextField.leftAnchor.constraint(equalTo: phonePlusLabel.rightAnchor, constant: (UIScreen.main.bounds.width * 0.01)).isActive = true
        phoneCountryCodeTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneCountryCodeTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.075)).isActive = true
        phoneCountryCodeTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phoneDashOneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneDashOneLabel.leftAnchor.constraint(equalTo: phoneCountryCodeTextField.rightAnchor).isActive = true
        phoneDashOneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneDashOneLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        phoneDashOneLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phoneAreaCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneAreaCodeTextField.leftAnchor.constraint(equalTo: phoneDashOneLabel.rightAnchor).isActive = true
        phoneAreaCodeTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneAreaCodeTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.14)).isActive = true
        phoneAreaCodeTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phoneDashTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneDashTwoLabel.leftAnchor.constraint(equalTo: phoneAreaCodeTextField.rightAnchor).isActive = true
        phoneDashTwoLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneDashTwoLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        phoneDashTwoLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phoneFirstThreeDigitTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneFirstThreeDigitTextField.leftAnchor.constraint(equalTo: phoneDashTwoLabel.rightAnchor).isActive = true
        phoneFirstThreeDigitTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneFirstThreeDigitTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.14)).isActive = true
        phoneFirstThreeDigitTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phoneDashThreeLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneDashThreeLabel.leftAnchor.constraint(equalTo: phoneFirstThreeDigitTextField.rightAnchor).isActive = true
        phoneDashThreeLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneDashThreeLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        phoneDashThreeLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        phoneLastFourDigitTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneLastFourDigitTextField.leftAnchor.constraint(equalTo: phoneDashThreeLabel.rightAnchor).isActive = true
        phoneLastFourDigitTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
        phoneLastFourDigitTextField.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.17)).isActive = true
        phoneLastFourDigitTextField.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: phoneCountryCodeTextField.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.04)).isActive = true
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
        phoneCountryCodeTextField.text = ""
        phoneAreaCodeTextField.text = ""
        phoneFirstThreeDigitTextField.text = ""
        phoneLastFourDigitTextField.text = ""
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
        
        
        
        
        let jsonRegisterObject: [String: Any] = [
            "username": usernameTextField.text!,
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "firstName": firstNameTextField.text!,
            "lastName": lastNameTextField.text!,
            "phone": "+" + phoneCountryCodeTextField.text! + phoneAreaCodeTextField.text! + phoneFirstThreeDigitTextField.text! + phoneLastFourDigitTextField.text!,
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
                        self.firstNameTextField.text = ""
                        self.lastNameTextField.text = ""
                        self.phoneCountryCodeTextField.text = ""
                        self.phoneAreaCodeTextField.text = ""
                        self.phoneFirstThreeDigitTextField.text = ""
                        self.phoneLastFourDigitTextField.text = ""
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
                        phone = "+" + self.phoneCountryCodeTextField.text! + self.phoneAreaCodeTextField.text! + self.phoneFirstThreeDigitTextField.text! + self.phoneLastFourDigitTextField.text!
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

                        guard error == nil else{
                            //handle request errors
                            print("A request error occured creating Shopify customer account")
                            print(error!)
                            
                            DispatchQueue.main.async {
                                                   self.emailTextField.text = ""
                                                   self.firstNameTextField.text = ""
                                                   self.lastNameTextField.text = ""
                                                   self.phoneCountryCodeTextField.text = ""
                                                   self.phoneAreaCodeTextField.text = ""
                                                   self.phoneFirstThreeDigitTextField.text = ""
                                                   self.phoneLastFourDigitTextField.text = ""
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
                        
                        guard let userError = result?.customerCreate?.customerUserErrors else{
                            //handle user errors
                            print("A user error occured creating Shopify customer account")
                            print(result?.customerCreate?.userErrors.first?.message)
                            
                            
                            DispatchQueue.main.async {
                                                   self.emailTextField.text = ""
                                                   self.firstNameTextField.text = ""
                                                   self.lastNameTextField.text = ""
                                                   self.phoneCountryCodeTextField.text = ""
                                                   self.phoneAreaCodeTextField.text = ""
                                                   self.phoneFirstThreeDigitTextField.text = ""
                                                   self.phoneLastFourDigitTextField.text = ""
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
                            
                                guard error == nil else{
                                    //handle request errors
                                    print("A request error occured creating Shopify customer account")
                                    print(error!)
                                    
                                    DispatchQueue.main.async {
                                                           self.emailTextField.text = ""
                                                           self.firstNameTextField.text = ""
                                                           self.lastNameTextField.text = ""
                                                           self.phoneCountryCodeTextField.text = ""
                                                           self.phoneAreaCodeTextField.text = ""
                                                           self.phoneFirstThreeDigitTextField.text = ""
                                                           self.phoneLastFourDigitTextField.text = ""
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
                                               
                                guard let userError = result?.customerAccessTokenCreate?.customerUserErrors else{
                                    //handle user errors
                                    print("A user error occured creating Shopify customer account")
                                    
                                    DispatchQueue.main.async {
                                                           self.emailTextField.text = ""
                                                           self.firstNameTextField.text = ""
                                                           self.lastNameTextField.text = ""
                                                           self.phoneCountryCodeTextField.text = ""
                                                           self.phoneAreaCodeTextField.text = ""
                                                           self.phoneFirstThreeDigitTextField.text = ""
                                                           self.phoneLastFourDigitTextField.text = ""
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
                                guard error == nil else{
                                    //handle request errors
                                    print("A request error occured creating Shopify customer account")
                                    print(error!)
                                    
                                    DispatchQueue.main.async {
                                                           self.emailTextField.text = ""
                                                           self.firstNameTextField.text = ""
                                                           self.lastNameTextField.text = ""
                                                           self.phoneCountryCodeTextField.text = ""
                                                           self.phoneAreaCodeTextField.text = ""
                                                           self.phoneFirstThreeDigitTextField.text = ""
                                                           self.phoneLastFourDigitTextField.text = ""
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
                                           
                                guard let userError = result?.customerAddressCreate?.customerUserErrors else{
                                    //handle user errors
                                    print("A user error occured creating Shopify customer account")
                                    
                                    DispatchQueue.main.async {
                                                           self.emailTextField.text = ""
                                                           self.firstNameTextField.text = ""
                                                           self.lastNameTextField.text = ""
                                                           self.phoneCountryCodeTextField.text = ""
                                                           self.phoneAreaCodeTextField.text = ""
                                                           self.phoneFirstThreeDigitTextField.text = ""
                                                           self.phoneLastFourDigitTextField.text = ""
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
            phoneCountryCodeTextField.endEditing(true)
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
        else if(textField.tag == 13){
            phoneAreaCodeTextField.endEditing(true)
        }
        else if(textField.tag == 14){
            phoneFirstThreeDigitTextField.endEditing(true)
        }
        else if(textField.tag == 15){
            phoneLastFourDigitTextField.endEditing(true)
        }
        return true
    }
    
}
