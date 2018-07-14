/*
  Coded by Sarthak Sharma
 */


/*
 * This classes a third party Charts library to visualize data
 */
import UIKit
import Charts
import PieCharts

class ShowGraphViewController: UIViewController {

   
    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var barView: BarChartView!
    //Array is not used here only for testing ATM
    //var microNutrientArray2 : [String] = []
    
    //Instantiate the microNutDictionary in this controller so we can get values from the previous controller
    var microNutDictionary = [String: Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ShowNuts.text = (microNutrientArray2 as! String)
        // Do any additional setup after loading the view.
        
        //Call the updateChartWith
        updateChartWithData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    * This method to display the nutrient values on a bar chart and a pie graph
    * Uses chart library
    */
    func updateChartWithData() {
        
        //Numerical data from the dictionary will be visualized in DataEnteries using a Bar Chart
        var dataEnteries: [BarChartDataEntry] = []
        
        //NutriCount array contains the micronutrient values from the dictionary
        let nutriCount = Array(microNutDictionary.values)
        
        //NutriValues array contain all the names of the micronutrients in the dictionary (vitamin A, B, C etc)
        let nutriValues = Array(microNutDictionary.keys)
        
        //Traverse all nutriCount values and append them to dataEnteries
        for i in 0..<nutriCount.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: nutriCount[i])
            dataEnteries.append(dataEntry)
        }
        
        /*
        *Following code uses various methods provided by the chart library to append data on graphs, set x and y axis variables, animate the graph using .easeOutQuart etc
        */
        let chartDataSet = BarChartDataSet(values: dataEnteries, label: "NutriCount")
        let chartData = BarChartData(dataSet: chartDataSet)
        barView.xAxis.valueFormatter = IndexAxisValueFormatter(values:nutriValues)
        barView.data = chartData
        barView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
        barView.xAxis.labelPosition = .bottom
        barView.xAxis.drawGridLinesEnabled = false
        barView.xAxis.labelRotationAngle = 90
        barView.xAxis.labelCount = nutriValues.count
        barView.xAxis.avoidFirstLastClippingEnabled = false
        
        //Randomize chart colors and append it to pie graph
        //TODO Fix pie graph added nutrient labels on the bottom
        
                var colors: [UIColor] = []
                for i in 0..<nutriCount.count {
                    let red = Double(arc4random_uniform(256))
                    let green = Double(arc4random_uniform(256))
                    let blue = Double (arc4random_uniform(256))
        
                    let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                    colors.append(color)
                }
                chartDataSet.colors = colors
        
        let chartDataSet2 = PieChartDataSet(values: dataEnteries, label: "Nutrition Stuff")
        let pieData = PieChartData(dataSet: chartDataSet2)
        
        //Take the data from above and append it to pie chart graph
        
        //control various visual elements of the pie chart
        pieView.data = pieData
        pieView.legend.enabled = true
        pieView.chartDescription?.text = ""
        pieView.drawHoleEnabled = false
        pieView.translatesAutoresizingMaskIntoConstraints = false
        pieView.animate(yAxisDuration: 2.0, easingOption: .easeInOutBack)
        
        chartDataSet2.selectionShift = 5
        chartDataSet2.sliceSpace = 2
        //randomize colors in the pie graph
        chartDataSet2.colors = colors
        
    }
}
