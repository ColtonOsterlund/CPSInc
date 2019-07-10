//
//  TestChartViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-09.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import Charts

class TestChartViewController: UIViewController {
    
    private var testLogbook: TestLogbookViewController? = nil
    private var testList = [Test]()
    
    private let lineChartView = LineChartView()
    private var dataEntries = [ChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chart View"
        
        setupGraph()
    }
    
    
    private func setupGraph(){
        
        lineChartView.noDataText = "No Data Selected/Within Selected Date Range"
        lineChartView.noDataFont = lineChartView.noDataFont.withSize(20)
        lineChartView.noDataTextColor = .red
        lineChartView.backgroundColor = .white
        view.addSubview(lineChartView)
        lineChartView.isHidden = true
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        lineChartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        lineChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        print("GOT HERE 1")
        
        var dateStrings = [String]()
        var initialTimeSince1970 = Double(FP_INFINITE)
        var finalTimeSince1970 = Double(0)
        
        for test in testList{
            
            let graphableDateAsDouble = (test.date?.timeIntervalSince1970)!
            
            if(graphableDateAsDouble <= initialTimeSince1970){
                initialTimeSince1970 = graphableDateAsDouble
            }
            if(graphableDateAsDouble >= finalTimeSince1970){
                finalTimeSince1970 = graphableDateAsDouble
            }
            
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.short
            dateformatter.timeStyle = DateFormatter.Style.short
            dateStrings.append(String(dateformatter.string(from: test.date! as Date)))
            
            let dataEntry = ChartDataEntry(x: graphableDateAsDouble, y: Double(test.value))
            self.dataEntries.append(dataEntry)
        }
        
        
       
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateStrings)
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        
        
        
        //print graph of results here
        let lineChartDataSet = LineChartDataSet(entries: self.dataEntries, label: "Test Results")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        self.lineChartView.data = lineChartData
//        self.lineChartView.setVisibleXRangeMinimum(initialTimeSince1970)
//        self.lineChartView.setVisibleXRangeMaximum(finalTimeSince1970)
//        self.lineChartView.setVisibleYRangeMinimum(Double(0), axis: lineChartView.leftAxis.axisDependency)
//        self.lineChartView.setVisibleYRangeMaximum(Double(32), axis: lineChartView.leftAxis.axisDependency)
//        self.lineChartView.setVisibleYRangeMinimum(Double(0), axis: lineChartView.rightAxis.axisDependency)
//        self.lineChartView.setVisibleYRangeMaximum(Double(32), axis: lineChartView.rightAxis.axisDependency)
        //self.lineChartView.moveViewToX(0.0) //initially display the graph starting at index of 0
        self.lineChartView.isHidden = false
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupGraph()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        testList.removeAll()
        dataEntries.removeAll()
    }
    
    
    
    
    public convenience init(testLogbook: TestLogbookViewController?) {
        self.init(nibName:nil, bundle:nil)
        
        self.testLogbook = testLogbook
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
    public func setTestList(testList: [Test]){
        self.testList = testList
    }
    
}
