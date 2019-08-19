//
//  sqliteOps.swift
//  MedX
//
//  Created by user on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import SQLite3
class sqliteOps{
    static let instance = sqliteOps()
    var db : OpaquePointer?
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    private init() {
        openDatabase()
    }
    func closeSQLite(){
        if db != nil {
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
    }
    func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("test.sqlite")
        
        // open database
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("success opening database")
        }else{
            print("error opening database")
        }
        
    }
    func readFromSQLite(table: String) -> String{
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "select key from \(table)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        var key = ""
        if table == "pub" {
            while sqlite3_step(statement) == SQLITE_ROW {
                
                if let cString = sqlite3_column_text(statement, 0) {
                    key = String(cString: cString)
                } else {
                    print("key not found")
                }
            }
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        return key
    }
    func createTableInSQLite(tableName: String){
        if sqlite3_exec(db, "create table if not exists \(tableName) (key text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }else{
            print("create table success")
        }
    }
    func createTableInSQLiteFiles(tableName: String){
        if sqlite3_exec(db, "create table if not exists \(tableName) (location text, name text, acl text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }else{
            print("create table success")
        }
    }
    func prepareAndInsertToSQLite(table: String, field: String, value: String){
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into \(table) (\(field)) values (?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }else{
            print("success preparing insert")
        }
        if sqlite3_bind_text(statement, 1, value, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }else{
            print("success binding foo")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }else{
            print("success inserting foo")
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }else{
            print("success finalizing prepared statement")
        }
        statement = nil
    }
    func prepareAndInsertToSQLiteFiles(table: String, location: String, name: String, acl: String){
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into \(table) (location, name, acl) values (?,?,?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }else{
            print("success preparing insert")
        }
        if sqlite3_bind_text(statement, 1, location, -1, SQLITE_TRANSIENT) != SQLITE_OK || sqlite3_bind_text(statement, 2, name, -1, SQLITE_TRANSIENT) != SQLITE_OK || sqlite3_bind_text(statement, 3, acl, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }else{
            print("success binding foo")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }else{
            print("success inserting foo")
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }else{
            print("success finalizing prepared statement")
        }
        statement = nil
    }
    func readFromSQLiteFiles() -> [record]{
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "select * from userFiles", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        var key = ""
        var ans : [record] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            let cLoc = sqlite3_column_text(statement, 0)
            let cName = sqlite3_column_text(statement, 1)
            let cACL = sqlite3_column_text(statement, 2)
            let loc = String(cString: cLoc!)
            let name = String(cString: cName!)
            let acl = String(cString: cACL!)
            ans.append(record(location: loc, name: name, acl: acl))
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        return ans
    }
    func deleteFromTable(table: String, field: String, value: String){
        let deleteStatementString = "DELETE FROM \(table) WHERE \(field) = ?;"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(deleteStatement, 1, value, -1, SQLITE_TRANSIENT)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    func dropTable(table: String){
        let dropStatementString = "DROP TABLE IF EXISTS \(table);"
        
        var dropStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, dropStatementString, -1, &dropStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(dropStatement) == SQLITE_DONE {
                print("Successfully drop table.")
            } else {
                print("Could not drop table.")
            }
        } else {
            print("drop statement could not be prepared")
        }
        sqlite3_finalize(dropStatement)
    }
}
