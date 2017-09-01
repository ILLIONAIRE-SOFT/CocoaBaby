//
//  FireBaseShareAPI.swift
//  CocoaBaby
//
//  Created by Sohn on 17/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import FirebaseAuth

struct PartnerInfo {
    var uid: String
    var deviceToken: String
}

enum SharePayloadName: String {
    case uid = "uid"
    case deviceToken = "deviceToken"
}

enum ShareResult {
    case success(Int)
    case failure()
    case noDeviceToken()
}

enum LinkResult {
    case success()
    case failure()
}

// MARK: - Share
extension FireBaseAPI {
    
    static func createShareSection(sixDigits: Int, completion: @escaping (ShareResult) -> ()) {
        guard
            let uid = Auth.auth().currentUser?.uid,
            let token = UserStore.shared.user?.deviceToken else {
                print(FireBaseAPIError.invalidUser)
                completion(ShareResult.noDeviceToken())
                return
        }
        
        let post = [
            SharePayloadName.uid.rawValue: uid,
            SharePayloadName.deviceToken.rawValue: token
            ] as [String : Any]
        
        // 먼저 observe single event로 해당 번호의 세션이 있는지 확인해줘야 한다. 없는 경우에 fail 줘서 다시 번호를 생성하도록..
        ref.child(FireBaseDirectoryName.share.rawValue).child("\(sixDigits)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                completion(ShareResult.failure())
            } else {
                ref.child(FireBaseDirectoryName.share.rawValue).child("\(sixDigits)").setValue(post, andPriority: nil) { (error, ref) in
                    if let _ = error {
                        completion(ShareResult.failure())
                    } else {
                        completion(ShareResult.success(sixDigits))
                    }
                }
            }
        })
    }
    
    static func removeShareSection(sixDigits: Int, completion: @escaping (ShareResult) -> ()) {
        //        guard let uid = Auth.auth().currentUser?.uid else {
        //            print(FireBaseAPIError.invalidUser)
        //            return
        //        }
        
        ref.child(FireBaseDirectoryName.share.rawValue).child("\(sixDigits)").removeValue()
        completion(ShareResult.success(0))
    }
    
    static func linkWithPartner(me: User, sixDigits: Int, completion: @escaping (UserResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        ref.child(FireBaseDirectoryName.share.rawValue).child("\(sixDigits)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                completion(UserResult.failure(nil))
                return
            }
            
            let dict = snapshot.value as! [String:Any]
            
            if let partnerInfo = partnerInfo(from: dict) {
                let user = User(gender: me.gender, partnerUID: partnerInfo.uid, deviceToken: me.deviceToken, partnerDeviceToken: partnerInfo.deviceToken)
                
                let myPost = [
                    UserPayloadName.partnerUID.rawValue: partnerInfo.uid,
                    UserPayloadName.partnerDeviceToken.rawValue: partnerInfo.deviceToken
                    ] as [String : Any]
                
                let partnerPost = [
                    UserPayloadName.partnerUID.rawValue: uid,
                    UserPayloadName.partnerDeviceToken.rawValue: me.deviceToken ?? ""
                    ] as [String: Any]
                
                ref.child(FireBaseDirectoryName.users.rawValue).child("\(uid)").updateChildValues(myPost, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        completion(UserResult.failure(error))
                    } else {
                        self.ref.child(FireBaseDirectoryName.users.rawValue).child("\(partnerInfo.uid)").updateChildValues(partnerPost, withCompletionBlock: { (error, ref) in
                            if let error = error {
                                completion(UserResult.failure(error))
                            } else {
                                completion(UserResult.success(user))
                            }
                        })
                    }
                })
            } else {
                completion(UserResult.failure(nil))
                return
            }
        })
    }
    
    static func unlinkWithPartner(completion: @escaping (LinkResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid,
            let partnerUID = UserStore.shared.user?.partnerUID else {
                print(FireBaseAPIError.invalidUser)
                return
        }
        
        let post = [
            UserPayloadName.partnerUID.rawValue: "",
            UserPayloadName.partnerDeviceToken.rawValue: ""
            ] as [String : Any]
        
        ref.child(FireBaseDirectoryName.users.rawValue).child(partnerUID).updateChildValues(post) { (error, ref) in
            self.ref.child(FireBaseDirectoryName.users.rawValue).child(uid).updateChildValues(post, withCompletionBlock: { (error, ref) in
                if let _ = error {
                    completion(LinkResult.failure())
                } else {
                    completion(LinkResult.success())
                }
            })
        }
        // 상대방의 uid로 접근해서 partner uid, partner device token 삭제하고 자신것도 삭제
        
    }
    
    static private func partnerInfo(from json: [String:Any]) -> PartnerInfo? {
        guard
            let partnerUID = json[SharePayloadName.uid.rawValue],
            let partnerDeviceToken = json[SharePayloadName.deviceToken.rawValue] else {
                return nil
        }
        
        let partnerInfo = PartnerInfo(uid: partnerUID as! String, deviceToken: partnerDeviceToken as! String)
        
        return partnerInfo
    }
    
}
