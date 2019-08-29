//
//  TestChartViewController.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-09.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

//THIS VIEW CONTROLLER DEALS WITH THE GRAPH VIEW WHEN TESTS FROM THE LOGBOOK ARE GRAPHED

import UIKit
import Charts

class TestChartViewController: UIViewController {
    
    private var testLogbook: TestLogbookViewController? = nil
    private var testList = [Test]()
    
    private let lineChartView = LineChartView()
    private var immunoglobulinsDataEntries = [ChartDataEntry]()
    private var lactoferrinDataEntries = [ChartDataEntry]()
    private var bloodCalciumDataEntries = [ChartDataEntry]()
    private var glucoseDataEntries = [ChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chart View"
        
        setupGraph()
    }
    
    
    private func setupGraph(){
        
        lineChartView.backgroundColor = .white
        view.addSubview(lineChartView)
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        lineChartView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        lineChartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        //first sort testList in order of dates
        testList.sort(by: { $0.date!.compare($1.date! as Date) == .orderedAscending })

        //set array of dates to use on x axis
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:MM"// yyyy-MM-dd"
        
        var dateArray = [String]()
        for test in testList{
            print("got here 1")
            dateArray.append(dateFormatter.string(from: test.date! as Date))
        }
        

        for (index, test) in testList.enumerated(){
            
            print("got here 2")
            
            if(test.testType == "Immunoglobulins"){
                let dataEntry = ChartDataEntry(x: Double(index), y: Double(test.value))
                immunoglobulinsDataEntries.append(dataEntry)
            }
            
             else if(test.testType == "Lactoferrin"){
                let dataEntry = ChartDataEntry(x: Double(index), y: Double(test.value))
                lactoferrinDataEntries.append(dataEntry)
            }

            else if(test.testType == "Blood Calcium"){
                let dataEntry = ChartDataEntry(x: Double(index), y: Double(test.value))
                bloodCalciumDataEntries.append(dataEntry)
            }

            else{
                let dataEntry = ChartDataEntry(x: Double(index), y: Double(test.value))
                glucoseDataEntries.append(dataEntry)
            }

        }
        
        //IMMUNOGLOBULINS
        
        let immunoglobulinsChartDataSet = LineChartDataSet(entries: immunoglobulinsDataEntries, label: "Immunoglobulins")
        immunoglobulinsChartDataSet.circleColors = [.blue]
        immunoglobulinsChartDataSet.colors = [.blue]
        
        
        //LACTOFERRIN

        let lactoferrinChartDataSet = LineChartDataSet(entries: lactoferrinDataEntries, label: "Lactoferrin")
        lactoferrinChartDataSet.circleColors = [.red]
        lactoferrinChartDataSet.colors = [.red]
        
        
        //BLOOD CALCIUM
        
        let bloodCalciumChartDataSet = LineChartDataSet(entries: bloodCalciumDataEntries, label: "Blood Calcium")
        bloodCalciumChartDataSet.circleColors = [.green]
        bloodCalciumChartDataSet.colors = [.green]
        
        
        //GLUCOSE
      
        let glucoseChartDataSet = LineChartDataSet(entries: glucoseDataEntries, label: "Glucose")
        glucoseChartDataSet.circleColors = [.yellow]
        glucoseChartDataSet.colors = [.yellow]
        
        
        
        let chartData = LineChartData(dataSets: [immunoglobulinsChartDataSet, lactoferrinChartDataSet, bloodCalciumChartDataSet, glucoseChartDataSet])
        lineChartView.data = chartData
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray)
       // lineChartView.xAxis.setLabelCount(dateArray.count, force: true)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.granularity = 1
        lineChartView.leftAxis.granularity = 1
        lineChartView.setVisibleXRangeMaximum(5)
        lineChartView.setVisibleYRangeMaximum(32, axis: lineChartView.leftAxis.axisDependency)
        lineChartView.xAxis.drawGridLinesEnabled = true
        lineChartView.leftAxis.drawGridLinesEnabled = true
        lineChartView.xAxis.labelRotationAngle = -90
        
       // lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        lineChartView.leftAxis.drawAxisLineEnabled = true
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        
        lineChartView.chartDescription?.text = ""
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupGraph()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        testList.removeAll()
        immunoglobulinsDataEntries.removeAll()
        lactoferrinDataEntries.removeAll()
        bloodCalciumDataEntries.removeAll()
        glucoseDataEntries.removeAll()
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
