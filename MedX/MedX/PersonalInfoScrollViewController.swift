//
//  PersonalInfoScrollView.swift
//  MedX
//
//  Created by Harry Wei on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class PersonalInfoScrollViewController:UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    private let types: [String: String] = [
        "json": "application/json",
        "pdf":  "application/pdf",
        "jpg":  "image/jpeg",
        "png":  "image/png",
        "txt":  "text/plain"
    ]
    
    @IBOutlet weak var PreferredHospitalList: UITextView!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var GenderField: UITextField!
    @IBOutlet weak var BloodTypeField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var AgeField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PreferredHospitalListField: UITextView!
    @IBOutlet weak var InsuranceIDField: UITextField!
    @IBOutlet weak var InsuranceProviderLogo: UITextField!
    @IBOutlet weak var StateField: UITextField!
    @IBOutlet weak var CityField: UITextField!
    @IBOutlet weak var AddressField: UITextField!
    @IBOutlet weak var EmergencyContactField: UITextField!
    @IBOutlet weak var PhoneField: UITextField!
    var api = LethAPI()
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    var genderType:[String] = []
    var bloodType:[String] = []
    
    let datePicker = UIDatePicker()
    
    static let fields = [
        "Name",
        "Gender",
        "Birthday",
        "Age",
        "Email",
        "Phone Number",
        "Primary Emergency Contact",
        "Address",
        "City",
        "State",
        "BloodType",
        "Insurance Provider",
        "Insurance ID",
        "Preferred Hospital List"
    ]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.5836969018, green: 0.7517433167, blue: 0.8807654977, alpha: 1)
        genderType = ["Male", "Female"]
        bloodType = ["A-positive", "A-negative", "B-positive", "B-negative", "AB-positive", "AB-negative", "O-positive", "O-negative"]
        
        showDatePicker()
        
        PreferredHospitalList!.layer.borderWidth = 1
        PreferredHospitalList!.layer.borderColor = UIColor.black.cgColor
    }
    
    
    @IBAction func NextAndSubmit(_ sender: Any) {
        let para: [String:String] = [
            "Name": NameField!.text ?? "Your Name?",
            "Gender": GenderField!.text ?? "Your Gender?",
            "Birthday": txtDatePicker!.text ?? "Your Birthday?",
            "Age": AgeField!.text ?? "Your Age?",
            "Email": EmailField!.text ?? "Your Email?",
            "Phone Number": PhoneField!.text ?? "Your Phone Number?",
            "Primary Emergency Contact": EmergencyContactField!.text ?? "Your Primary Emergency Contact?",
            "Address": AddressField!.text ?? "Your Address?",
            "City": CityField!.text ?? "Your City?",
            "State": StateField!.text ?? "Your State?",
            "BloodType": BloodTypeField!.text ?? "Your BloodType?",
            "Insurance Provider": InsuranceProviderLogo!.text ?? "Your Insurance Provider?",
            "Insurance ID": InsuranceIDField!.text ?? "Your Insurance ID?",
            "Preferred Hospital List": PreferredHospitalList!.text ?? "Your Preferred Hospital List?"
        ]
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(para)
            let jsonString = String(decoding: jsonData,as: UTF8.self)
            print(jsonString)
            let data: Data? = jsonString.data(using: .utf8)
            let publicKey = sqliteOps.instance.readFromSQLite(table: "pub")
            api.addFile(owner: publicKey, password: KeychainService.loadPassword(service: "lightstream", account: publicKey)!,name: "personal_info.jsonq", type: "application/json", data: data!, completion: {response in
                do {
                    guard let receivedPub = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
                        else {
                            print("Could not get JSON from responseData as dictionary")
                            return
                    }
                    print(receivedPub.description)
                    guard let loc = receivedPub["meta"] as? String else {
                        return
                    }
                    guard let acl = receivedPub["acl"] as? String else {
                        return
                    }
                    sqliteOps.instance.createTableInSQLiteFiles(tableName: "userFiles")
                    sqliteOps.instance.prepareAndInsertToSQLiteFiles(table: "userFiles", location: loc, name: "personal_info", acl: acl)
                    print(String(decoding: response.data!, as: UTF8.self))
                } catch  {
                    print("error parsing response from POST on /todos")
                    return
                }
            })
        } catch {
            print("error happened")
        }
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == GenderField{
            return genderType.count
        } else if currentTextField == BloodTypeField{
            return bloodType.count
        } else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == GenderField{
            return genderType[row]
        } else if currentTextField == BloodTypeField{
            return bloodType[row]
        } else{
            return " "
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == GenderField{
            GenderField.text = genderType[row]
            self.view.endEditing(true)
        } else if currentTextField == BloodTypeField{
           BloodTypeField.text = bloodType[row]
            self.view.endEditing(true)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        if currentTextField == GenderField {
            currentTextField.inputView = pickerView
        } else if currentTextField == BloodTypeField {
            currentTextField.inputView = pickerView
        }
    }

    
    @IBAction func backToFrontPageView(_ sender: Any) {
        print("Back button clicked")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
