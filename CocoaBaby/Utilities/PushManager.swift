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
    static var port: String = "8080"
    static var diaryNotiURL: String = "/notification/diary"
    static var commentNotiURL: String = "/notification/comment"
    
    static func notifyDiaryWrite(deviceToken: String) {
        
        guard let url = URL(string: "\(serverURL):\(port)\(diaryNotiURL)/\(deviceToken)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            }
        }
        task.resume()
    }
    
    static func notifyCommentWrite(deviceToken: String) {
        guard let url = URL(string: "\(serverURL):\(port)\(commentNotiURL)/\(deviceToken)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            }
        }
        task.resume()
    }
}
