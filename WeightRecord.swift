//
//  WeightRecord.swift
//  MyDietDiaryApp
//
//  Created by Yota Yamashita on 2023/10/09.
//

import Foundation
import RealmSwift

class WeightRecord: Object {
    override static func primaryKey() -> String? {
        return "id"
        //idをprimaryKeyとして設定することでデータの特定を簡単にする
    }
    
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var weight: Double = 0
}
