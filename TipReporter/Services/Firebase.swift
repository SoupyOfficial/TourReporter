//
//  Firebase.swift
//  TipReporter
//
//  Created by Soupy Campbell on 4/30/23.
//

import Foundation
import Firebase

class Firebase {
    static let shared = Firebase()
    let db = Firestore.firestore()
    let users = Firestore.firestore().collection("Users")
    var user = "Test"
    let clientID = FirebaseApp.app()?.options.clientID
    
    func updateUser(_ input: String, completion: @escaping (Bool) -> Void) {
        //print("Updating collection with input: \(input)")
        user = input
        completion(true)
    }
    
    func addFamily(data: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
        // Add a new document with data
        db.collection(Firebase.shared.user).addDocument(data: data) { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    func loadData(searchText: String, completion: @escaping ([[String: Any]]) -> Void) {
        var results = [[String: Any]]()
        let firstQuery = db.collection(Firebase.shared.user)
            .whereField("First Name", isGreaterThanOrEqualTo: searchText)
            .whereField("First Name", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            .order(by: "First Name")
            .order(by: "Last Name")
        let lastQuery = db.collection(Firebase.shared.user)
            .whereField("Last Name", isGreaterThanOrEqualTo: searchText)
            .whereField("Last Name", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            .order(by: "Last Name")
            .order(by: "First Name")
        firstQuery.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    results.append(document.data())
                }
                lastQuery.getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            results.append(document.data())
                        }
                        let uniqueData = self.removeDuplicates(from: results)
                        completion(uniqueData)
                    }
                }
            }
        }
    }
    
    private func removeDuplicates(from data: [[String: Any]]) -> [[String: Any]] {
        var uniqueData = [[String: Any]]()
        var duplicateIds = Set<String>()
        
        for dict in data {
            if let id = dict["documentID"] as? String {
                if !duplicateIds.contains(id) {
                    uniqueData.append(dict)
                    duplicateIds.insert(id)
                }
            }
        }
        
        return uniqueData
    }
}
