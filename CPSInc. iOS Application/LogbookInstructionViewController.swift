//
//  LogbookInstructionViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-16.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit

class LogbookInstructionViewController: UIViewController {

    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let instructionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Logbook Instructions"
        
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
        
        imageView.image = UIImage(named: "logbook")
        contentView.addSubview(imageView)
        
        instructionLabel.text = "1) To add a herd to the logbook, press the '+' button in the upper right hand corner and fill out all the required information. Press the 'Save' button to save your changes to the logbook"
            + "\n\n2) To view the herd information for a desired herd, click on the herd ID from the table view and press 'Herd Info'. To modify the herd info, simply select the desired attribute that you want to modify, make the required modifications, and press the 'Save Changes' button to save your changes"
            + "\n\n3) To delete a herd, click on the herd ID from the table view and press 'Delete Herd'. A prompt will ask you to confirm the deletion of the herd. Once deleted, there is no way to retrieve the deleted data"
            + "\n\n4) To view the cow listing for a desired herd, click on the herd ID from the table view and press 'Cow Listing'. Repeat all the same steps above from the cow listing page to add and view cow information as well as test results for the respective cow"
            + "\n\n5) To import a herd from a .csv file stored in the users dropbox account, press the 'Import' button in the top right corner of the herd list view. \nYou will be redirected to dropbox.com where you will be required to enter your credentials & allow the CPSInc. application to gain access to your user data. \nOnce this is done, you will be redirected to the CPSInc. applciation and a path will be created in your dropbox storage: \\Apps\\'Creative Protein Solutions Inc.'\\'CSV Uploads'. \nPaste the desired .csv file you want to import into this folder, and the next time you press the 'Import' button from the herd list view, you will see a list of all the .csv files available for import within this folder. \nSimply select the file you wish to import and wait for the file transfer to be completed. \nOnce completed, you will see a new herd in your herd list with the ID: 'Imported Herd'. \nSimply go in and change the ID along with the other herd information and you are done."
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
