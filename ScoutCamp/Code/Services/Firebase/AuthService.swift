//
//  AuthService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/06/2023.
//

import FirebaseAuth
import Foundation

class AuthService: NSObject {
    func createUser(email: String, password: String, completion: @escaping CheckCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error == nil, error)
        }
    }

    func signIn(email: String, password: String, completion: @escaping CheckCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error == nil, error)
        }
    }
}
