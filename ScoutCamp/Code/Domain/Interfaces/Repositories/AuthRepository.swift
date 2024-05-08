//
//  AuthRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 19/02/2024.
//

import FirebaseAuth
import Foundation

protocol AuthRepository {
    func signIn(email: String, password: String) async -> Error?
    func signUp(email: String, password: String) async -> Error?
    func signOut() -> Error?
    func deleteAccount() async -> Error?

    var loggedInUser: User? { get }
}
