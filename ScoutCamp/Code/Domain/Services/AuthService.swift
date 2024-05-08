//
//  AuthService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/06/2023.
//

import FirebaseAuth
import Foundation

@MainActor
class AuthService: ObservableObject {
    @Published var loggedInUser: User?

    private let auth = Auth.auth()

    init() {
        loggedInUser = auth.currentUser
    }

    // MARK: - Public methods

    func signIn(email: String, password: String) async -> Error? {
        do {
            let response = try await auth.signIn(withEmail: email, password: password)
            self.loggedInUser = response.user
            return nil
        } catch {
            return error
        }
    }

    func signUp(email: String, password: String) async -> Error? {
        do {
            let response = try await auth.createUser(withEmail: email, password: password)
            self.loggedInUser = response.user
            return nil
        } catch {
            return error
        }
    }

    func signOut() {
        try? auth.signOut()
        loggedInUser = nil
    }

    func deleteAccount() async -> Error? {
        do {
            try await loggedInUser?.delete()
            self.loggedInUser = nil
            return nil
        } catch {
            return error
        }
    }
}
