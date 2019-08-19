//
//  tableViewController.swift
//  MedX
//  
//  Created by Xiangmin Zhang on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class tableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var hospital: String?
    var records : [record] = []
    @IBOutlet weak var toLabel: UILabel!
    var api: LethAPI?
    @IBOutlet weak var recordLists: UITableView!
    var sharedFiles: String = "["
    var first = true
    override func viewDidLoad() {
        super.viewDidLoad()
        api = LethAPI()
        recordLists.delegate = self
        recordLists.dataSource = self
        recordLists.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        records = sqliteOps.instance.readFromSQLiteFiles()
        print(records)
        recordLists.reloadData()
        toLabel.text = hospital ?? "not found"
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(records[indexPath.row].name)"
        cell.detailTextLabel?.text = "description"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let grant = grantAction(at: indexPath)
        let revoke = revokeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [grant,revoke])
    }
    
    func grantAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title:"Grant", handler: {
            (action, view, completion) in
            print("here is the info:")
            let publicKey = sqliteOps.instance.readFromSQLite(table: "pub")
            print(publicKey)
            self.api!.grantAccess(acl: self.records[indexPath.row].acl, owner: publicKey, password: KeychainService.loadPassword(service: "lightstream", account: publicKey)!, to: self.toLabel.text!, permission: "read", completion: {response in
                print(String(decoding: response.data!, as: UTF8.self))
            })
            if self.first {
                self.sharedFiles += " {\"Name\":\"\(self.records[indexPath.row].name)\",\"Meta\":\"\(self.records[indexPath.row].location)\"}"
                self.first = false
            }else{
                self.sharedFiles += ",{\"Name\":\"\(self.records[indexPath.row].name)\",\"Meta\":\"\(self.records[indexPath.row].location)\"}"
            }
        })
        action.backgroundColor = UIColor.green
        return action
    }
    @IBAction func generate(_ sender: UIBarButtonItem) {
        let qrC = self.storyboard?.instantiateViewController(withIdentifier: "qrCode") as! qrCodeViewController
        qrC.dataString = sharedFiles+"]"
        self.present(qrC, animated: true, completion: nil)
    }
    func revokeAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title:"revoke", handler: {
            (action, view, completion) in
            sqliteOps.instance.dropTable(table: "pub")
            sqliteOps.instance.createTableInSQLite(tableName: "pub")
            sqliteOps.instance.prepareAndInsertToSQLite(table: "pub", field: "key", value: "0xc916cfe5c83dd4fc3c3b0bf2ec2d4e401782875e")
            
        })
        action.backgroundColor = UIColor.red
        return action
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        let label = UILabel(frame: CGRect(x: 10,y: 5,width: tableView.frame.width,height:20))
        label.text = "Date"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = #colorLiteral(red: 0.4459883571, green: 0.6351390481, blue: 0.7786456347, alpha: 1)
        label.sizeToFit()
        view.backgroundColor = #colorLiteral(red: 0.4459883571, green: 0.6351390481, blue: 0.7786456347, alpha: 1)
        view.addSubview(label)
        return view
        
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
