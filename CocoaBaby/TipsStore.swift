//
//  TipsStore.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 14..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import Foundation

struct Tips {
    var babyTitle: String = ""
    var babyContent: String = ""
    var mamaTitle: String = ""
    var mamaContent: String = ""
    var papaTitle: String = ""
    var papaContent: String = ""
    var babySpeech: [String] = []
}

class TipsStore {
    
    static let shared: TipsStore = TipsStore()
    
    var Tips: [Int:Tips]! = nil
        
    func fetchTips(completion : @escaping ([Int:Tips]?) -> ()) {
        
        FireBaseAPI.fetchTips { (result) in
            switch result {
            case let .success(tips):
                self.Tips = tips
                completion(tips)
            case .failure(_):
                completion(nil)
                break
            }
        }
    }
    
    
}
