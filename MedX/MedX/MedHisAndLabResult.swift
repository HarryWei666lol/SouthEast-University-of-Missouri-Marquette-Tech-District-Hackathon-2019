//
//  MedHisAndLabResult.swift
//  MedX
//
//  Created by Harry Wei on 7/21/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

import UIKit

class MedHisAndLabResult:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Medicine1: UITextField!
    @IBOutlet weak var RadiationDosage: UITextField!
    @IBOutlet weak var RadiationExperienceField: UITextView!
    @IBOutlet weak var RadiationDateTime: UITextField!
    @IBOutlet weak var Frequency3: UITextField!
    @IBOutlet weak var Dosage3: UITextField!
    @IBOutlet weak var Medicine3: UITextField!
    @IBOutlet weak var Frequency2: UITextField!
    @IBOutlet weak var Dosage2: UITextField!
    @IBOutlet weak var Medicine2: UITextField!
    @IBOutlet weak var Frequency1: UITextField!
    @IBOutlet weak var Dosage1: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        showDatePicker()
        RadiationExperienceField!.layer.borderWidth = 1
        RadiationExperienceField!.layer.borderColor = UIColor.black.cgColor
    }
    
    
    @IBAction func NextAndSubmit(_ sender: Any) {
        let para: [String:String] = [
            "Medicine1": Medicine1!.text ?? "Your Med1?",
            "Dosage1": Dosage1!.text ?? "Your Dos1?",
            "Frequency1": Frequency1!.text ?? "Your Freq1?",
            "Medicine2": Medicine2!.text ?? "Your Med2?",
            "Dosage2": Dosage2!.text ?? "Your Dos2?",
            "Frequency2": Frequency2!.text ?? "Your  Freq2?",
            "Medicine3": Medicine3!.text ?? "Your Medicine3?",
            "Dosage3": Dosage3!.text ?? "Your Dosage3?",
            "Frequency3": Frequency3!.text ?? "Your Frequency3?",
            "RadiationDateTime": RadiationDateTime!.text ?? "Your RadiationDateTime?",
            "RadiationDosage": RadiationDosage!.text ?? "Your RadiationDosage?",
            "RadiationExperience": RadiationExperienceField!.text ?? "Your RadiationExperienc?",
        ]
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(para)
            let jsonString = String(decoding: jsonData,as: UTF8.self)
            print(jsonString)
            let data: Data? = jsonString.data(using: .utf8)
            print(data ?? "Missing data collected") // data ready for upload
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
        
        RadiationDateTime.inputAccessoryView = toolbar
        RadiationDateTime.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        RadiationDateTime.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func backToFrontPageView(_ sender: Any) {
        print("Back button clicked")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

