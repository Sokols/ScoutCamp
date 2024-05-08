//
//  ProfileViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 28/08/2023.
//

import Combine

struct ProfileViewModelActions {
    let navigateToEditProfile: () -> Void
    let navigateToSettings: () -> Void
    let navigateToAuthFlow: () -> Void
}

protocol ProfileViewModelInput {
    func signOut()
    func navigateToEditProfile()
    func navigateToSettings()
    func deleteAccount()
}

protocol ProfileViewModelOutput: ObservableObject  {
    var error: Error? { get set }
}

protocol ProfileViewModel: ProfileViewModelInput, ProfileViewModelOutput {}

final class DefaultProfileViewModel: ProfileViewModel {

    private let actions: ProfileViewModelActions
    private let signOutUseCase: SignOutUseCase

    // MARK: - OUTPUT

    @Published var error: Error?

    // MARK: - Init

    init(_ actions: ProfileViewModelActions, signOutUseCase: SignOutUseCase) {
        self.actions = actions
        self.signOutUseCase = signOutUseCase
    }
}

extension DefaultProfileViewModel {
    func signOut() {
        if let error = signOutUseCase.execute() {
            self.error = error
            return
        }
        actions.navigateToAuthFlow()
    }

    func deleteAccount() {
        #warning("TODO")
    }

    func navigateToEditProfile() {
        actions.navigateToEditProfile()
    }

    func navigateToSettings() {
        actions.navigateToSettings()
    }
}
