/*
 Coded by Sarthak Sharma
 */

/*
 *Class implements Firebase and Charts libraries
 *It uses charts to visualize data we get from the nutrition API
 */
import UIKit
import Firebase
import Charts

class FoodHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var showGraphs: BarChartView!
    @IBOutlet weak var foodHistoryTableView: UITableView!
    
    var foodName : String = ""
    var historicFood : String = ""
    var historicNuts = [String: Double]()
    var firebaseFoodName = [String?]()
    var modifiedHistoricFood : String = ""
    var microNutDictionary = [String: Double]()
  
    /*
    * Not Used ATM
    var foodArray : [Food] = [Food]()
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodHistoryTableView.dataSource = self
        foodHistoryTableView.delegate = self
        
        getDaValue()
        getFoodHistory()
        
    }

    /*
    *Get food name and nutrient info from Firebase
    */
    func getDaValue() {
        //HTTPS firebase dbase url link
        let foodDB = Database.database().reference().child("FoodHistory")
       
        let foodHistory = ["User": Auth.auth().currentUser?.email! as Any, "FoodHistory": foodName, "MicroNuts": microNutDictionary]
        //print("foodHistory is ")
        //print(foodHistory)
        //error checking and saving data in the database
        
        foodDB.childByAutoId().setValue(foodHistory) {
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Food saved successfully")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    *This method gets the food and nutrient history from firebase
    */
    func getFoodHistory()
    {
        //good the food item name from firebase
        let foodDB = Database.database().reference().child("FoodHistory")
        foodDB.observe(.childAdded) { (snapshot) in
            //snapShot value represents the food name and its micronutrients
            if let snapshotValue = snapshot.value as? [String : AnyObject]
            {

                let foodName = [snapshotValue["FoodHistory"] as? String]
                let microNuts = snapshotValue["MicroNuts"] as? [String: Double]
           
               //if statement used to skip nil values
                if( microNuts != nil){
                       for (value, numbers) in microNuts! {
                        self.microNutDictionary = microNuts!
                      }
                }
                else
                {
                    print("microNuts is nil");
                }
                
//                let snapshotValue = snapshot.value as! [String : AnyObject]
//                print("going into for loop")
//                for child in snapshot.children {
//                    let snap = child as! DataSnapshot
//                    let key = snap.key
//                    let value = snap.value
//                    print("key = \(key)  value = \(value)")
//                }
                

                //print(foodName)
                self.firebaseFoodName.append(contentsOf: foodName)
                if( microNuts != nil){
                    self.historicNuts = microNuts!
                }
                else
                {
                        print("This is a test")
                }
                //print("value of micronuts is")
                //print(self.historicNuts)
                self.foodHistoryTableView.reloadData()

            /*
                 * ONLY FOR DEBUG
                print("Value of firebaseArray is ")
                print(self.firebaseFoodName)
                print(self.firebaseFoodName.count)
                print("Value of the dictionary is ")
                print(self.microNutDictionary)
            */
            }
            else
            {
                print("Error retrieving FrB data") // snapshot value is nil
            }
        }

    }
    //append food list to table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.firebaseFoodName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.firebaseFoodName[indexPath.row] //.foodName

        return cell
    }
    /*
    * Get single values from the food table history and send it to graph
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //print("on user click")
        getFoodHistory()
        historicFood = self.firebaseFoodName[indexPath.row]!
       
        //print("full micro array is")
        //print(microNutDictionary)
        let nutriCount = Array(historicNuts.values)
        
      
        updateChartWithData(values: nutriCount)
        //print(nutriCount)
    }
    
    /*
     * Same method from previous class to display grphs
     */
    func updateChartWithData(values: [Double]) {
        showGraphs.reloadInputViews()
        
        //Numerical data from the dictionary will be visualized in DataEnteries
        var dataEnteries: [BarChartDataEntry] = []
        //Send all the values from the dictionary to the nutriCount Array variable for data visualizing purposes
        //let nutriCount = Array(microNutDictionary.values)
        let nutriValues = Array(microNutDictionary.keys)
        
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEnteries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEnteries, label: "NutriCount")
        let chartData = BarChartData(dataSet: chartDataSet)
        showGraphs.xAxis.valueFormatter = IndexAxisValueFormatter(values:nutriValues)
        showGraphs.data = chartData
        showGraphs.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
        showGraphs.xAxis.labelPosition = .bottom
        showGraphs.xAxis.drawGridLinesEnabled = false
        showGraphs.xAxis.labelRotationAngle = 90
        showGraphs.xAxis.labelCount = nutriValues.count
    }
}
