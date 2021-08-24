//
//  ShopifyProductPageViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-06-08.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//
import UIKit
import MobileBuySDK


class ShopifyProductPageViewController: UIViewController {
    
    //pageID
    private var pageID: String? = nil //product ID
    private var variantID: String? = nil //variant ID
    
    private var checkoutView: ShopifyCheckoutViewController? = nil
    private var shopPageViewController: ShopifyStorePagesViewController? = nil
    
    //The Graph.Client is a network layer built on top of URLSession that executes query and mutation requests. It also simplifies polling and retrying requests
    let client = Graph.Client(shopDomain: "creative-protein-solutions.myshopify.com", apiKey: "28893d9e78d310dde27dde211fa414d7")
    
    private var productImage: UIImage? = nil
    private var productTitle: String? = nil
    private var productDescription: String? = nil
    private var productPrice: String? = nil
    private let addToCartBtn = UIButton()
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    
    //UIActivityIndicatorView
    private let scanningIndicator = UIActivityIndicatorView()
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(pageID: String?, variantID: String?, checkoutViewController: ShopifyCheckoutViewController?, shopPageViewController: ShopifyStorePagesViewController?) {
        self.init(nibName:nil, bundle:nil)

        self.pageID = pageID
        self.variantID = variantID
        self.checkoutView = checkoutViewController
        self.shopPageViewController = shopPageViewController
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

        //self.title = "Skeleton" //takes the title of the page controller
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        //scanningIndicator - this has to be done here because it is used before the setupLayoutComponents() and setupLayoutConstraints() functions are called
        scanningIndicator.center = self.view.center
        scanningIndicator.style = UIActivityIndicatorView.Style.gray
        scanningIndicator.backgroundColor = .lightGray
        view.addSubview(scanningIndicator)
        
        self.scanningIndicator.startAnimating()
            
            let query = Storefront.buildQuery { $0
                .node(id: GraphQL.ID(rawValue: self.pageID!)){$0
                    .onProduct{$0
                        .title()
                        .description()
                        .priceRange{$0
                            .minVariantPrice{$0
                                .amount()
                            }
                        }
                    .images(first: 1){$0
                        .edges{$0
                            .node{$0
                                .originalSrc()
                            }
                        }
                    }
                }
                }
            }

            let task = self.client.queryGraphWith(query) { response, error in
                if let response = response {
                    //print(response)
                    
                    let dispatchQueue = DispatchQueue(label: "QueryProductDataThread", qos: .background)
                    dispatchQueue.async{
                        
                        //SET UP PAGE VALUES HERE
                        self.productTitle = (response.node as! Storefront.Product).title
                        self.productDescription = (response.node as! Storefront.Product).description
                        self.productPrice = String(Double(truncating: (response.node as! Storefront.Product).priceRange.minVariantPrice.amount as NSNumber))
                        
                        let imageUrl = (response.node as! Storefront.Product).images.edges[0].node.originalSrc
                        let imageData = try! Data(contentsOf: imageUrl)
                        self.productImage = UIImage(data: imageData)
                        
                        DispatchQueue.main.async {
                            //setup layout
                            self.setupLayoutComponents()
                            self.setupLayoutConstraints()
                            self.setButtonListeners()
                            self.scanningIndicator.stopAnimating()
                        }
                        
                    }
                    
                } else {
                    print(error!)
                }
            }
            task.resume()
    }
    
    
    private func setupLayoutComponents(){
        
        //imageView
        imageView.image = productImage!
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        //titleLabel
        let attributedString = NSMutableAttributedString(string: productTitle!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: productTitle!.count))
        titleLabel.attributedText = attributedString
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.numberOfLines = 2
        view.addSubview(titleLabel)

        
        //descriptionLabel
        descriptionLabel.text = productDescription!
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = descriptionLabel.font.withSize(15)
        descriptionLabel.contentMode = .scaleToFill
        descriptionLabel.numberOfLines = 10 //this is the max number of lines
        view.addSubview(descriptionLabel)
        
        //priceLabel
        priceLabel.text = "$" + productPrice! + "0"
        priceLabel.textColor = .white
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        view.addSubview(priceLabel)
        
        //addToCartBtn
        addToCartBtn.backgroundColor = .blue
        addToCartBtn.setTitle("Add to Cart", for: .normal)
        addToCartBtn.setTitleColor(.white, for: .normal)
        addToCartBtn.layer.borderWidth = 2
        addToCartBtn.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.addSubview(addToCartBtn)
        
        
    }
    
    private func setupLayoutConstraints(){
        //scanningIndicator
        scanningIndicator.translatesAutoresizingMaskIntoConstraints = false
        scanningIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scanningIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        scanningIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12).isActive = true
        scanningIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
        
        //imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -(UIScreen.main.bounds.height * 0.25)).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.4)).isActive = true
        
        //titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        //descriptionLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.8)).isActive = true
        
        //priceLabel
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.02)).isActive = true
        
        //addToCartBtn
        addToCartBtn.translatesAutoresizingMaskIntoConstraints = false
        addToCartBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        addToCartBtn.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        addToCartBtn.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.6)).isActive = true
        addToCartBtn.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height * 0.06)).isActive = true
    }
    
    private func setButtonListeners(){
        addToCartBtn.addTarget(self, action: #selector(addToCartBtnPressed), for: .touchUpInside)
    }
    
    
    
    @objc private func addToCartBtnPressed(){
        
        let alert = UIAlertController(title: "Quantity", message: "Enter amount: ", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Quantity"
            textField.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            
            let quantity = Int(userText)
            if(quantity == nil){
                self.showToast(controller: self, message: "Not a valid number", seconds: 1)
            }
            else if(quantity == 0){
                return
            }
            else{
                
                self.checkoutView?.addItemToCart(itemID: self.variantID!, itemName: self.titleLabel.text!, quantity: quantity!)
                
                for i in 1...quantity!{
                    self.shopPageViewController?.addItemToCart()
                }
 
                self.showToast(controller: self, message: "Item Added to Cart", seconds: 1)

            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
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
