//
//  FindDeviceInstructionViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-16.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE INSTRUCTION PAGE FOR THE CONNECT DEVICE INSTRUCTIONS

import UIKit

class FindDeviceInstructionViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let instructionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Find Device Instructions"
        
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
        
        imageView.image = UIImage(named: "device")
        contentView.addSubview(imageView)
        
        instructionLabel.text = "\n\n1) ave a CPSInc. handheld device ready and close by to your phone"
          + "\n\n2) Turn the switch on the CPSInc. device to the ON position"
            + "\n\n3) Turn on the bluetooth capabilities on your phone"
            + "\n\n4) Press the 'Find Device' button from the menu screen. If nothing comes up immediately, press the 'Search for Devices' button to refresh"
            + "\n\n5) Once your device name is visible in the table view, click on the device name to connect"
            + "\n\n6) You should see a promt that your device has connected as well as the name of your device on the 'Connected Devices' label below the table view"
            + "\n\n7) To disconnect from a device, simply press the 'Disconnect from Device' button below the table view. You should see a promt that your device has disconnected as well as the 'Connected Devices' label below the table view has changed to 'None'"
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
