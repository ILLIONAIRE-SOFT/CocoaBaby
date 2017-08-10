//
//  FirbaseDataController.swift
//  CocoaBaby
//
//  Created by Sohn on 10/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
//import Firebase


class FirebaseDataController {
    
    static let shared = FirebaseDataController()
    
    var ref: DatabaseReference = Database.database().reference()
    
    func saveUser() {
        
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).setValue(["username" : "Sohn"])
        print("complete")
    }
    
    func loadUser() {
        let userID = Auth.auth().currentUser?.uid

        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            print(username)
        })
//        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//            // Get user value
//            let username = snapshot.value!["username"] as! String
//            let user = User.init(username: username)
//            
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
}
