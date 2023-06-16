//
//  RegisterViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import Foundation

class RegisterViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var reTypePassword: String = ""

    func register() {
        RegisterAction(
            parameters: RegisterRequest(
                email: email,
                username: username,
                password: password
            )
        ).call { _ in
            // Register successful, navigate to the Login screen
        }
    }
}
