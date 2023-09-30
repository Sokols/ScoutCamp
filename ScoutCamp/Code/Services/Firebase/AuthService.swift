//
//  AuthService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/06/2023.
//

import FirebaseAuth
import Foundation

class AuthService: ObservableObject {
    @Published var loggedInUser: User?

    private let auth = Auth.auth()

    init() {
        loggedInUser = auth.currentUser
    }

    // MARK: - Public methods

    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let user = result?.user {
                self?.loggedInUser = user
            }
            completion(error)
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                user.sendEmailVerification() { error in
                    completion(error)
                }
            } else if let error = error {
                completion(error)
            }
        }
    }

    func signOut() {
        try? auth.signOut()
        loggedInUser = nil
    }

    func deleteAccount(completion: @escaping (Error?) -> Void) {
        loggedInUser?.delete { [weak self] error in
            guard let self = self else { return }
            completion(error)
            if error == nil {
                self.loggedInUser = nil
            }
        }
    }
}
