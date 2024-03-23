//
//  ChartCollectionViewCell.swift
//  TimeToDo
//
//  Created by Minho on 3/12/24.
//

import UIKit
import SnapKit
import DGCharts
import RealmSwift

class ChartCollectionViewCell: BaseCollectionViewCell {
    
    lazy var barChartView: BarChartView = {
        let view = BarChartView()

//        view.rightAxis.enabled = false
        
        formatXAxis(xAxis: view.xAxis)
        formatYAxis(yAxis: view.leftAxis)
        formatYAxis(yAxis: view.rightAxis)
        
        view.rightAxis.drawLabelsEnabled = false
        
        view.drawGridBackgroundEnabled = false
        
        // 좌측 하단에 표시되는 막대에 대한 설명
        // view.legend.enabled = false
        
        // 줌 막기
        view.pinchZoomEnabled = false
        view.doubleTapToZoomEnabled = false
        
        view.backgroundColor = .background
        
        return view
    }()

    let dateFormatter = DateFormatter()
    
    override func configureHierarchy() {
        [barChartView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        barChartView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-32)
        }
    }
    
    override func configureCell() {
        
    }
    
    private func formatYAxis(yAxis: YAxis) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        yAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 60
    }
    
    private func formatXAxis(xAxis: XAxis) {
        let axisValueList = Array(0...23).map { holderNumber in
            "\(holderNumber)시"
        }
        
        xAxis.valueFormatter = IndexAxisValueFormatter(values: axisValueList)
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
    }
    
    func updateCell(currentDate: Date, pomodoroList: [Pomodoro]) {
        
        var barChartEntry = [BarChartDataEntry]()
        
        // 현재 선택한 날짜와 시간을 가져옴
        let now = currentDate
        let calendar = Calendar.current

        // 현재 날짜의 0시로 설정
        var currentDateComponents = calendar.dateComponents([.year, .month, .day], from: now)
        currentDateComponents.hour = 0
        let startDate = calendar.date(from: currentDateComponents)!

        var timeList = Array(repeating: 0, count: 24)
        var passingTime = 0
        
        // 데이터 선별하여 따로 담기
        for hour in 0..<24 {
            
            // 현재 날짜의 시간을 시간대(hour)로 설정
            let date = calendar.date(byAdding: .hour, value: hour, to: startDate)!
            
            timeList[hour] += passingTime
            passingTime = 0 // 진입 전 초기화
            
            pomodoroList.forEach { pomo in
                
                if pomo.startedTime >= date && pomo.endedTime <= date + 3600 {
                    timeList[hour] += pomo.elapsedMinutes
                } else if pomo.startedTime <= date && pomo.endedTime >= date {
                    timeList[hour] += abs(Int(pomo.startedTime.timeIntervalSince(date)) / 60)
                    passingTime += abs(Int(pomo.endedTime.timeIntervalSince(date)) / 60)
                }
                
            }
        }
        
        // 데이터 추가
        for hour in 0..<24 {
            barChartEntry.append(BarChartDataEntry(x: Double(hour), y: Double(timeList[hour])))
        }
        
        let bar = BarChartDataSet(entries: barChartEntry, label: "집중한 시간")
        bar.colors = [NSUIColor.tint]
        bar.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: bar)
        
        barChartView.data = data
        barChartView.drawGridBackgroundEnabled = false
    }

}
