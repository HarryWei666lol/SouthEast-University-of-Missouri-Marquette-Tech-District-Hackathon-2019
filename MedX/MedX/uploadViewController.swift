//
//  uploadViewController.swift
//  MedX
//
//  Created by user on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class uploadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func upload(_ sender: UIButton) {
        uploadRequest()
    }
    func uploadRequest(){
        sqliteOps.instance.createTableInSQLiteFiles(tableName: "userFiles")
        sqliteOps.instance.prepareAndInsertToSQLiteFiles(table: "userFiles", location: "QmZpwH3i3w1HhkrcVqXUTK6A1rcFZftR6akJWgFYqSeXds", name: "HelloWorld.json", acl: "0x46B676873864a12eC3A57C396fF98B1F1B96f272")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
