//
//  ViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/07/17.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit
import FMDB

class TopViewController: UIViewController {
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var sec: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var firstStopLabel: UILabel!
    @IBOutlet weak var lastStopLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var timer : Timer!
    var topTimeData = Timedata()
    var TimeArray: [String] = []
    var userTimer = 0
    var count = 0
    var date: String = ""
    var date2: String = ""
    var stopOverBool = false
    var stopoverCount = 0
    var destinationBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopOverBool = false
        let now = Date()
        let format = DateFormatter()
        format.locale = Locale(identifier: "ja_JP")
        format.dateFormat = "HHmmss"
        date = format.string(from: now)
        if Int(date)! < 100000 {
            date2 = "0" + String(Int(date)! + 10000)
        } else {
            date2 = String(Int(date)! + 10000)
        }
        stopoverCount = 0
        
        searchToppage()
        
        if (TimeArray.isEmpty == false){
            count = Int((format.date(from: TimeArray[0])?.timeIntervalSince(format.date(from: date)!))!)
            labelSetting()
            createTimer()
            
        } else {
            emptyLabelSetting()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(timer != nil && timer.isValid == true){
            timer.invalidate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction(sender:)), userInfo: nil, repeats: true)
        
        timer.fire()
    }
    
    func timerAction(sender: Timer) {
        
        if count == 0 {
            emptyLabelSetting()
            sender.invalidate()
        }
        
        let minuteCount = count / 60
        let secCount = count % 60
        minLabel.text = String(minuteCount)
        secLabel.text = String(secCount)
        count -= 1
    }
    
    func searchToppage() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths.first! as String
        let path = dir.appendingPathComponent("timetable.db")
        print(path)
        let db = FMDatabase(path: path)
        topTimeData.stopoverArray = []
        TimeArray = []
        
        db.open()
        
        let searchStopoverSql:String = "SELECT DISTINCT stopover1, stopover2 from time_tbl WHERE favoritekey = 1"
        if let results = db.executeQuery(searchStopoverSql, withArgumentsIn: []) {
            while results.next() {
                
                stopOverBool = true
                stopoverCount += 1
                topTimeData.stopoverArray?.append(results.string(forColumnIndex: 0)!)
                topTimeData.stopoverArray?.append(results.string(forColumnIndex: 1)!)
            }
        }
        
        if (stopOverBool == true){
            let searchTimeSql:String = "SELECT timedata from time_tbl WHERE favoritekey = 1 and timedata BETWEEN ? AND ? and stopover1 = ? and stopover2 = ? ORDER BY timedata"

            if let results = db.executeQuery(searchTimeSql, withArgumentsIn: [date, date2, topTimeData.stopoverArray![0], topTimeData.stopoverArray![1]]) {
                while results.next() {
                    TimeArray.append(results.string(forColumnIndex: 0)!)
                }
            }
            
            firstStopLabel.text = topTimeData.stopoverArray?[0]
            lastStopLabel.text = topTimeData.stopoverArray?[1]
        }
        
        db.close()
    }
    
    func searchReturnToppage() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths.first! as String
        let path = dir.appendingPathComponent("timetable.db")
        let db = FMDatabase(path: path)
        TimeArray = []
        
        db.open()
        if stopOverBool == true {
            let searchTimeSql:String = "SELECT timedata from time_tbl WHERE favoritekey = 1 and timedata BETWEEN ? AND ? and stopover1 = ? and stopover2 = ? ORDER BY timedata"
            
            if stopoverCount >= 2 {
                
                
                
                if let results = db.executeQuery(searchTimeSql, withArgumentsIn: [date, date2, topTimeData.stopoverArray![2], topTimeData.stopoverArray![3]]) {
                    while results.next() {
                        
                        TimeArray.append(results.string(forColumnIndex: 0)!)
                    }
                }
                firstStopLabel.text = topTimeData.stopoverArray?[2]
                lastStopLabel.text = topTimeData.stopoverArray?[3]
            }
            
        }
        db.close()
    }
    
    @IBAction func outwardDisp(_ sender: Any) {
        if(timer != nil){
            if timer.isValid == true {
                timer.invalidate()
            }
        }
        viewWillAppear(true)
    }
    
    func emptyLabelSetting() {
        emptyLabel.text = "1時間以内にバスは来ません"
        emptyLabel.textColor = .gray
        secLabel.textColor = .gray
        minLabel.textColor = .gray
        min.textColor = .gray
        sec.textColor = .gray
        
    }
    
    func labelSetting() {
        emptyLabel.text = ""
        secLabel.textColor = .black
        minLabel.textColor = .black
        min.textColor = .black
        sec.textColor = .black
    }
    
    @IBAction func changeDestination(_ sender: Any) {
        if (destinationBool == true) {
            destinationBool = false
            
            if(timer != nil){
                if timer.isValid == true {
                    timer.invalidate()
                }
            }
            
            let now = Date()
            let format = DateFormatter()
            format.locale = Locale(identifier: "ja_JP")
            format.dateFormat = "HHmmss"
            date = format.string(from: now)
            if Int(date)! < 100000 {
                date2 = "0" + String(Int(date)! + 10000)
            } else {
                date2 = String(Int(date)! + 10000)
            }
            
            searchReturnToppage()
            
            if (TimeArray.isEmpty == false){
                count = Int((format.date(from: TimeArray[0])?.timeIntervalSince(format.date(from: date)!))!)
                labelSetting()
                createTimer()
                
            } else {
                emptyLabelSetting()
                secLabel.text = "00"
                minLabel.text = "00"
                
            }
            
        } else {
            destinationBool = true
            
            if(timer != nil){
                if timer.isValid == true {
                    timer.invalidate()
                }
            }
            viewWillAppear(true)
        }
        
    }
    
}

