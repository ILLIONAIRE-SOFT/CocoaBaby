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
}
