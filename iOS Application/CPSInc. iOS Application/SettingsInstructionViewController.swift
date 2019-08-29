//
//  SettingsInstructionViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-16.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE INSTRUCTION PAGE FOR THE SETTINGS INSTRUCTIONS

import UIKit

class SettingsInstructionViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let instructionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings Instructions"
        
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
        
        imageView.image = UIImage(named: "settingsWheel")
        contentView.addSubview(imageView)
        
        instructionLabel.text = "1) To change the desired setting, press the respective underlined setting label and scroll through to the desired new setting"
        + "\n\n2) Once desired new setting is in focus, press the 'Select' button to save your changes"
        + "\n\n3) To turn on Manual Calibration Mode, flip the Manual Calibration switch, then enter the correct values for m and b in the standard line equation y = mx + b"
       
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
