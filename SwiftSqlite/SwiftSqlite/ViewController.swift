//
//  ViewController.swift
//  SwiftSqlite
//
//  Created by Rajesh on 18/07/18.
//  Copyright © 2018 Rajesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.intializeDatabase()
        self.inserDataIntoTable()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func intializeDatabase()
    {
        //-- Initialize
        DBHelper.shared.initDatabase()
    }
    
    func inserDataIntoTable()
    {
        //-- Create temp value to insert into table
        let dataDict = ["username" : "svmrajesh",
                        "email" : "svmrajesh@gmail.com"] as NSDictionary
        
        //-- Insert data into table
        Table_user.shared.user_insert(valueDict: dataDict ) { (isSuccess) in
            if (isSuccess)!{
                print("Data inserted successfuly")
            }
            
            self.getDataFromTable()
        }
    }
    
    func getDataFromTable()
    {
        //-- Get value from table
        Table_user.shared.user_getForEmail(forEmail: "svmrajesh@gmail.com") { (dataDict, dataRow, isSuccess) in
            print("Result = \(dataDict ?? [:])")
        }
    }
    
    func updateColumnInTable()
    {
        Table_user.shared.user_UpdateColumn()
    }
}

