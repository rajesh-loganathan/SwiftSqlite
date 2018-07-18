# SwiftSqlite


Here is the example project for ios sqlite in swift language. I just created a wrapper class to make simplify the implementation with easy understanding.


Declare sqlite database

    func intializeDatabase()
    {
        //-- Initialize
        DBHelper.shared.initDatabase()
    }
    
Insert data into table

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
    
    
Get data from table

    func getDataFromTable()
    {
        //-- Get value from table
        Table_user.shared.user_getForEmail(forEmail: "svmrajesh@gmail.com") { (dataDict, dataRow, isSuccess) in
            print("Result = \(dataDict ?? [:])")
        }
    }
    
Update column in table 

    func updateColumnInTable()
    {
        Table_user.shared.user_UpdateColumn()
    }

