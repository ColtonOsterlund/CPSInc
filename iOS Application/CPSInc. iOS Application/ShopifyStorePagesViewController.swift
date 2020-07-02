//
//  ShopifyStoreViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-06-03.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import Buy


class ShopifyStorePagesViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    private var menuView: MenuViewController? = nil
    private var appDelegate: AppDelegate? = nil
    private var checkoutView: ShopifyCheckoutViewController? = nil
    
    private var itemsInCart: String = "0"
    
    let initialPage = 0
    
    public var pages = [ShopifyProductPageViewController]()
    public let pageControl = UIPageControl()
    
    //UIBarButtons
    private var checkoutBtn = UIBarButtonItem()
    private var backBtn = UIBarButtonItem()
    
    
    //The Graph.Client is a network layer built on top of URLSession that executes query and mutation requests. It also simplifies polling and retrying requests
    let client = Graph.Client(shopDomain: "creative-protein-solutions.myshopify.com", apiKey: "28893d9e78d310dde27dde211fa414d7")
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    public convenience init(appDelegate: AppDelegate?, menuView: MenuViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.appDelegate = appDelegate
        self.menuView = menuView
        self.checkoutView = ShopifyCheckoutViewController(storeView: self)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil) //reset to first page of store every time
        pageControl.currentPage = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil) //reset to first page of store every time
        pageControl.currentPage = 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Store"

        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
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
        
        checkoutBtn = UIBarButtonItem.init(title: "Checkout: " + itemsInCart, style: .done, target: self, action: #selector(checkoutBtnPressed))
        navigationItem.rightBarButtonItems = [checkoutBtn]
        backBtn = UIBarButtonItem.init(title: "Menu", style: .done, target: self, action: #selector(backBtnPressed))
        navigationItem.leftBarButtonItem = backBtn
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        
        self.checkoutView = ShopifyCheckoutViewController(storeView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func checkoutBtnPressed(){
        navigationController?.pushViewController(self.checkoutView!, animated: true)
    }
    
    
    @objc private func backBtnPressed(){
        //print("should pop to menu view")
        navigationController?.popToViewController(menuView!, animated: true)
    }
    
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = pages.firstIndex(of: viewController as! ShopifyProductPageViewController)!
        if(currentIndex == 0){
            return nil
        }
        
        
        return pages[currentIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = pages.firstIndex(of: viewController as! ShopifyProductPageViewController)!
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
        self.pageControl.currentPage = pages.firstIndex(of: pageContentViewController as! ShopifyProductPageViewController)!
    }
    
    public func addPage(productIDToAdd: String, variantIDToAdd: String){
        //give the page a pageID unique to all the other pages
    
        let pageToAdd = ShopifyProductPageViewController(pageID: productIDToAdd, variantID: variantIDToAdd, checkoutViewController: self.checkoutView, shopPageViewController: self)

        pages.append(pageToAdd)
        pageControl.numberOfPages = pages.count
        //setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    public func removePages(){
        pages.removeAll()
    }
    
    public func setMenuView(menuView: MenuViewController?){
        self.menuView = menuView
    }
    
    public func addItemToCart(){
        var num = Int(itemsInCart)
        num = num! + 1
        itemsInCart = String(num!)
        checkoutBtn.title = "Checkout: " + itemsInCart
    }
    
    public func removeAllItemsFromCart(){
        let num = 0
        itemsInCart = String(num)
        checkoutBtn.title = "Checkout: " + itemsInCart
    }
    
}
