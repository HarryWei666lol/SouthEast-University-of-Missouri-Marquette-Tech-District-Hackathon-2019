//
//  FamilyMedicalHistoryScrollView.swift
//  
//
//  Created by Harry Wei on 7/21/19.
//

import UIKit

class FamilyMedicalHistoryScrollView: UIViewController, UITextFieldDelegate {
        @IBOutlet weak var FamilyMedicalHistoryField: UITextView!
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        FamilyMedicalHistoryField!.layer.borderWidth = 1
        FamilyMedicalHistoryField!.layer.borderColor = UIColor.black.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func NextAndSubmit(_ sender: Any) {
        let para: [String:String] = [
            "Family Medical History": FamilyMedicalHistoryField!.text ?? "Any Family Medical History Field?",
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
