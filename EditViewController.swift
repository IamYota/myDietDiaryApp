//
//  EditViewController.swift
//  MyDietDiaryApp
//
//  Created by Yota Yamashita on 2023/10/09.
//

import UIKit
import RealmSwift

protocol EditViewControllerDelegate {
    func recordUpdate()
}

class EditViewController: UIViewController {
    
    @IBOutlet weak var inputWeightTextField: UITextField!
    @IBOutlet weak var inputDateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveRecord()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        deleteRecord()
    }
    
    var record = WeightRecord()
    var delegate: EditViewControllerDelegate?
    
    var datePicker: UIDatePicker {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.preferredDatePickerStyle = .wheels //ドラムロールのようなUIうぃ表示する
        datePicker.locale = Locale(identifier: "ja-JP")
        datePicker.date = record.date //ここに現在の日付を代入する
        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        return datePicker
    }
    
    //閉じるボタン(Done)→体重入力用のDoneボタンをクラス内で共通利用できるようにした
    var toolBar: UIToolbar {
        //キーボードに追加するtoolBarの座標とサイズの定義してインスタンス化
        let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
        let toolBar = UIToolbar(frame: toolBarRect)
        
        //閉じるボタンをUIBarButtonItemとしてインスタンス化し、didTapDoneメソッドを引数として渡している
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        toolBar.setItems([doneItem], animated: true)
        return toolBar
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatt = DateFormatter() //まずインスタンス化
        dateFormatt.dateStyle = .long
        dateFormatt.timeZone = .current
        dateFormatt.locale = Locale(identifier: "ja-JP")
        return dateFormatt
    }
    
    //この画面を表示した際に行いたい処理
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeightTextField()
        configureDateTextField() //日付を選択するメソッド
        configureSaveButton()
        
        print("👀record: \(record)")
        
        //入力された体重を確認する部分
        let realm = try! Realm()
        let firstRecord = realm.objects(WeightRecord.self).first
        print("👀firstRecord:\(String(describing: firstRecord))")
        //↑これで、入力した体重が次の実行時に保存されている
        
        
        
    }
    
    @objc func didTapDone(){
        view.endEditing(true)
        //キーボードを閉じるためのメソッド
    }
    
    //これが閉じるボタンを追加する処理
    func configureWeightTextField(){
        
        //ココでtoolBarを代入して、キーボードに表示されるようにしている
        inputWeightTextField.inputAccessoryView = toolBar
        
        inputWeightTextField.text = String(record.weight)
    }
    
    func configureDateTextField(){
        inputDateTextField.inputView = datePicker
        inputDateTextField.inputAccessoryView = toolBar //こいつがDoneボタン
        inputDateTextField.text = dateFormatter.string(from: record.date) //これで画面を表示した際に現在の日付をUIText fieldに表示できる
    }
    
    //これで日付の入力欄に当日の日付と選択中の反映をさせる
    @objc func didChangeDate(picker: UIDatePicker) {
        inputDateTextField.text = dateFormatter.string(from: picker.date)
    }
    
    //ボタンの角を丸くする
    func configureSaveButton(){
        saveButton.layer.cornerRadius = 5
    }
    
    func saveRecord(){
        
        //realmをインスタンス化
        let realm = try! Realm()
        
        //realmのwriteメソッド内でデータ保存処理を追加
        try! realm.write {
            
            //inputDateTextFieldにtextが存在していて、かつdateに変換できるならrecordのdateプロパティを更新している。
            if let dateText = inputDateTextField.text, let date = dateFormatter.date(from: dateText) { //dateFormatterクラスのdateメソッドで日付の文字列をdate型に変換している
                record.date = date
            }
            
            //ここも同じ。フィールドにtextがあって、Double型に変換できたときにweightが更新される
            if let weightText = inputWeightTextField.text,
               let weight = Double(weightText) { //ココでDouble型に変換
                record.weight = weight
            }
            
            realm.add(record) //更新後、ここでデータに追加
        }
        delegate?.recordUpdate()
        dismiss(animated: true) //データ保存後に自動的に画面を閉じるメソッド
    }
    
    func deleteRecord(){
        let calendar = Calendar(identifier: .gregorian)
        
        //startOfDateとendOfDateの間に削除対象のデータがある場合はその日付を削除する
        let startOfDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: record.date)!
        let endOfDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: record.date)!
        let realm = try! Realm()
        
        //NSPredicateを使用した条件検索
        let recordList = Array(realm.objects(WeightRecord.self).filter("date BETWEEN {%@, %@}", startOfDate, endOfDate))
        
        //forEachでrecordListのそれぞれの要素にアクセス。
        //それらの要素データをrealm上から削除する
        recordList.forEach({record in try! realm.write{
            realm.delete(record) //ココで削除対象のデータを渡している
        }
        })
        delegate?.recordUpdate()
        dismiss(animated: true) //削除後にデータ入力画面を自動的に閉じる
    }
}

extension CalendarViewController: EditViewControllerDelegate {
    func recordUpdate() {
        getRecord()
        calendarView.reloadData()
    }
}
