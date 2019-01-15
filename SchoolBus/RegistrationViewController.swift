//
//  RegistrationViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/07/23.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var superStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    
    var registrationViewTimeData = Timedata()
    
    var registImage: UIImage?
    
    // 時刻表登録時に時間のボタンをタップするときの処理
    @objc func changeColor(_ sender: UIButton) {
        var tmp2 = registrationViewTimeData.timeData![sender.tag/60]
        
        if (tmp2 == nil){
            tmp2 = [Int]()
        }
        
        // 時刻を登録するときのボタン処理
        if (sender.backgroundColor == .white){
            tmp2?.append(Int(sender.currentTitle!)!)
            tmp2?.sort()
            registrationViewTimeData.timeData?.updateValue(tmp2!, forKey: sender.tag/60)
            sender.backgroundColor = .blue
        
        // 時刻登録を解除するときのボタン処理
        } else {
            let index = tmp2?.index(of: Int(sender.currentTitle!)!)
            tmp2?.remove(at: index!)
            registrationViewTimeData.timeData?.updateValue(tmp2!, forKey: sender.tag/60)
            sender.backgroundColor = .white
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "default.png")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.imageViewTapped(_:))))
        
        registrationViewTimeData.timeData = [:]
        
        // 時刻表を描画する処理
        for i in 0..<18 {
            let label = UILabel()
            let stackview = UIStackView()
            label.backgroundColor = UIColor(red: 0.8863, green: 0.8863, blue: 0.8863, alpha: 1.0)
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UIColor.black.cgColor
            label.frame = CGRect(x:0, y:0 + (i * 60), width:60, height:60)
            label.text = (i + 6).description
            label.textAlignment = .center
            label.textColor = .black
            stackview.addArrangedSubview(label)
            
            for j in 0..<60 {
                let button = UIButton()
                button.tag = 60 * (i + 6) + j
                button.frame = CGRect(x: 20 + (j * 60), y: 0 + (i * 60), width: 60, height: 60)
                button.backgroundColor = .white
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.black.cgColor
                button.setTitle(j.description, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.addTarget(self, action: #selector(changeColor(_:)), for: .touchUpInside)
                
                stackview.addArrangedSubview(button)
            }
            superStackView.addArrangedSubview(stackview)
            
        }
    }
    
    // デフォルトで配置してある画像をタップするとカメラロールが表示される
    func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    // カメラロールから写真を選ぶと呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        registImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = registImage
        self.dismiss(animated: true)
    }
    
    @IBAction func pinchImage(_ sender: UIPinchGestureRecognizer) {
        self.imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    @IBAction func transitionConfirmPage(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let confirmVC = storyboard.instantiateViewController(withIdentifier: "ConfirmPage") as! ConfirmViewController
        registrationViewTimeData.timeData?.keys.sorted()
        confirmVC.confirmViewTimeData = registrationViewTimeData
        confirmVC.confirmImage = registImage
        self.navigationController?.pushViewController(confirmVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
