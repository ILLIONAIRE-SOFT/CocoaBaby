//
//  PushManager.swift
//  CocoaBaby
//
//  Created by Sohn on 17/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

struct PushManager {
    
    static var serverURL: String = "http://13.124.140.81"
    static var port: String = "3000"
    static var diaryNotiURL: String = "/notification/diary"
    
    static func pushToPartner(deviceToken: String) {
        
        guard let url = URL(string: "\(serverURL):\(port)") else {
            return
        }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

//        var params = ["deviceToken": "1234"]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            }
        }
        task.resume()
    }
}
