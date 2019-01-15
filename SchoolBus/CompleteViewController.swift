//
//  CompleteViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/08/01.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit
import FMDB

class CompleteViewController: UIViewController {
    
    var completeTimeData = Timedata()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        createTable()
        for time in (completeTimeData.timeData?.keys)! {
            for min in (completeTimeData.timeData![time])! {
                insertTable(Time: time, Min: min)
            }
        }
        testfunction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func createTable() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths.first! as String
        let path = dir.appendingPathComponent("timetable.db")
        let db = FMDatabase(path: path)
        
        db.open()
            let createSql:String = "CREATE TABLE IF NOT EXISTS 'time_tbl' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'university' TEXT, 'stopover1' TEXT, 'stopover2' TEXT, 'timedata' TEXT, 'favoritekey' INTEGER DEFAULT 0)"
        db.executeUpdate(createSql, withArgumentsIn: [])
        db.close()
    }
    
    func insertTable(Time: Int, Min: Int) {
        var insertTime: String = String(Time)
        var insertMin: String = String(Min)
        
        if (Time < 10) {
            insertTime = "0" + String(Time)
        }
        
        if (Min < 10) {
            insertMin = "0" + String(Min)
        }
        
        let insertTimeData = insertTime + insertMin + "00"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths.first! as String
        let path = dir.appendingPathComponent("timetable.db")
        let db = FMDatabase(path: path)
        
        db.open()
        let insertSql:String = "INSERT INTO time_tbl (university, stopover1, stopover2, timedata) values (?, ?, ?, ?)"
        db.executeUpdate(insertSql, withArgumentsIn: [completeTimeData.university!, completeTimeData.stopoverArray![0], completeTimeData.stopoverArray![1], insertTimeData])
        db.close()
    }
    
    func testfunction() {
        let encoder = JSONEncoder()
        
        var jsonstr: String = ""
        var data: Data?
        
        do {
            data = try encoder.encode(completeTimeData)
            jsonstr = String(data: data!, encoding: .utf8)!
            print(jsonstr)
        } catch {
            print(error.localizedDescription)
        }
        
        let url = URL(string: "http://192.168.1.13:8888/schoolbus/test.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = data
        } catch {
            print(error.localizedDescription)
        }
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
}
