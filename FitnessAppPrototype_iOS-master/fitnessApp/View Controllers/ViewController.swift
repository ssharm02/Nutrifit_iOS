//
//  ViewController.swift
//  fitnessApp
//
//  Created by Xcode User on 2018-03-17.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    let border = CALayer()
    let border2 = CALayer()
    let width = CGFloat(2.0)
    
    var db: OpaquePointer?
    
    
    @IBAction func unwindToThisViewController(sender : UIStoryboardSegue)
    {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        bottomBorder(tf: tfUsername, border: border)
        bottomBorder(tf: tfPassword, border: border2)    
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


}

