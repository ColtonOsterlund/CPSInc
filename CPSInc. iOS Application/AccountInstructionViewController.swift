//
//  AccountInstructionsViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-08-02.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit

class AccountInstructionViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let instructionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Account Instructions"
        
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
        
        imageView.image = UIImage(named: "userLOGO")
        contentView.addSubview(imageView)
        
        instructionLabel.text = "Instructions Coming Soon"
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
