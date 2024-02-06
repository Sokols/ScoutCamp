//
//  ProfileViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 28/08/2023.
//

import Combine

@MainActor
class ProfileViewModel: ObservableObject {

    @Service private var authService: AuthServiceProtocol

    func logOut() {
        authService.signOut()
    }
}
