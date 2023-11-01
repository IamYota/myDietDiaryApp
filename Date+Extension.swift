//
//  Date+Extension.swift
//  MyDietDiaryApp
//
//  Created by Yota Yamashita on 2023/10/09.
//

//ココにDate型の拡張機能を作成していく
import Foundation

extension Date {
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale = Locale(identifier: "ja-JP")
        return calendar
    }
    
    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        var comp = DateComponents()
        comp.year = year ?? calendar.component(.year, from: self)
        comp.month = year ?? calendar.component(.month, from: self)
        comp.day = year ?? calendar.component(.day, from: self)
        comp.hour = year ?? calendar.component(.hour, from: self)
        comp.minute = year ?? calendar.component(.minute, from: self)
        comp.second = year ?? calendar.component(.second, from: self)
        return calendar.date(from: comp)!
    }
    
    var zeroclock: Date { //特定のDate型の値のhour, minute, secondを全て0にした
        return fixed(hour: 0, minute: 0, second: 0)
    }
}
