//
//  SearchViewController.swift
//  fitnessApp
//
//  Created by Xcode User on 2018-03-18.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, BEMCheckBoxDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    let fitnessPro = ["Peter Smith", "Amy Lee"]
    let desc = ["Certified personal trainer for over 10 years. Want to lose weight? Build muscle? I can help you achieve your goals.", "Professional nutritionist and dietician. I provide healthy and holistic solutions to your lifestyle. I specialize in whole foods and real ingredients with a passion for healthy cooking and eating habits."]
    var images = [UIImage(named: "trainer01.jpg"), UIImage(named: "trainer02.jpeg")]
    let ratings = ["3.5/5", "4/5"]
    
    @IBOutlet weak var chkTrainer: BEMCheckBox!
    @IBOutlet weak var chkNutritionist: BEMCheckBox!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        chkTrainer.delegate = self
        chkTrainer.onAnimationType = .oneStroke
    }

    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.tag == 1{
            chkNutritionist.on = true
            chkTrainer.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fitnessPro.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.lbTitle.text = fitnessPro[indexPath.row]
        cell.lbRating.text = ratings[indexPath.row]
        cell.lbDesc.text = desc[indexPath.row]
        cell.imgProfile.image = images[indexPath.row]
   
        
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
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
