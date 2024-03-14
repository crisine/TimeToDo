//
//  ChartCollectionViewCell.swift
//  TimeToDo
//
//  Created by Minho on 3/12/24.
//

import UIKit
import SnapKit
import DGCharts

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
    
}
