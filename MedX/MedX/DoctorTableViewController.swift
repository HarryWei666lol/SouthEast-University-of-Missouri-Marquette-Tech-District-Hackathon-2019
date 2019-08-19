//
//  DoctorTableViewController.swift
//  MedX
//
//  Created by Xiangmin Zhang on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class DoctorTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var dataString: String?
    var fileAddresses:[String] = []
    var fileNumbers: [Int] = []
    var fileNames: [String] = []
    var qrData: [Dictionary<String , Any>]?
    let theData:Records? = nil
    
    
    
    
    var hospital: String?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        convertQRToJSonArray()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        print("the content is: \(hospital)")
        // Do any additional setup after loading the view.
    }
    
    
    func convertQRToJSonArray(){
        //first step is to convert json string to json object
        var string = dataString!
        string = "{\"records\": \(string)}"
        let data = string.data(using: .utf8)!
        print("string: \(string)")
        print("data: \(data)")
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(Records.self, from: data)
            for index in 0..<object.records.count{
                //                fileNumbers.append(object.records[index].fileNumber)
                fileNames.append(object.records[index].Name)
                fileAddresses.append(object.records[index].Meta)
                // print(object.Name)
            }
        } catch let error as NSError {
            print("error: \(error)")
        }
        
        //parse json into structs
        
    }
    
    //    func decodeJSonArray(array: [Dictionary<String , Any>]){
    //        let decode = JSONDecoder.init()
    //        decode.decode(Records.self, from: <#T##Data#>)
    //    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(fileNames[indexPath.row])"
        cell.detailTextLabel?.text = "\(fileAddresses[indexPath.row])"
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
            completion(true)
        })
        action.backgroundColor = UIColor.green
        return action
    }
    
    func revokeAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title:"revoke", handler: {
            (action, view, completion) in
            completion(true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileName = fileNames[indexPath.row]
        let fileMeta = fileAddresses[indexPath.row]
        let file:[String:String] = [fileName:fileMeta]
        DownloadHelper.download(files: file) { _ in

            let refreshAlert = UIAlertController(title: "File Downloaded", message: "Do you want to see it now?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                 DownloadHelper.open(fileName: fileName, controller: self)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
           
        }
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
