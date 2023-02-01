//
//  ChartViewController.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 26.01.23.
//

import UIKit
import Charts
import RealmSwift

class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var temperatureSwitch: UISwitch!
    @IBOutlet weak var precipitationSwitch: UISwitch!
    @IBOutlet weak var humiditySwitch: UISwitch!
    var chartData:[LineChartDataSet] = []
    var weatherData:WeatherRealm?
    var timeData:[String]?

    @IBOutlet weak var locationNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chartView.delegate = self
        self.chartView.alpha = 0
        self.humiditySwitch.alpha = 0
        self.temperatureSwitch.alpha = 0
        self.precipitationSwitch.alpha = 0
        NotificationCenter.default.addObserver(forName: .locationsModified,
                                               object: nil,
                                               queue: nil){
            _ in
            let location = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
            RequestManager.fetchDataAlamofire(location: location){
                self.getWeather()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .locationsModified, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.chartView.alpha = 0
        self.humiditySwitch.alpha = 0
        self.temperatureSwitch.alpha = 0
        self.precipitationSwitch.alpha = 0
        self.LoadingView.alpha = 1
        
    }
    
    func getWeather(){
        guard let location = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
        else{
            let settingViewController = self.tabBarController?.viewControllers?.first {$0.restorationIdentifier == "SettingsNavigationController"}
            self.tabBarController?.selectedViewController = settingViewController
            return
        }
        
        RequestManager.fetchDataAlamofire(location: location){
            self.weatherData = location.weather
            self.locationNameLabel.text = location.name
            let indexNow = self.weatherData?.timeHistory.firstIndex { $0 == self.weatherData?.time}
            let timeHistoryAsArray = Array(self.weatherData!.timeHistory)
            self.timeData = Array(timeHistoryAsArray[0...indexNow!]).map { self.convertTimeStringToUserTimeZone(timeString: $0) }
                self.showChart()
            }
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            let dataSet = chartData[highlight.dataSetIndex]
            let dataSetLabel = dataSet.label!
            let components = dataSetLabel.components(separatedBy: " in ")
            let color = dataSet.highlightColor
            let label = components[0]
            let unit = components[1]
            let value = entry.y
            let index:Int = Int(entry.x)
            let date = self.timeData![index]
            self.infoLabel.text = "\(label): \(value) \(unit) on \(date)"
            self.infoLabel.textColor = color
        }
        
        func showChart(){
            self.LoadingView.alpha = 0
            self.createChart()
            
            UIView.animate(withDuration: 3){
                self.chartView.alpha = 1
                self.humiditySwitch.alpha = 1
                self.temperatureSwitch.alpha = 1
                self.precipitationSwitch.alpha = 1
            }
        }
        
        func createChart(){
            self.setUpChart()
            
            self.addData(data: self.weatherData!.temperatureHistory,
                         label: "Temperature in \(UserSettings.temperatureUnit!)",
                         color: .red,
                         mode: .linear)
            self.addData(data: self.weatherData!.precipitationHistory,
                         label: "Precipitation in mm",
                         color: .blue,
                         mode: .stepped)
            self.addData(data: self.weatherData!.humidityHistory,
                         label: "Humidity in %",
                         color: .green,
                         mode: .horizontalBezier)
            let lineChartData = LineChartData(dataSets: self.chartData)
            self.chartView.data = lineChartData
        }
        
        func setUpChart(){
            self.chartData = []
            chartView.xAxis.labelPosition = .bottom
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:Array(weatherData!.timeHistory))
            chartView.xAxis.setLabelCount(7, force: false)
            chartView.rightAxis.enabled = false
            chartView.leftAxis.setLabelCount(20, force: false)
            chartView.legend.enabled = true
            chartView.backgroundColor = .darkGray
            self.chartView.animate(xAxisDuration: 6)
        }
        
        func addData(data:List<Double>, label:String, color:UIColor, mode: LineChartDataSet.Mode){
            let data = Array(data)[0...(self.timeData!.count-1)]
            let dataSet = LineChartDataSet(entries: data.enumerated().map { (i, value) in
                return ChartDataEntry(x: Double(i), y: value)
            }, label: label)
            dataSet.setColor(color)
            dataSet.drawCirclesEnabled = false
            dataSet.mode = mode
            dataSet.lineWidth = 4
            dataSet.highlightColor = color
            self.chartData.append(dataSet)
        }
        
        func convertTimeStringToUserTimeZone(timeString: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            guard let date = dateFormatter.date(from: timeString) else {
                return timeString
            }
            
            dateFormatter.timeZone = TimeZone.current
            return dateFormatter.string(from: date)
        }
    @IBAction func toggleLine(_ sender: UISwitch) {
        var index = -1
        switch sender{
        case temperatureSwitch:
            index = 0
        case precipitationSwitch:
            index = 1
        case humiditySwitch:
            index = 2
        default:
            return
        }
        
        let dataSet = chartData[index]
        dataSet.visible = sender.isOn
        chartView.notifyDataSetChanged()
    }
}
    

