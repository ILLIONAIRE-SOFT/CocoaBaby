//
//  TipsStore.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 14..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import Foundation

struct Infos {
    var babyInfos: [String] = []
    var babySpeech: [String] = []
}

class InfosStore {
    
    static let shared: InfosStore = InfosStore()
    
    var Infos: [Int:Infos]! = nil
    
    func fetchInfos(completion : @escaping ([Int:Infos]?) -> ()) {
        
        FireBaseAPI.fetchInfos { (result) in
            switch result {
            case let .success(infos):
                self.Infos = infos
                completion(infos)
            case .failure(_):
                completion(nil)
                break
            }
        }
    }
}
