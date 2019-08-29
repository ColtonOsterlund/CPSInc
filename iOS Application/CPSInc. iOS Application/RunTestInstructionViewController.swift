//
//  RunTestInstructionViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-16.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE INSTRUCTION PAGE FOR THE RUN TEST INSTRUCTIONS

import UIKit

class RunTestInstructionViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let instructionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Run Test Instructions"
        
        setupComponents()
        setupLayouts()
    }
    
    
    private func setupComponents(){
        scrollView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        contentView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        scrollView.addSubview(contentView)
        
        imageView.image = UIImage(named: "bloodDropCartoonImage")
        contentView.addSubview(imageView)
        
        instructionLabel.text = "\n\n1) Before running a test, be sure to check that a device is connected with the 'Connected Device' label"
            + "\n\n2) Check that all your test settings are correct with the 'Test Duration', 'Test Type' and 'Data Type' labels. If one of these is incorrect, see: 'Settings Instructions'"
            + "\n\n3) To run a test, simply press the 'Start Test' button and wait for the test timer to complete"
            + "\n\n4) One test timer has completed, test results will be displayed on the screen"
            + "\n\n5) To save the test result, press the 'Save Test' button"
            + "\n\n6) You can either save tests by selecting the Herd & the Cow for which the test was performed from a list or manually entering the Herd ID and Cow ID"
            + "\n\n7) To reset the test without saving the results, simply press the 'Discard Test' button"
            + "\n\n8) To view saved test results, see: 'Logbook Instructions'"
            + "\n\n9) If device disconnects pre-test, the test will not run until a device is reconnected or the app is restarted. If the device disconnects during the test, this will result in an erronous test"
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.textAlignment = .left
        contentView.addSubview(instructionLabel)
        
    }
    
    private func setupLayouts(){
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true //on menu width is set as twice height but in this case with the scroll view the height of the view is doubled
        imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
        instructionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIScreen.main.bounds.width * 0.05).isActive = true
        instructionLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
    }

}
