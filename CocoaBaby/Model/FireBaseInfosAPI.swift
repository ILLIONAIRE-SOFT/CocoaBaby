//
//  FireBaseInfosAPI.swift
//  CocoaBaby
//
//  Created by Sohn on 18/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum InfosPayloadName: String {
    case babyInfos = "babyInfos"
    case babySpeech = "babySpeech"
    case week = "week"
}

enum InfosResult {
    case success([Int:Infos])
    case failure(Error)
}

// MARK: - Infos
extension FireBaseAPI {
    static func fetchInfos(completion: @escaping (InfosResult) -> ()) {
        
        ref.child(FireBaseDirectoryName.infos.rawValue).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard snapshot.exists() else {
                completion(InfosResult.failure(FireBaseAPIError.noInfos))
                return
            }
            
            var result = [Int:Infos]()
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let dict = snap.value as! [String:Any]
                if let infos = infos(from: dict) {
                    let week = infos.0
                    let infos = infos.1
                    result[week] = infos
                }
            }
            completion(InfosResult.success(result))
        })
    }
    
    static private func infos(from json: [String: Any]) -> (Int,Infos)? {
        
        var infos = Infos()
        
        guard
            let babyInfos = json[InfosPayloadName.babyInfos.rawValue],
            let babySpeech = json[InfosPayloadName.babySpeech.rawValue],
            let week = json[InfosPayloadName.week.rawValue] as? Int
            else {
                return nil
        }
        infos.babyInfos = babyInfos as! [String]
        infos.babySpeech = babySpeech as! [String]
        
        return (week,infos)
    }
}
