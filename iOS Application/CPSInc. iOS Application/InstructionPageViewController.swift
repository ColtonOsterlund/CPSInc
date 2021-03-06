//
//  InstructionPageViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-16.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.

//THIS PAGEVIEWCONTROLLER CONTROLS THE PAGE SWIPING FEATURE FOR THE INSTRUCTION PAGES
//

import UIKit

class InstructionPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //setup order of pages - these pages are made in the instructionsStoryboard.swift file
    private lazy var orderedPages: [UIViewController] = {
        return[
            UIStoryboard(name: "InstructionsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "FindDeviceInstructionViewController") as! FindDeviceInstructionViewController,
            UIStoryboard(name: "InstructionsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RunTestInstructionViewController") as! RunTestInstructionViewController,
            UIStoryboard(name: "InstructionsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LogbookInstructionViewController") as! LogbookInstructionViewController,
            UIStoryboard(name: "InstructionsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SettingsInstructionViewController") as! SettingsInstructionViewController,
            UIStoryboard(name: "InstructionsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "AccountInstructionViewController") as! AccountInstructionViewController
        ]
    }()
    
    //this is to show the dots at the bottom of the screen indicating which page you are on
    private let pageControl = UIPageControl()

    
    
    //setup the first time view
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Instructions"
        
        self.dataSource = self
        self.delegate = self
        
        setViewControllers([orderedPages[0]], direction: .forward, animated: true, completion: nil)
        
        //SET PAGES
        pageControl.numberOfPages = orderedPages.count
        pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
        
        //SET PAGE CONSTRAINTS
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height * 0.05)).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.1).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1).isActive = true
        
    }
    
    
    //constructor
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = orderedPages.firstIndex(of: viewController)!
        if(currentIndex == 0){
            return nil
        }
        return orderedPages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = orderedPages.firstIndex(of: viewController)!
        if(currentIndex == orderedPages.count - 1){
           return nil
        }
        return orderedPages[currentIndex + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.orderedPages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedPages.firstIndex(of: pageContentViewController)!
    }

}
