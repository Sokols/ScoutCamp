//
//  SettingsViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 28/08/2023.
//

import Combine

class SettingsViewModel: ObservableObject {

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func logOut() {
        authService.signOut()
    }
}
