//
//  DownloadHelper.swift
//  MedX
//
//  Created by Siam Abd Al-Ilah on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import Alamofire

class DownloadHelper{
    private static let types: [String: String] = [
        "json": "application/json",
        "pdf":  "application/pdf",
        "jpg":  "image/jpeg",
        "png":  "image/png",
        "txt":  "text/plain"
    ]

    static func download(files: [String: String], token: String, completion: @escaping (DataResponse<Any>)->()){
        let api = LethAPI()
        for (name, meta) in files {
            api.fetchFile(meta: meta, token: token, completion: {response in
                write(fileName: name, response: response, completion: completion)
            })
        }
    }
    static func download(files: [String: String], completion: @escaping (DataResponse<Any>)->()){
        download(files: files, token: UserDefaults.standard.string(forKey: "token")!, completion: completion)
    }
    
    static func fileExists(fileName: String) -> Bool {
        let pathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: pathUrl.path)
    }
    
    static func open(fileName: String, controller: UIViewController){
        let fileType = String(fileName.split(separator: ".").last ?? "")
        
        let mime = types[fileType] ?? "text/plain"
        let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = baseUrl.appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: fileUrl)
            
            let webview = UIWebView(frame:  controller.view.frame)
            
            controller.view.addSubview(webview)
            webview.load(data, mimeType: mime, textEncodingName: "", baseURL: baseUrl)
        } catch {
            print ("Error opening file")
        }
        
        
    }
    private static func write(fileName: String, response: DataResponse<Any>, completion: @escaping (DataResponse<Any>)->()){
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        do {
            print(filePath.absoluteString)
            try response.data?.write(to: filePath)
            print("\(fileName) written to disk")
        } catch {
            print("Error writing file: \(fileName). completion function not executed")
            return
        }
        completion(response)
    }
}


