//
//  ResetViewController.swift
//  fitnessApp
//
//  Created by Xcode User on 2018-03-18.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    let border = CALayer()
    let width = CGFloat(2.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bottomBorder(tf: tfEmail, border: border)
    }

    func bottomBorder( tf : UITextField, border : CALayer){
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: tf.frame.size.height - width, width:  tf.frame.size.width, height: tf.frame.size.height)
        border.borderWidth = width
        tf.layer.addSublayer(border)
        tf.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
