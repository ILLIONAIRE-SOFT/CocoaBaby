//
//  FireBaseTipsAPI.swift
//  CocoaBaby
//
//  Created by Sohn on 18/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum TipsPayloadName: String {
    case babyTitle = "babyTitle"
    case babyContent = "babyContent"
    case mamaTitle = "mamaTitle"
    case mamaContent = "mamaContent"
    case papaTitle = "papaTitle"
    case papaContent = "papaContent"
    case babySpeech = "babySpeech"
    case week = "week"
}

enum TipsResult {
    case success([Int:Tips])
    case failure(Error)
}

// MARK: - Tips
extension FireBaseAPI {
    static func fetchTips(completion: @escaping (TipsResult) -> ()) {
        
        ref.child(FireBaseDirectoryName.tips.rawValue).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard snapshot.exists() else {
                completion(TipsResult.failure(FireBaseAPIError.noTips))
                return
            }
            
            var result = [Int:Tips]()
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let dict = snap.value as! [String:Any]
                if let tips = tips(from: dict) {
                    let week = tips.0
                    let tips = tips.1
                    result[week] = tips
                }
            }
            completion(TipsResult.success(result))
        })
        
    }
    
    static private func tips(from json: [String: Any]) -> (Int,Tips)? {
        
        var tips = Tips()
        
        guard
            let babyTitle = json[TipsPayloadName.babyTitle.rawValue],
            let babyContent = json[TipsPayloadName.babyContent.rawValue],
            let mamaTitle = json[TipsPayloadName.mamaTitle.rawValue],
            let mamaContent = json[TipsPayloadName.mamaContent.rawValue],
            let papaTitle = json[TipsPayloadName.papaTitle.rawValue],
            let papaContent = json[TipsPayloadName.papaContent.rawValue],
            let week = json[TipsPayloadName.week.rawValue] as? Int
            else {
                return nil
        }
        
        tips.babyTitle = babyTitle as! String
        tips.babyContent = babyContent as! String
        tips.mamaTitle = mamaTitle as! String
        tips.mamaContent = mamaContent as! String
        tips.papaTitle = papaTitle as! String
        tips.papaContent = papaContent as! String
        
        return (week,tips)
        
    }
}
