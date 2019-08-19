//
//  DoctorScanViewController.swift
//  MedX
//
//  Created by Xiangmin Zhang on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class DoctorScanViewController: UIViewController {

    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6508722175)
        view2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6508722175)
        view3.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6508722175)
        view4.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6508722175)
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var scannerView: QRScannerView!{
        didSet{
            scannerView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    
}

extension DoctorScanViewController: QRScannerViewDelegate{
    func qrScanningDidFail() {
        print("Scan Failed")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        let VC2 = self.storyboard!.instantiateViewController(withIdentifier: "doctortable") as! DoctorTableViewController
        VC2.dataString = str
        self.navigationController!.pushViewController(VC2, animated: true)
        
    }
    
    func qrScanningDidStop() {
        print("Scanning stopped")
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

