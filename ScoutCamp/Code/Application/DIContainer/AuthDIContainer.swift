//
//  AuthDIContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 15/02/2024.
//

import UIKit
import SwiftUI

final class AuthDIContainer: AuthFlowCoordinatorDependencies {

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

    private func makeSignInUseCase() -> SignInUseCase {
        DefaultSignInUseCase(authRepository: makeAuthRepository())
    }

    // MARK: - Screens

    func makeLoginScreen(actions: LoginViewModelActions) -> UIViewController {
        let viewModel: DefaultLoginViewModel = makeLoginViewModel(actions: actions)
        let view = LoginScreen(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    private func makeLoginViewModel<T: LoginViewModel>(actions: LoginViewModelActions) -> T {
        DefaultLoginViewModel(
            actions,
            signInUseCase: makeSignInUseCase()
        ) as! T
    }

    func makeRegisterScreen(actions: RegisterViewModelActions) -> UIViewController {
        let view = RegisterScreen()
        return UIHostingController(rootView: view)
    }

    // MARK: - Flow Coordinators

    func makeAuthFlowCoordinator(
        _ navigationController: UINavigationController
    ) -> AuthFlowCoordinator {
        AuthFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
