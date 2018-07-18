//
//  Table_user.swift
//  svmrajesh
//
//  Created by Rajesh on 18/07/18.
//  Copyright © 2018 Rajesh. All rights reserved.
//

//-- Issue tracking & quries https://github.com/stephencelis/SQLite.swift/issues/

import Foundation
import SQLite


class Table_user
{
    static let shared = Table_user()
    
    //-- User Table
    let user = Table("user")
    let user_username = Expression<String>("username")
    let user_email = Expression<String>("email")
    let user_mobile = Expression<String>("mobile")
    
    func initUserTable()
    {
        self.user_createTable { (success) in }
    }
    
    //-- Create Table
    func user_createTable(completionHandler : @escaping( Bool?) -> Void)
    {
        do
        {
            try DBHelper.shared.connectDB().run(user.create { t in
                t.column(user_username, unique: true)
                t.column(user_email, unique: true)
            })
            completionHandler(true)
        } catch {
            print("User details table creation error")
            completionHandler(false)
        }
    }
    
    //-- Insert values into table
    func user_insert(valueDict: NSDictionary, completionHandler : @escaping( Bool?) -> Void)
    {
        do
        {
            try DBHelper.shared.connectDB().run(user.insert(
                user_username <- (valueDict.object(forKey: "username") as? String ?? ""),
                user_email <- (valueDict.object(forKey: "email") as? String ?? "")
            ))
            completionHandler(true)
        }
        catch
        {
            print("Error to insert user table")
            
            //-- Update values into table
            self.user_update(valueDict: valueDict) { (success) in
                success == true ? completionHandler(true) : completionHandler(false)
            }
        }
    }
    
    //-- Update values into table
    func user_update(valueDict: NSDictionary, completionHandler : @escaping( Bool?) -> Void)
    {
        let query = user.filter(user_username == (valueDict.object(forKey: "username") as! String))
        
        //-- Get existing datas from table
        var resultRow : Row!
        self.user_getForEmail(forEmail: (valueDict.object(forKey: "username") as! String)) { (resultDict, rowData,  isSuccess) in
            resultRow = rowData
        }
        
        //-- Update values in table
        do{
            try DBHelper.shared.connectDB().run(query.update(
                user_username <- (valueDict.object(forKey: "username") as? String) ?? resultRow[user_username],
                user_email <- (valueDict.object(forKey: "email") as? String) ?? resultRow[user_email]
            ))
            completionHandler(true)
        }
        catch{
            print("Error to update user table")
            completionHandler(false)
        }
    }
    
    //-- Get values from table
    func user_getForEmail(forEmail : String, completionHandler : @escaping(NSDictionary?, Row? , Bool?) -> Void)
    {
        let query = user.filter(user_email == forEmail)
        var resultDict : NSDictionary!
        do{
            for user in try DBHelper.shared.connectDB().prepare(query) {
                resultDict = [
                    "username" : user[user_username],
                    "email" : user[user_email]
                ]
                completionHandler(resultDict, user, true)
            }
        }
        catch
        {
            completionHandler(resultDict, nil, false)
        }
    }
    
    //-- Update column into table
    func user_UpdateColumn()
    {
        do
        {
            try DBHelper.shared.connectDB().run(user.addColumn(Expression<String?>(user_mobile), defaultValue: ""))
            print("Column updated successfully in user table")
        } catch {
            print("Column update error in user table = \(error)")
        }
    }
    
    //-- Delete row from table
    func user_deleteDataForEmail(forEmail : String, completionHandler : @escaping( Bool?) -> Void)
    {
        let query = user.filter(user_username == forEmail)
        
        do {
            if try DBHelper.shared.connectDB().run(query.delete()) > 0 {
                print("row deleted")
                completionHandler(true)
            } else {
                print("row not found")
                completionHandler(false)
            }
        } catch {
            print("delete failed: \(error)")
            completionHandler(false)
        }
    }
}

