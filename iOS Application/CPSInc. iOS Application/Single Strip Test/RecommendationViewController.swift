//
//  RecommendationViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-07-14.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit

public class RecommendationViewController: UIViewController {
    
    //views
    private var appDelegate: AppDelegate? = nil
    private var menuView: MenuViewController? = nil
    
    private var recommendationString: String? = nil
    private var followUpNumber: NSNumber? = nil
    private var followUpTestResults: [Test]? = nil
    
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
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Recommendations"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupLayoutComponents()
        setupLayoutConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
      
    }
    
    private func setupLayoutComponents(){
        
        
    }
    
    private func setupLayoutConstraints(){
        
        
    }
   
    
}

