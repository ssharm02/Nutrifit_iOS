/*
 
 Coded by Sarthak Sharma
 
 */

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import Firebase
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    /*
     * Realm Database test not used ATM
     */
    class Foods : Object {
        @objc dynamic var foodName : String = ""
        let microNutNam = List<String>()
        let microNutzVal = List<Double>()
    }
    

    
    @IBOutlet weak var nutrientTableView: UITableView!
    //@IBOutlet weak var caloriesLable: UILabel!
    @IBOutlet weak var foodNameText: UITextField!
    
    //Global variables used for string concatination to get final API URL
    let API_Key = "083b6b33f7ed129a3b4a65fa79e96d41";
    let API_ID = "84f4dee2";
    var finalURL = ""
    let baseURL1 = "https://api.edamam.com/api/nutrition-data?"
    //Store the food user enters in an array
    let foodArray = [Food]();
    var foodName : String = ""
    //Dictionary values are transfered to MicroNutrientArray2 so they can be displayed inside the tableview
    var microNutrientArray2 : [String] = []
    //Stores the key value paris of nutrients and their double value
    var microNutDictionary = [String: Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        nutrientTableView.dataSource = self
        nutrientTableView.delegate = self
    }
    /*
     Realm test please ignore, test for capstone project
    */
    func realmTest() {
        let realm = try! Realm()
        let foodXX = realm.objects(Foods.self).filter("foodName = 'IceCream'").first!
        let nutriCount = Array(microNutDictionary.values)
        let nutriValues = Array(microNutDictionary.keys)
        try! realm.write {
            foodXX.microNutzVal.removeAll()
            
        }
    }
    
    @IBAction func unwindToViewController(segue:UIStoryboardSegue) { }
    
    /*
     *Returns the number of rows in the array
     */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (microNutrientArray2.count)
    }
    /*
    * Display the Micronutrient Array values inside the tableview
    */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = microNutrientArray2[indexPath.row]
        return(cell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/*
 *On Button press get text from text field.  Modify string using replacingOccurrence replacing whitespace
 *With %20.  Finally update the URL string with API_ID, API_Key and modifiedFoodName and call getNutritionData
 */
    @IBAction func buttonAction(_ sender: Any)
    {
        if(foodNameText.text?.isEmpty)!
        {
            // create the alert
            let alert = UIAlertController(title: "Message", message: "Please Enter Food Name and Quantity.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else{
        foodName = foodNameText.text!
        let modifiedFoodName = foodName.replacingOccurrences(of: " ", with: "%20")
        let baseURL = "http://api.edamam.com/api/nutrition-data?app_id=\(API_ID)&app_key=\(API_Key)&ingr=\(modifiedFoodName)"
        //print(baseURL)
        getNutritionData(url: baseURL)
        }
    }

    /*
    * Register a dummy user account for Google Firebase dBase for the purpose of this project
    */
    @IBAction func showFoodHistory(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: "Sarthak@Sharma.com", password: "123456") {
            (user, error) in
            
            if error != nil {
                print(error!)
                
            } else {
                print("Registeration Successful")
                
                self.performSegue(withIdentifier: "gotoFoodHistory", sender: self)
            }
        }
    }
    
    
    /*MARK: - Networking
    *Connect to the Edamam API using Alamofire/SwiftyJSON libraries and get the appropriate micro and macro nutrient values
    */
    /***************************************************************/
    func getNutritionData(url: String) {
        Alamofire.request(url)
            .responseString { response in
                guard let responseString = response.result.value else {
                    print("ERROR: didn't get a string in the response")
                    return
                }
                //var json: [[String: Any]]?
                if  let data = (responseString as NSString).data(using: String.Encoding.utf8.rawValue) {
                    do {
                        let nutritionJSON = try? JSON(data: data)
                        //For debugging JSON
                        //print(nutritionJSON)
                        
                        //NutritionJSON2 not used atm, might implement if I implement structure
                        //let nutritionJSON2 = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                        //Send the JSON data to the updateNutritionData function where it will updated to the MicroNutDictionary.
                        self.updateNutritionData(json: nutritionJSON!)
                        //json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    }
                    catch
                    {
                        print(error.localizedDescription)
                        return
                    }
                }
                    self.nutrientTableView.reloadData()
        }
    }

    
    //MARK: - JSON Parsing
    //Parse the JSON data from the networking method and send the values to appropriate
    //MicroNutrientDictionary and Array
    /***************************************************************/

    func updateNutritionData(json : JSON){
        
        /*
         *TODO: Some math will be done on these values depending on if they gram, micrograms etc
         */
        let monoSatFat = json["totalNutrients"]["FAMS"]["quantity"].doubleValue.rounded()/100
        let folate = json["totalNutrients"]["FOLFD"]["quantity"].doubleValue.rounded()/100
        let vitaminE = json["totalNutrients"]["TOCPHA"]["quantity"].doubleValue
        let thia = json["totalNutrients"]["THIA"]["quantity"].doubleValue.rounded()/100
        
        let satFat = json["totalNutrients"]["FASAT"]["quantity"].doubleValue
        let procnt = json["totalNutrients"]["PROCNT"]["quantity"].doubleValue.rounded()/100
        let vitaminA = json["totalNutrients"]["VITA_RAE"]["quantity"].doubleValue
        let ribf = json["totalNutrients"]["RIBF"]["quantity"].doubleValue
        
        let chocdf = json["totalNutrients"]["CHOCDF"]["quantity"].doubleValue.rounded()/10
        let vitk1 = json["totalNutrients"]["VITK1"]["quantity"].doubleValue.rounded()/100
        let na = json["totalNutrients"]["NA"]["quantity"].doubleValue.rounded()/100
        let fibtg = json["totalNutrients"]["FIBTG"]["quantity"].doubleValue.rounded()/100
        
        
        let fat = json["totalNutrients"]["FAT"]["quantity"].doubleValue.rounded()/100
        let fapu = json["totalNutrients"]["FAPU"]["quantity"].doubleValue.rounded()/100
        let ca = json["totalNutrients"]["CA"]["quantity"].doubleValue.rounded()/100
        let foldfe = json["totalNutrients"]["FOLDFE"]["quantity"].doubleValue.rounded()/100
        
        let nia = json["totalNutrients"]["NIA"]["quantity"].doubleValue.rounded()/100
        let zn = json["totalNutrients"]["ZN"]["quantity"].doubleValue
        let mg = json["totalNutrients"]["MG"]["quantity"].doubleValue.rounded()/100
        let vitaminK = json["totalNutrients"]["K"]["quantity"].doubleValue.rounded()/100
        
        let sugar = json["totalNutrients"]["SUGAR"]["quantity"].doubleValue.rounded()/100
        let iron = json["totalNutrients"]["FE"]["quantity"].doubleValue.rounded()/100
        let vitc = json["totalNutrients"]["VITC"]["quantity"].doubleValue.rounded()/100
        let vitB6 = json["totalNutrients"]["VITB6A"]["quantity"].doubleValue
        
        let enerKCal = json["totalNutrients"]["ENERC_KCAL"]["quantity"].doubleValue.rounded()/100
        let phos = json["totalNutrients"]["P"]["quantity"].doubleValue.rounded()/100
        
        
        //store all data in a dictionary
        //microNutrientArray["Calories"] = cals
        microNutDictionary["Energy-Kcal"] = enerKCal
        microNutDictionary["Phosphorus"] = phos
        microNutDictionary["Vit-B6"] = vitB6
        microNutDictionary["Vit-C"] = vitc
        microNutDictionary["Iron"] = iron
        microNutDictionary["Sugar"] = sugar
        microNutDictionary["Vit-K"] = vitaminK
        microNutDictionary["Magnesium"] = mg
        microNutDictionary["Zinc"] = zn
        microNutDictionary["Vit-B3"] = nia
        microNutDictionary["Folate"] = foldfe
        microNutDictionary["Calcium"] = ca
        microNutDictionary["Poly-Fat"] = fapu
        microNutDictionary["Fat"] = fat
        microNutDictionary["Fiber"] = fibtg
        microNutDictionary["Salt"] = na
        microNutDictionary["Vit-K1"] = vitk1
        microNutDictionary["Carbs"] = chocdf
        microNutDictionary["Sat-Fat"] = satFat
        microNutDictionary["Protein"] = procnt
        microNutDictionary["Vit-A"] = vitaminA
        microNutDictionary["Vit-B2"] = ribf
        microNutDictionary["Mon-Fat"] = monoSatFat
        microNutDictionary["Folate"] = folate
        microNutDictionary["Vit-E"] = vitaminE
        microNutDictionary["Vit-B1"] = thia
        
        //Send dictionary data into MicroNutrientArray2 so it can be displayed on tableView
        for(key, value) in microNutDictionary {
            self.microNutrientArray2.append("\(key) \(value)")
        }
    }
    
    /*
    *   Send the microNutrientDictionary with all key value pairs to the graphViewController via
    * 
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ViewGraphData"
        {
            let destinationVC = segue.destination as! ShowGraphViewController
            destinationVC.microNutDictionary = microNutDictionary
        }
        if segue.identifier == "gotoFoodHistory"
        {
            let destinationVC = segue.destination as! FoodHistoryViewController
            destinationVC.foodName = foodName
            destinationVC.microNutDictionary = microNutDictionary
        }
    }

}
