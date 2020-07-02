//
//  ShopifyCheckoutViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-06-12.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import Buy
import SwiftKeychainWrapper
import SafariServices


class ShopifyCheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    //views
    private var storeView: ShopifyStorePagesViewController? = nil
    
    private var itemIDsInCart = [String]()
    private var itemNamesInCart = [String]()
    private var itemAmountsInCart = [Int]()
    
    
    private let removeFromCartBtn = UIButton()
    private let proceedToPaymentBtn = UIButton()
    
    private let tableView = UITableView()
    
    
    private var selectedIndex: Int? = nil
    
    
    let client = Graph.Client(shopDomain: "creative-protein-solutions.myshopify.com", apiKey: "28893d9e78d310dde27dde211fa414d7")
    
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(storeView: ShopifyStorePagesViewController?) {
        self.init(nibName:nil, bundle:nil)
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Checkout"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        
        setupLayoutComponents()
        setupLayoutConstraints()
        setButtonListeners()
    }
    
    
    private func setupLayoutComponents(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        
        //removeFromCartBtn
        removeFromCartBtn.backgroundColor = .blue
        removeFromCartBtn.setTitle("Remove from Cart", for: .normal)
        removeFromCartBtn.setTitleColor(.white, for: .normal)
        removeFromCartBtn.layer.borderWidth = 2
        removeFromCartBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(removeFromCartBtn)
        removeFromCartBtn.isHidden = true
        
        
        //proceedToPaymentBtn
        proceedToPaymentBtn.backgroundColor = .blue
        proceedToPaymentBtn.setTitle("Proceed to Payment", for: .normal)
        proceedToPaymentBtn.setTitleColor(.white, for: .normal)
        proceedToPaymentBtn.layer.borderWidth = 2
        proceedToPaymentBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(proceedToPaymentBtn)
        
    }
    
    private func setupLayoutConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.25)).isActive = true
        
        proceedToPaymentBtn.translatesAutoresizingMaskIntoConstraints = false
        proceedToPaymentBtn.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        proceedToPaymentBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        proceedToPaymentBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        proceedToPaymentBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        removeFromCartBtn.translatesAutoresizingMaskIntoConstraints = false
        removeFromCartBtn.topAnchor.constraint(equalTo: proceedToPaymentBtn.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        removeFromCartBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        removeFromCartBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        removeFromCartBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func setButtonListeners(){
        proceedToPaymentBtn.addTarget(self, action: #selector(proceedToPaymentBtnPressed), for: .touchUpInside)
        
        removeFromCartBtn.addTarget(self, action: #selector(removeFromCartBtnPressed), for: .touchUpInside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    
    @objc private func proceedToPaymentBtnPressed(){
        
        
        let query = Storefront.buildQuery{ $0
            .customer(customerAccessToken: KeychainWrapper.standard.string(forKey: "Shopify-Access-Token")!){ $0
                .email()
                .addresses(first: 10){ $0
                    .edges{ $0
                        .node{ $0
                            .address1()
                            .address2()
                            .firstName()
                            .lastName()
                            .phone()
                            .city()
                            .province()
                            .country()
                            .zip()
                        }
                    }
                }
            }
        }
        
        let task = self.client.queryGraphWith(query){ result, error in
            guard error == nil else {
                DispatchQueue.main.async{
                    self.showToast(controller: self, message: "A request error occured while checking out", seconds: 1)
                    print(error)
                }
                return
            }

            let email = result?.customer?.email
            let address = result?.customer?.addresses.edges[0].node
            
            print(address?.address1)
            print(address?.zip)
            
            var lineItemArray = [Storefront.CheckoutLineItemInput]()
                        
            var index: Int = 0
                        
            for item in self.itemIDsInCart{
                lineItemArray.append(Storefront.CheckoutLineItemInput.create(quantity: Int32(self.itemAmountsInCart[index]), variantId: GraphQL.ID(rawValue: item)))
                index = index + 1
            }
            
            
                        
            let addressInput = Storefront.MailingAddressInput.create(
                address1: .value(address?.address1), address2: .value(address?.address2), city: .value(address?.city), country: .value(address?.country), firstName: .value(address?.firstName), lastName: .value(address?.lastName), phone: .value(address?.phone), province: .value(address?.province), zip: .value(address?.zip)
            )
                        
            let checkoutInput = Storefront.CheckoutCreateInput.create(
                email: .value(email!),
                lineItems: .value(lineItemArray),
                shippingAddress: .value(addressInput)
            )
                        
            let mutation = Storefront.buildMutation{ $0
                .checkoutCreate(input: checkoutInput){ $0
                    .checkout{ $0
                        .id()
                    }
                    .checkoutUserErrors{ $0
                        .field()
                        .message()
                    }
                }
            }
                        
            let innerTask = self.client.mutateGraphWith(mutation){ result, error in
                guard error == nil else {
                    DispatchQueue.main.async{
                        self.showToast(controller: self, message: "A request error occured while checking out", seconds: 1)
                        print(error)
                    }
                    return
                }

                guard let checkoutUserError = result?.checkoutCreate?.checkoutUserErrors else {
                    DispatchQueue.main.async{
                        self.showToast(controller: self, message: "A user error occured while checking out", seconds: 1)
                    }
                    return
                }

                let checkoutID = result?.checkoutCreate?.checkout?.id //need to keep this for reference for inputting shipping address and such into the checkout later
                            
                print(result)
                
                //poll for shipping rates
                let query = Storefront.buildQuery{ $0
                    .node(id: checkoutID!) { $0
                        .onCheckout { $0
                            .id()
                            .availableShippingRates { $0
                                .ready()
                                .shippingRates { $0
                                    .handle()
                                    .price()
                                    .title()
                                }
                            }
                        }
                    }
                }
                
                let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(10)) { (response, error) -> Bool in
                    return (response?.node as? Storefront.Checkout)?.availableShippingRates?.ready ?? false == false
                }

                let innerInnerTask = self.client.queryGraphWith(query, retryHandler: retry) { response, error in
                    let checkout      = (response?.node as? Storefront.Checkout)
                    let shippingRates = checkout?.availableShippingRates?.shippingRates
                    
                    let updateShippingLineMutation = Storefront.buildMutation { $0
                        .checkoutShippingLineUpdate(checkoutId: checkout!.id, shippingRateHandle: shippingRates![0].handle) { $0 //taking the first shipping rate - might want to instead find the lowest
                            .checkout { $0
                                .id()
                                .webUrl()
                            }
                            .checkoutUserErrors { $0
                                .field()
                                .message()
                            }
                        }
                    }
                    
                    let updateShippingLineTask = self.client.mutateGraphWith(updateShippingLineMutation){ response, error in
                        
                        print(response)
                        
                        guard error == nil else {
                            DispatchQueue.main.async{
                                self.showToast(controller: self, message: "A request error occured while checking out", seconds: 1)
                            }
                            return
                        }

                        guard let checkoutUserError = response?.checkoutShippingLineUpdate?.checkoutUserErrors else {
                            DispatchQueue.main.async{
                                self.showToast(controller: self, message: "A user error occured while checking out", seconds: 1)
                            }
                            return
                        }

                        let checkoutID = response?.checkoutShippingLineUpdate?.checkout?.id //need to keep this for reference for inputting shipping address and such into the checkout later
                        let checkoutURL = response?.checkoutShippingLineUpdate?.checkout?.webUrl //need to keep this for reference for inputting shipping address and such into the checkout later
                        
                        
                        //display web URL to complete transaction
                        let config = SFSafariViewController.Configuration()
                        config.entersReaderIfAvailable = true

                        let vc = SFSafariViewController(url: checkoutURL!, configuration: config)
                        self.present(vc, animated: true)
                        
                        //checkout now being processed online - remove all from cart for when they return to the app
                        self.itemIDsInCart.removeAll()
                        self.itemNamesInCart.removeAll()
                        self.itemAmountsInCart.removeAll()
                        self.storeView?.removeAllItemsFromCart()
                        
                    }
                    updateShippingLineTask.resume()
                    
                    
                }
                innerInnerTask.resume()

            }
            innerTask.resume()
        }
        task.resume()
        
        
                    
    }
    
    
    
    @objc private func removeFromCartBtnPressed(){
        
    }
    
    
    
    public func addItemToCart(itemID: String, itemName: String, quantity: Int){
        self.itemIDsInCart.append(itemID)
        self.itemNamesInCart.append(itemName)
        self.itemAmountsInCart.append(quantity)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNamesInCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let attributedString = NSMutableAttributedString(string: itemNamesInCart[indexPath.row] + "   (" + String(itemAmountsInCart[indexPath.row]) + ")")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: itemNamesInCart[indexPath.row].count))
        cell.textLabel?.attributedText = attributedString
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsMultipleSelection = false
        selectedIndex = indexPath.row
        removeFromCartBtn.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //don't need to use this
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
