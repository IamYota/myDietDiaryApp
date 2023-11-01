//
//  GraphDateTitleFormatter.swift
//  MyDietDiaryApp
//
//  Created by Yota Yamashita on 2023/10/11.
//

import Foundation
import Charts

class GraphDateTitleFormatter: AxisValueFormatter {
    
    var dateList: [Date] = []
    
    //stringForValue→x軸に表示する文字列を返すためのメソッド
    func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String {
        let index = Int(value)
        guard dateList.count > index else {return ""}
        let targetDate = dateList[index]
        let formatter = DateFormatter()
        let dateFormatString = "M/d"
        formatter.dateFormat = dateFormatString
        return formatter.string(from: targetDate)
    }
    
    
}
