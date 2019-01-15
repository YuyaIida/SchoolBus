//
//  ContainerViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/08/09.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var confirmView: ConfirmViewController!
    var containerTimeData = Timedata()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmView.confirmViewTimeData = self.containerTimeData
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
