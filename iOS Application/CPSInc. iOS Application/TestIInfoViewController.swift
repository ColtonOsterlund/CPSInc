//
//  TestIInfoViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-27.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH DISPLAYING THE TEST INFO WHEN TEST SELECTED

import UIKit

class TestInfoViewController: UIViewController {

    private var testLogbook: TestLogbookViewController? = nil
    private var appDelegate: AppDelegate? = nil
    
    private var selectedTest: Test? = nil
    
    private let dateLabel = UILabel()
    private let dataTypeLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let testTypeLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitsLabel = UILabel()
    
    private let dateTextView = UITextView()
    private let dataTypeTextView = UITextView()
    private let runtimeTextView = UITextView()
    private let testTypeTextView = UITextView()
    private let valueTextView = UITextView()
    private let unitsTextView = UITextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Test Info"
        view.backgroundColor = .init(red: 0, green: 0.637, blue: 0.999, alpha: 1)
        
        setupComponents()
        setupLayoutConstraints()
    }
    

    private func setupComponents(){
        //setup layout components here
        dateLabel.text = "Date:"
        view.addSubview(dateLabel)
        
        dataTypeLabel.text = "Data Collection Type:"
        view.addSubview(dataTypeLabel)
        
        runtimeLabel.text = "Test Runtime:"
        view.addSubview(runtimeLabel)
        
        testTypeLabel.text = "Test Type:"
        view.addSubview(testTypeLabel)
        
        valueLabel.text = "Value:"
        view.addSubview(valueLabel)
        
        unitsLabel.text = "Units:"
        view.addSubview(unitsLabel)
        
        view.addSubview(dateTextView)
        
        view.addSubview(dataTypeTextView)
        
        view.addSubview(runtimeTextView)
        
        view.addSubview(testTypeTextView)
        
        view.addSubview(valueTextView)
        
        view.addSubview(unitsTextView)
    
    }
    
    private func setupLayoutConstraints(){
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        dateTextView.translatesAutoresizingMaskIntoConstraints = false
        dateTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dateTextView.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        dateTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dateTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        dataTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        dataTypeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dataTypeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        dataTypeTextView.translatesAutoresizingMaskIntoConstraints = false
        dataTypeTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        dataTypeTextView.leftAnchor.constraint(equalTo: dataTypeLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        dataTypeTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dataTypeTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        runtimeLabel.translatesAutoresizingMaskIntoConstraints = false
        runtimeLabel.topAnchor.constraint(equalTo: dataTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        runtimeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        runtimeTextView.translatesAutoresizingMaskIntoConstraints = false
        runtimeTextView.topAnchor.constraint(equalTo: dataTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        runtimeTextView.leftAnchor.constraint(equalTo: runtimeLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        runtimeTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        runtimeTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        testTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        testTypeLabel.topAnchor.constraint(equalTo: runtimeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testTypeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        testTypeTextView.translatesAutoresizingMaskIntoConstraints = false
        testTypeTextView.topAnchor.constraint(equalTo: runtimeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        testTypeTextView.leftAnchor.constraint(equalTo: testTypeLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        testTypeTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        testTypeTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.topAnchor.constraint(equalTo: testTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        valueTextView.translatesAutoresizingMaskIntoConstraints = false
        valueTextView.topAnchor.constraint(equalTo: testTypeLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        valueTextView.leftAnchor.constraint(equalTo: valueLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        valueTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        valueTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        unitsLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        unitsLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: (UIScreen.main.bounds.width * 0.025)).isActive = true
        
        unitsTextView.translatesAutoresizingMaskIntoConstraints = false
        unitsTextView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: (UIScreen.main.bounds.height * 0.05)).isActive = true
        unitsTextView.leftAnchor.constraint(equalTo: unitsLabel.rightAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        unitsTextView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        unitsTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        
        dateTextView.text = dateformatter.string(from: selectedTest!.date! as Date)
        dataTypeTextView.text = selectedTest?.dataType
        runtimeTextView.text = (selectedTest?.runtime)!.stringValue
        testTypeTextView.text = selectedTest?.testType
        valueTextView.text = String((selectedTest?.value)!)
        unitsTextView.text = selectedTest?.units
        
    }
    
    
    public convenience init(testLogbook: TestLogbookViewController?, appDelegate: AppDelegate?) {
        self.init(nibName:nil, bundle:nil)
        
        self.testLogbook = testLogbook
        self.appDelegate = appDelegate
    }
    
    // This extends the superclass.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }

    
    //getters/setters
    public func setSelectedTest(test: Test){
        self.selectedTest = test
    }
}
