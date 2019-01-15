//
//  TimetableViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/08/07.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit
import FMDB

class TimetableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var state: AriticleState = CellStateNotRegisteredAsFavorite()
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var firstStopLabel: UILabel!
    @IBOutlet weak var lastStopLabel: UILabel!
    
    var timeTableTimeData = Timedata()
    var TimetableArray: [String] = []
    var keysArray: [Int] = []
    var tmpArray: [String] = []
    var favoriteKey: Int = 0
    var dataBool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        firstStopLabel.text = timeTableTimeData.stopoverArray?[0]
        lastStopLabel.text = timeTableTimeData.stopoverArray?[1]
        
        searchTimeData { timeTables in
            self.TimetableArray = timeTables
            
            self.timeTableTimeData.timeData = [:]
            
            for data in self.TimetableArray {
                var tmp = (self.timeTableTimeData.timeData?[Int(data.prefix(2))!])
                if (tmp == nil) {
                    tmp = []
                }
                tmp?.append(Int(data.suffix(2))!)
                self.timeTableTimeData.timeData?.updateValue(tmp!, forKey: Int(data.prefix(2))!)
                tmp = []
                
            }
            
            self.keysArray = Array(self.timeTableTimeData.timeData!.keys)
            self.keysArray.sort()
        }
        
        searchFavoriteKey()
        
        if favoriteKey == 1 {
            state = CellStateRegisteredAsFavorite()
            favoriteButton.setTitleColor(.red, for: .normal)
        } else {
            state = CellStateNotRegisteredAsFavorite()
            favoriteButton.setTitleColor(.blue, for: .normal)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataBool = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(timeTableTimeData.timeData![keysArray[section]]?.count)
        return (timeTableTimeData.timeData![keysArray[section]]?.count)!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let num = timeTableTimeData.timeData![keysArray[indexPath.section]]
        cell.textLabel?.text = String(keysArray[indexPath.section]) + "時" + String(num![indexPath.row]) + "分"
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(keysArray[section]) + "時"
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        self.state.favoriteButtonTapped(articleCell: self)
    }
    
    func setState(state: AriticleState) {
        self.state = state
    }
    
    func addFavorite() {
        updateFavoriteKey(key: 1)
        self.favoriteButton.setTitleColor(.red, for: .normal)
    }
    
    func removeFavorite() {
        updateFavoriteKey(key: 0)
        self.favoriteButton.setTitleColor(.blue, for: .normal)
    }
    
    func updateFavoriteKey(key: Int) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths.first! as String
        let path = dir.appendingPathComponent("timetable.db")
        let db = FMDatabase(path: path)
        
        db.open()
        let update0Sql:String = "UPDATE time_tbl SET favoritekey = 0 WHERE stopover1 = ? and stopover2 = ? and university = ?"
        let update1Sql:String = "UPDATE time_tbl SET favoritekey = 1 WHERE stopover1 = ? and stopover2 = ? and university = ?"
        if key == 0 {
            db.executeUpdate(update0Sql, withArgumentsIn: [timeTableTimeData.stopoverArray![0], timeTableTimeData.stopoverArray![1], timeTableTimeData.university!])
            db.executeUpdate(update0Sql, withArgumentsIn: [timeTableTimeData.stopoverArray![1], timeTableTimeData.stopoverArray![0], timeTableTimeData.university!])
        } else {
            db.executeUpdate(update1Sql, withArgumentsIn: [timeTableTimeData.stopoverArray![0], timeTableTimeData.stopoverArray![1], timeTableTimeData.university!])
            db.executeUpdate(update1Sql, withArgumentsIn: [timeTableTimeData.stopoverArray![1], timeTableTimeData.stopoverArray![0], timeTableTimeData.university!])
        }
        db.close()
    }
    
    func searchFavoriteKey() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths.first! as String
        let path = dir.appendingPathComponent("timetable.db")
        let db = FMDatabase(path: path)
        db.open()
        let searchSql:String = "SELECT favoritekey from time_tbl WHERE stopover1 = ? and stopover2 = ? and university = ?"
        if let results = db.executeQuery(searchSql, withArgumentsIn: [timeTableTimeData.stopoverArray![0], timeTableTimeData.stopoverArray![1], timeTableTimeData.university!]) {
            while results.next() {
                favoriteKey = Int(results.int(forColumnIndex: 0))
            }
        }
        db.close()
    }
    
    func searchTimeData(completion: @escaping (_ timeTables: [String]) -> ()) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths.first! as String
        let path = dir.appendingPathComponent("timetable.db")
        let db = FMDatabase(path: path)
        
        db.open()
        let searchSql:String = "SELECT timedata from time_tbl WHERE stopover1 = ? and stopover2 = ? and university = ? ORDER BY timedata"
        
        if let results = db.executeQuery(searchSql, withArgumentsIn: [timeTableTimeData.stopoverArray![0], timeTableTimeData.stopoverArray![1], timeTableTimeData.university!]) {
            
            while results.next() {
                dataBool = true
                TimetableArray.append(String(results.string(forColumnIndex: 0)!.prefix(4)))
            }
            print(TimetableArray)
            db.close()
            completion(TimetableArray)
        }
        db.close()
        
        let myUrl:URL = URL(string: "http://192.168.1.8:8888/schoolbus/searchTimeData.php")!
        let req = NSMutableURLRequest(url: myUrl)
        
        req.httpMethod = "POST"
        req.httpBody = ("university=" + timeTableTimeData.university! + "&stopover1=" + timeTableTimeData.stopoverArray![0] + "&stopover2=" + timeTableTimeData.stopoverArray![1]).data(using: .utf8)
        
        let myHttpSession = HttpClientImpl()
        let (data, _, _) = myHttpSession.execute(request: req as URLRequest)
        if data != nil {
            // 受け取ったデータに対する処理
            let dic = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
            for json in dic {
                let takeTime = String((json["take_time"] as! String).prefix(4))
                self.tmpArray.append(takeTime)
            }
            completion(self.tmpArray)
            self.tableView.reloadData()
        }
    }
}
