//
//  HistoryVViewController.swift
//  NutritionAndFitness
//
//  Created by Xcode User on 2018-04-10.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit
import Charts

class HistoryVViewController: UIViewController {

    @IBOutlet weak var historicGraph: BarLineChartViewBase!
    var modifiedHistoricFood : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
