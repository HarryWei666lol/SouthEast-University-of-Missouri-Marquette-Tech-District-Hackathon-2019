//
//  qrCodeViewController.swift
//  MedX
//
//  Created by user on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SQLite3
class qrCodeViewController: UIViewController {
    var db : OpaquePointer?
    var dataString = ""
    @IBOutlet weak var qrImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        QRtest()
        // Do any additional setup after loading the view.
    }
    
    func QRtest(){
        
        var QRstring = dataString
        print("The key is:\(QRstring)")
        let data = QRstring.data(using: String.Encoding.ascii)
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // 4
        qrFilter.setValue(data, forKey: "inputMessage")
        // 5
        guard let qrPic = qrFilter.outputImage else { return }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrPic.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
       qrImage.image = processedImage
    }
    
    
    
    func jsonToString(json: AnyObject) -> String?{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString ?? "defaultvalue"
        } catch let myJSONError {
            print(myJSONError)
            return nil
        }
        
    }
    @IBAction func done(_ sender: UIButton) {
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
