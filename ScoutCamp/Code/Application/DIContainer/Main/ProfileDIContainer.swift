//
//  ProfileDIContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/04/2024.
//

import SwiftUI

final class ProfileDIContainer: ProfileFlowCoordinatorDependencies {

    struct Dependencies {
        let firebaseDataService: FirebaseDataService
    }

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Repositories

    private func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository()
    }

    // MARK: - Use Cases

    private func makeSignOutUseCase() -> SignOutUseCase {
        DefaultSignOutUseCase(authRepository: makeAuthRepository())
    }

    // MARK: - Screens

    func makeProfileScreen(actions: ProfileViewModelActions) -> UIViewController {
        let viewModel: DefaultProfileViewModel = makeProfileViewModel(actions: actions)
        let view = ProfileScreen(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    private func makeProfileViewModel<T: ProfileViewModel>(actions: ProfileViewModelActions) -> T {
        return DefaultProfileViewModel(actions, signOutUseCase: makeSignOutUseCase()) as! T
    }

    // MARK: - Flow Coordinators

    func makeProfileFlowCoordinator(
        _ navigationController: UINavigationController
    ) -> ProfileFlowCoordinator {
        ProfileFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
