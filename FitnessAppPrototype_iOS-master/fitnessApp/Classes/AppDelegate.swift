//
//  AppDelegate.swift
//  fitnessApp
//
//  Created by Xcode User on 2018-03-17.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit
import SQLite3
//import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseName: String!
    var databasePath: String!
    var people: NSMutableArray!
    
    func checkAndCreateDatabase() {
        var success: Bool
        let fileManager = FileManager.default
        //check if file exists already
        success = fileManager.fileExists(atPath: databasePath)
        if success {
            return
        }
        let databasePathFromApp = URL(fileURLWithPath: Bundle.main.resourcePath ?? "").appendingPathComponent(databaseName).absoluteString
        try? fileManager.copyItem(atPath: databasePathFromApp, toPath: databasePath)
    }
    
    func readDataFromDatabase(){
        
        people.removeAllObjects()
        var db: OpaquePointer?
        var customerList = [Customer]()
        
        if sqlite3_open(databasePath, &db) == SQLITE_OK{
        
            //select query
            let queryString = "SELECT * FROM Customers"
            
            //statement pointer
            var stmt: OpaquePointer? = nil
            
            //preparing query
            if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK{
            
                //traversing thru all the records
                while(sqlite3_step(stmt) == SQLITE_ROW){
                    
                    //retrive individually: name, email, food
                    let username = String(cString: sqlite3_column_text(stmt, 0))
                    let firstName = String(cString: sqlite3_column_text(stmt, 1))
                    let lastName = String(cString: sqlite3_column_text(stmt, 2))
                    let email = String(cString: sqlite3_column_text(stmt, 3))
                    let password = String(cString: sqlite3_column_text(stmt, 4))
                    
                    //adding values to list
                    customerList.append(Customer(username: String(username), firstName: String(firstName), lastName: String(lastName), email: String(email), password: String(password)))
                }
            }
            sqlite3_finalize(stmt)
        }
        sqlite3_close(db)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        people = [] //creates empty array
        databaseName = "CustomerDatabase.db"
        
        let documentsPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentsPaths[0]
        databasePath = URL(fileURLWithPath: documentsDir).appendingPathComponent(databaseName).absoluteString
        checkAndCreateDatabase()
        readDataFromDatabase()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

