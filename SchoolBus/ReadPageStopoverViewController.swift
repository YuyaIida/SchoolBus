//
//  ReadPageStopoverViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/08/03.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit
import FMDB

class ReadPageStopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var readPageStopoverTimedata = Timedata()
    var dataBool: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataBool = false
        readPageStopoverTimedata.stopoverArray = []
        
        self.searchStopover()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func searchStopover() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths.first! as String
        let path = dir.appendingPathComponent("timetable.db")
        let db = FMDatabase(path: path)
        readPageStopoverTimedata.stopoverArray = []
        
        db.open()
        let searchSql:String = "SELECT DISTINCT stopover1, stopover2 from time_tbl WHERE university = ?"
        if let results = db.executeQuery(searchSql, withArgumentsIn: [readPageStopoverTimedata.university!]) {
            while results.next() {
                dataBool = true
                readPageStopoverTimedata.stopoverArray?.append(results.string(forColumnIndex: 0)!)
                readPageStopoverTimedata.stopoverArray?.append(results.string(forColumnIndex: 1)!)
            }
        }
        db.close()
        
        let myUrl:URL = URL(string: "http://192.168.1.8:8888/schoolbus/searchStopover.php")!
        let req = NSMutableURLRequest(url: myUrl)
        
        req.httpMethod = "POST"
        req.httpBody = readPageStopoverTimedata.university?.data(using: .utf8)
        
        let myHttpSession = HttpClientImpl()
        let (data, _, _) = myHttpSession.execute(request: req as URLRequest)
        if data != nil {
            // 受け取ったデータに対する処理
            print(String(data: data as! Data, encoding: .utf8))
            let dic = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
            for json in dic {
                let start = json["start"] as! String
                let end = json["end"] as! String
                self.readPageStopoverTimedata.stopoverArray?.append(start)
                self.readPageStopoverTimedata.stopoverArray?.append(end)
            }
            self.tableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (readPageStopoverTimedata.stopoverArray?.count)! / 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("test")
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let index = indexPath.row * 2
        cell.textLabel?.text = (readPageStopoverTimedata.stopoverArray?[index])! + "  <->  " + readPageStopoverTimedata.stopoverArray![index + 1]
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "経由地"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //searchStopover()
        let index = indexPath.row * 2
        let tmp = readPageStopoverTimedata.stopoverArray![index]
        let tmp2 = readPageStopoverTimedata.stopoverArray![index + 1]
        
        readPageStopoverTimedata.stopoverArray = []
        
        readPageStopoverTimedata.stopoverArray?.append(tmp)
        readPageStopoverTimedata.stopoverArray?.append(tmp2)
        
        let storyboard: UIStoryboard = self.storyboard!
        let timetableVC = storyboard.instantiateViewController(withIdentifier: "TimeTablePage") as! TimetableViewController
        
        timetableVC.timeTableTimeData = readPageStopoverTimedata
        self.navigationController?.pushViewController(timetableVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

public class HttpClientImpl {
    
    private let session: URLSession
    
    public init(config: URLSessionConfiguration? = nil) {
        self.session = config.map { URLSession(configuration: $0) } ?? URLSession.shared
    }
    
    public func execute(request: URLRequest) -> (Data?, URLResponse?, NSError?) {
        var d: Data? = nil
        var r: URLResponse? = nil
        var e: NSError? = nil
        let semaphore = DispatchSemaphore(value: 0)
        session.dataTask(with: request) { (data, response, error) -> Void in
                d = data as Data?
                r = response
                e = error as NSError?
                semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return (d, r, e)
    }
}
