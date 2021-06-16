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
    
//    var readHelpRequestCompletion: ((Array<Dictionary<String, Any>>) -> ())?
    var readHelpRequestCompletion: (([Problem]) -> ())?
    var readUserCompletion: ((User) -> ())?
    
    func configure() {
        FirebaseApp.configure()
}

    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func createUser(email: String, firstName: String, lastName: String, phoneNumber:String) {
        let userID = Auth.auth().currentUser!.uid
        
        let parameters: [String: Any] = [
            "id" : userID,
            "email" : email,
            "firstname": firstName,
            "lastName": lastName,
            "age" : "",
            "sex": "",
            "phoneNumber" : phoneNumber,
            "contacts": ["name": "", "phoneNumber": ""]
        ]
        
        reference(to: .users).addDocument(data: parameters)
        
    }
    
    func createHelpRequest(
                            id: String,
                            type: String,
                            title: String,
                            image: String,
                            xCoordinate: String,
                            yCoordinate: String,
                            description: String) {
        let userID = Auth.auth().currentUser!.uid
        
        let parameters: [String: String] = [
            "creatorId" : userID,
            "description" : description,
            "helperId" : "",            
            "image": image,
            "status": "0",
            "title": title,
            "type": type,
            "xCoordinate": xCoordinate,
            "yCoordinate" : yCoordinate
        ]
        
        reference(to: .helpRequests).addDocument(data: parameters)
        
    }
    
    func getUser(){
        var user: User?
        let userID = Auth.auth().currentUser!.uid
        
        reference(to: .users).whereField("id", isEqualTo: userID)
            .addSnapshotListener { [weak self] (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                
                let data = document.data()
                var userFromResponse = [String:String]()
                
                for dict in data {
                    userFromResponse[dict.key] = "\(dict.value)"
                }
               
                let contactsFromResopnse = data["contacts"] as? Array<Dictionary<String, String>>
                
                user = User.initWithPrimitives(id: userFromResponse["id"],
                                               firstName: userFromResponse["firstName"],
                                               lastName: userFromResponse["lastName"],
                                               avatar: userFromResponse["avatar"],
                                               sex: userFromResponse["sex"],
                                               age: userFromResponse["age"],
                                               email: userFromResponse["email"] ?? "",
                                               phoneNumber: userFromResponse["phoneNumber"],
                                               contacts: contactsFromResopnse)
            }
            guard let sureUser = user else { return }
            self?.readUserCompletion?(sureUser)
        }
    }
    
//    func readSelfHelpRequests(){
//        var result = Array<Dictionary<String, Any>>()
//        let userID = Auth.auth().currentUser!.uid
//
//        reference(to: .helpRequests).whereField("creatorId", isEqualTo: userID)
//            .addSnapshotListener { [weak self] (snapshot, _) in
//
//                guard let snapshot = snapshot else { return }
//                for document in snapshot.documents {
//                    result.append(document.data())                    
//                }
//                self?.readHelpRequestCompletion?(result)
//        }
//    }
    func getSelfHelpRequests(){
        
        let userID = Auth.auth().currentUser!.uid
        
        var result = Array<Problem>()
        
        reference(to: .helpRequests).whereField("creatorId", isEqualTo: userID)
            .addSnapshotListener { [weak self] (snapshot, _) in
                
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents {
                    let problemDict = document.data()
                    let docId = document.documentID
                    var problemFromResponse = [String:String]()
                    
                    for dict in problemDict {
                        problemFromResponse[dict.key] = "\(dict.value)"
                    }
                    
                    result.append(Problem.unsafeInitWith(dictionary: problemFromResponse, andDocId: docId))
                }
                self?.readHelpRequestCompletion?(result)
        }
    }
    
    func getAllHelpRequests(){
        
        var result = Array<Problem>()
        
        reference(to: .helpRequests).addSnapshotListener { [weak self] (snapshot, _) in
                
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents {
                    let problemDict = document.data()
                    let docId = document.documentID
                    var problemFromResponse = [String:String]()
                    
                    for dict in problemDict {
                        problemFromResponse[dict.key] = "\(dict.value)"
                    }
                    
                    result.append(Problem.unsafeInitWith(dictionary: problemFromResponse, andDocId: docId))
                }
                self?.readHelpRequestCompletion?(result)
        }
    }
    
    func setHelperId(docId: String){
        let userID = Auth.auth().currentUser!.uid
        
        reference(to: .helpRequests).document(docId).updateData(["helperId" : userID, "status" : 1])
    }

}
