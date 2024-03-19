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

        view.rightAxis.enabled = false  // 우측 비표시
        
        formatLeftAxis(leftAxis: view.leftAxis)
        formatXAxis(xAxis: view.xAxis)
        
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
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureCell() {
        
        var barChartEntry = [BarChartDataEntry]()
        
        /*
            시간계산쪽이 좀 문제인데..
            통계를 낼거면 일단 0~23시가 X축을 담당하고, Y축은 최대 60까지 솟을 수 있도록 만들어야 함
            
            뽀모도로 시간은 startedTime 하고 endTime 사이가 걸친 경우가 문제가 될텐데
         
            [일단 Cell 바깥의 Datasource에서 오늘 진행한 Todo만 던져준다고 가정]
            0시 loop를 도는 경우 Date의 날짜값 중 startedDate 의 HH:MM 값이 00:00~00:59 인 값을 찾아야함
            
         그러면 예를 들어서 시작이 00:50 인 투두가 있고 25분인 뽀모도로가 있다고 치자. 그러면 00:00과의 차이를 구하고
         
         */
        
//        pomodoroList.forEach { pomodoro in
//            barChartEntry.append(BarChartDataEntry(x: <#T##Double#>, y: <#T##Double#>))
//        }
        
        let value = BarChartDataEntry(x: 0, y: 4)
        let value2 = BarChartDataEntry(x: 1, y: 7)
        let value3 = BarChartDataEntry(x: 2, y: 3)
        barChartEntry.append(value)
        barChartEntry.append(value2)
        barChartEntry.append(value3)
        
        let bar = BarChartDataSet(entries: barChartEntry, label: "집중한 시간")
        bar.colors = [NSUIColor.tint]
        
        let data = BarChartData(dataSet: bar)
        barChartView.data = data
        barChartView.drawGridBackgroundEnabled = false
    }
    
    private func formatLeftAxis(leftAxis: YAxis) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
    }
    
    private func formatXAxis(xAxis: XAxis) {
        // TODO: (values: ) 에 [dateString] 등이 전달되어야 막대 하단에 날짜등을 표시할 수 있음.
        xAxis.valueFormatter = IndexAxisValueFormatter(values: ["03/01", "03/02", "03/03"]) // MARK: 임시 데이터!!
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
    }
    
    func updateCell(pomodoroList: [Pomodoro]) {
        
        /*
            1. X축에는 0~23시가 들어가야함
            2. Y축은 해당 시간 내에서 집중한 시간을 계산해야함.
         */
        var barChartEntry = [BarChartDataEntry]()
        
        pomodoroList.forEach { pomodoro in
            barChartEntry.append(BarChartDataEntry(x: <#T##Double#>, y: <#T##Double#>))
        }
                
        let value = BarChartDataEntry(x: 0, y: 4)
        let value2 = BarChartDataEntry(x: 1, y: 7)
        let value3 = BarChartDataEntry(x: 2, y: 3)
        barChartEntry.append(value)
        barChartEntry.append(value2)
        barChartEntry.append(value3)
        
        let bar = BarChartDataSet(entries: barChartEntry, label: "집중한 시간")
        bar.colors = [NSUIColor.tint]
        
        let data = BarChartData(dataSet: bar)
        barChartView.data = data
        barChartView.drawGridBackgroundEnabled = false
    }
}
