//
//  ConfirmViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/07/26.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var confirmViewTimeData = Timedata()
    var keysArray: [Int] = []
    @IBOutlet weak var confirmImageView: UIImageView!
    var confirmImage: UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        confirmImageView.image = confirmImage
        confirmImageView.isUserInteractionEnabled = true
        
        keysArray = Array(confirmViewTimeData.timeData!.keys)
        keysArray.sort()
        
        let footerCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableFooterCell")!
        let footerView: UIView = footerCell.contentView
        tableView.tableFooterView = footerView
        
        print(confirmViewTimeData.timeData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (confirmViewTimeData.timeData![keysArray[section]]?.count)!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let num = confirmViewTimeData.timeData![keysArray[indexPath.section]]
        cell.textLabel?.text = String(keysArray[indexPath.section]) + "時" + String(num![indexPath.row]) + "分"
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(keysArray[section]) + "時"
    }
    
    @IBAction func pinchConfirmImage(_ sender: UIPinchGestureRecognizer) {
        confirmImageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    
    @IBAction func gotoCompletePage(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let completeVC = storyboard.instantiateViewController(withIdentifier: "CompletePage") as! CompleteViewController
        completeVC.completeTimeData = confirmViewTimeData
        self.navigationController?.pushViewController(completeVC, animated: true)
        
    }
    
}
