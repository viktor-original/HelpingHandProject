//
//  FirestoreServiceController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 04.09.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FIRFirestoreService {
    
    private init() {}
    static let shared = FIRFirestoreService()
    
    func configure() {
        FirebaseApp.configure()
}

    func create(email: String, firstName: String, lastName: String, phoneNumber:String) {
        let userID = Auth.auth().currentUser!.uid
        let email = email
        let firstName = firstName
        let lastName = lastName
        let phoneNumber = phoneNumber
        
        let parametrs: [String: Any] = [
            "id" : userID,
            "email" : email,
            "firstname": firstName,
            "lastName": lastName,
            "age" : "",
            "sex": "",
            "phoneNumber" : phoneNumber,
            "contacts": ["name": "", "phoneNumber": ""]
        ]
        let userReference = Firestore.firestore().collection("users")
        userReference.addDocument(data: parametrs)
        
    }
    
    func read() {
        
        let userID = Auth.auth().currentUser!.uid
        
        let userReference = Firestore.firestore().collection("users").whereField("id", isEqualTo: userID)
        
        userReference.addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                print(document.data())
            }
        }
    }
    
    func update() {
        
    }

}
