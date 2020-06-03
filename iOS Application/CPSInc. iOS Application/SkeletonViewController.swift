//
//  SkeletonViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-06-03.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//
import UIKit



class SkeletonViewController: UIViewController {
    
    //views
    private var appDelegate: AppDelegate? = nil
    private var menuView: MenuViewController? = nil
    
    
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

        self.title = "Skeleton"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupLayoutComponents()
        setupLayoutConstraints()
    }
    
    
    private func setupLayoutComponents(){
        
        
    }
    
    private func setupLayoutConstraints(){
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    
   
    
}
