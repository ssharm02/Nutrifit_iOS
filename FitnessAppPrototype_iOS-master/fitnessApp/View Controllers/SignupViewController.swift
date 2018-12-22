//
//  SignupViewController.swift
//  fitnessApp
//
//  Created by Xcode User on 2018-03-17.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit
import SQLite3

class SignupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPassword2: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var noUsername: UILabel!
    @IBOutlet weak var noPw: UILabel!
    @IBOutlet weak var noPw2: UILabel!
    @IBOutlet weak var noEmail: UILabel!
    @IBOutlet weak var noFirstName: UILabel!
    @IBOutlet weak var noLastName: UILabel!
    
    
    let width = CGFloat(2.0)
    let borderUsername = CALayer()
    let borderPassword = CALayer()
    let borderPassword2 = CALayer()
    let borderEmail = CALayer()
    let borderFirstName = CALayer()
    let borderLastName = CALayer()
    
    var db: OpaquePointer?
  
    var customerList = [Customer]()
    
    @IBOutlet weak var tableViewCustomers: UITableView!
    @IBOutlet weak var buttonQuery: UIButton!
    
    @IBAction func buttonQueryClicked(_ sender: Any) {
        readValues()
    }
    
    
    @IBAction func buttonSubmit(_ sender: Any) {
        
        let username = tfUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let firstname = tfFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = tfLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pw = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pw2 = tfPassword2.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(username?.isEmpty)!{
            noUsername.isHidden = false
            return
        }
        if(firstname?.isEmpty)!{
            noFirstName.isHidden = false
            return
        }
        if(lastname?.isEmpty)!{
            noLastName.isHidden = false
            return
        }
        if(email?.isEmpty)!{
            noEmail.isHidden = false
            return
        }
        if(pw?.isEmpty)!{
            noPw.isHidden = false
            return
        }
        if(pw2?.isEmpty)!{
            noPw2.isHidden = false
            return
        }

        if pw != pw2{
            noPw2.text = "*Passwords do not match"
            noPw2.isHidden = false
            return
        }
      
        var stmt: OpaquePointer?
        let insertQuery = "INSERT INTO Customers (id, username, firstname, lastname, email, password) VALUES (NULL, ?, ?, ?, ?, ?)"

        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            print("Error binding query")
        }
        
        if sqlite3_bind_text(stmt, 1, username, -1, nil) != SQLITE_OK{
            print("Error binding username")
        }
        
        if sqlite3_bind_text(stmt, 2, firstname, -1, nil) != SQLITE_OK{
            print("Error binding first name")
        }
        
        if sqlite3_bind_text(stmt, 3, lastname, -1, nil) != SQLITE_OK{
            print("Error binding last name")
        }
        
        if sqlite3_bind_text(stmt, 4, email, -1, nil) != SQLITE_OK{
            print("Error binding email")
        }
        
        if sqlite3_bind_text(stmt, 5, pw2, -1, nil) != SQLITE_OK{
            print("Error binding password")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            
            //performSegue(withIdentifier: "DashboardSegue", sender: nil)
            
            tfUsername.text = ""
            tfFirstName.text = ""
            tfLastName.text = ""
            tfEmail.text = ""
            tfPassword.text = ""
            tfPassword2.text = ""
            
            readValues()
            
            print("Customer saved successfully")
        }
    }
    
    func readValues(){
        
        //clear list of customers
        customerList.removeAll()
        
        //select query
        let queryString = "SELECT * FROM Customers"
        
        //statement pointer
        var stmt: OpaquePointer? = nil
        
        //preparing query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errormsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errormsg)")
            return
        }
        
        //traversing thru all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let username = String(cString: sqlite3_column_text(stmt, 0))
            let firstName = String(cString: sqlite3_column_text(stmt, 1))
            let lastName = String(cString: sqlite3_column_text(stmt, 2))
            let email = String(cString: sqlite3_column_text(stmt, 3))
            let password = String(cString: sqlite3_column_text(stmt, 4))
            
            //adding values to list
            customerList.append(Customer(username: String(username), firstName: String(firstName), lastName: String(lastName), email: String(email), password: String(password)))
            print(username)
            print(firstName)
            print(lastName)
            print(email)
            print(password)
        }

        
        self.tableViewCustomers.reloadData()
        
    }
    
    //gives row count of table view which is total number of customers in list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerList.count;
    }
    
    //binds customer name with tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let customer : Customer
        customer = customerList[indexPath.row]
        cell.textLabel?.text = customer.lastName
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bottomBorder(tf: tfUsername, border: borderUsername)
        bottomBorder(tf: tfPassword, border: borderPassword)
        bottomBorder(tf: tfPassword2, border: borderPassword2)
        bottomBorder(tf: tfEmail, border: borderEmail)
        bottomBorder(tf: tfFirstName, border: borderFirstName)
        bottomBorder(tf: tfLastName, border: borderLastName)
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("CustomerDatabase.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
            return
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Customers(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, firstname TEXT, lastname TEXT, email TEXT, password TEXT)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        
        print("Everything is fine")
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
