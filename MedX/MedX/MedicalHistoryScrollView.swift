//
//  MedicalHistoryScrollView.swift
//  MedX
//
//  Created by Harry Wei on 7/21/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class MedicalHistoryScrollView:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ChronicHealthCondition: UITextView!
    
    @IBOutlet weak var LifeHabitsField: UITextView!
    @IBOutlet weak var AllergyField: UITextView!
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        ChronicHealthCondition!.layer.borderWidth = 1
        ChronicHealthCondition!.layer.borderColor = UIColor.black.cgColor
        
        LifeHabitsField!.layer.borderWidth = 1
        LifeHabitsField!.layer.borderColor = UIColor.black.cgColor
        
        AllergyField!.layer.borderWidth = 1
        AllergyField!.layer.borderColor = UIColor.black.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func NextAndSubmit(_ sender: Any) {
        let para: [String:String] = [
            "Chronic Health Condition": ChronicHealthCondition!.text ?? "Any Chronic Health Condition?",
            "Life Habits": LifeHabitsField!.text ?? "Any Life Habits?",
            "Allergy": AllergyField!.text ?? " Any Allergy?",
            
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
    
    
}
