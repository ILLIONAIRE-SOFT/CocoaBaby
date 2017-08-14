//
//  TipsStore.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 14..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import Foundation

struct Tips {
    var name: String = ""
    var birthDate: Double = 0
    var pregnantDate: Double = 0
}

//class TipsStore {
//    
//    static let shared: TipsStore = TipsStore()
//    
//    var Tips: Tips! = nil
//        
//    
//    func fetchBaby(completion: @escaping (Tips?) -> ()) {
//        
//        FireBaseAPI.fetchTips { (result) in
//            switch result {
//            case let .success(tips):
//                self.Tips = tips
//                completion(tips)
//            case let .failure(_):
//                completion(nil)
//            default:
//                return
//            }
//        }
//    }
//    
//    
//}
