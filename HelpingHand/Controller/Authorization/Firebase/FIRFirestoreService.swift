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
import FirebaseAuth

class FIRFirestoreService {
    
    private init() {}
    static let shared = FIRFirestoreService()
    
    var completion: ((Array<Dictionary<String, Any>>) -> ())?
    
    func configure() {
        FirebaseApp.configure()
}

    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func createUser(email: String, firstName: String, lastName: String, phoneNumber:String) {
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
    
    func createHelpRequest(status: String, problemID: String,
    x: String, y: String) {
        let userID = Auth.auth().currentUser!.uid
        
        let parametrs: [String: Any] = [
            "userID" : userID,
            "status": status,
            "problemID": problemID,
            "X": x,
            "Y" : y,
            
        ]
        
        reference(to: .helpRequests).addDocument(data: parametrs)
        
    }
    
    func readUser() {
        
        let userID = Auth.auth().currentUser!.uid
        
        reference(to: .users).whereField("id", isEqualTo: userID)
            .addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                print(document.data())
            }
        }
    }
    
    func readHelpRequest(){
        var result = Array<Dictionary<String, Any>>()
        let userID = Auth.auth().currentUser!.uid
        //let collectionID = reference(to: .helpRequests).collectionID
        //let currentCollection = reference(to: .helpRequests).whereField("userID", isEqualTo: userID)
        
        reference(to: .helpRequests).whereField("userID", isEqualTo: userID)
            .addSnapshotListener { [weak self] (snapshot, _) in
                
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents {
                    result.append(document.data())
                    print(document.data())
                }
                self?.completion?(result)
        }
    }
    
//    func updateUser() {
//        reference(to: .users)
//    }
    
//    func updateHelpRequest() {
//        let userID = Auth.auth().currentUser!.uid
//        reference(to: .helpRequests).document("userID").setData([
//            "userID" : userID,
//            "status": 2,
//            "X": 333,
//            "Y" : 555,
//            ])
//    }

}
