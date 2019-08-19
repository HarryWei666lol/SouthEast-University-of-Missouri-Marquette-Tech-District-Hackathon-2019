//
//  QRScannerViewController.swift
//  MedX
//
//  Created by Siam Abd Al-Ilah on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class QRScannerViewController: UIViewController {
    
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
    

    @IBOutlet weak var scannerView: QRScannerView! {
        didSet{
            scannerView.delegate = self
        }
    }
    
    @IBAction func toggleScan(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        scannerView.isRunning ? print("started scan") : print("stopping scan")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
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

extension QRScannerViewController: QRScannerViewDelegate{
    func qrScanningDidFail() {
        print("Scan Failed")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "table") as! tableViewController
            VC1.hospital = str
        self.navigationController!.pushViewController(VC1, animated: true)
        
    }
    
    func qrScanningDidStop() {
        print("Scanning stopped")
    }
    
    
}
