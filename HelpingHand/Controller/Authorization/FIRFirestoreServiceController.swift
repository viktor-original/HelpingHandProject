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

class FirestoreService {
    
    private init() {}
    static let shared = FirestoreService()
    
    func configure() {
        FirebaseApp.configure()
}

    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func create(user: String, email: String, firstName: String, lastName: String, phoneNumber:String) {
        let userID = Auth.auth().currentUser!.uid
        
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
        
        reference(to: .users).addDocument(data: parametrs)
        
    }
    
    func read() {
        
        let userID = Auth.auth().currentUser!.uid
        
        reference(to: .users).whereField("id", isEqualTo: userID)
            .addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                print(document.data())
            }
        }
    }
    
    func update() {
        
    }

}
