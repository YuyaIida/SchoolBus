//
//  StopoverViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/07/19.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit

class StopoverViewController: UIViewController {
    
    @IBOutlet weak var transitionBtn: UIButton!
    @IBOutlet weak var firstStop: UITextField!
    @IBOutlet weak var finalStop: UITextField!
    
    
    var stopoverViewTimeData = Timedata()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 時刻表入力画面へ遷移
    @IBAction func transitionRegistPage(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let registVC = storyboard.instantiateViewController(withIdentifier: "RegistrationPage") as! RegistrationViewController
        stopoverViewTimeData.stopoverArray = []
        stopoverViewTimeData.stopoverArray?.append(firstStop.text!)
        stopoverViewTimeData.stopoverArray?.append(finalStop.text!)
        if (firstStop.text == "") || (finalStop.text == "") {
            let alert: UIAlertController = UIAlertController(title: "乗駅、降駅を入力してください", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return;
        }
        
        registVC.registrationViewTimeData = stopoverViewTimeData
        self.navigationController?.pushViewController(registVC, animated: true)
        
    }
    

}
