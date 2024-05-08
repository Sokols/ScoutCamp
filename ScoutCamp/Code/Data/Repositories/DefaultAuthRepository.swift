//
//  DefaultAuthRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 19/02/2024.
//

import Foundation
import FirebaseAuth

final class DefaultAuthRepository: AuthRepository {
    var loggedInUser: User?

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

    func signOut() -> Error? {
        do {
            try auth.signOut()
            self.loggedInUser = nil
            return nil
        } catch {
            return error
        }
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
