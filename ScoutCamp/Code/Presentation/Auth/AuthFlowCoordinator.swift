//
//  AuthFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 15/02/2024.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makeLoginScreen(actions: LoginViewModelActions) -> UIViewController
    func makeRegisterScreen(actions: RegisterViewModelActions) -> UIViewController
}

protocol AuthFlowCoordinatorActions {
    func showMainFlow()
}

final class AuthFlowCoordinator {

    weak var navigationController: UINavigationController?
    private let dependencies: AuthFlowCoordinatorDependencies
    private let actions: AuthFlowCoordinatorActions

    init(
        navigationController: UINavigationController,
        dependencies: AuthFlowCoordinatorDependencies,
        actions: AuthFlowCoordinatorActions
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.actions = actions
    }

    func start() {
        let actions = LoginViewModelActions(
            showRegisterScreen: showRegisterScreen,
            showMainFlow: actions.showMainFlow
        )
        let vc = dependencies.makeLoginScreen(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }

    private func showRegisterScreen() {
        let actions = RegisterViewModelActions(
            goBackToLoginScreen: goBackToLoginScreen,
            showMainFlow: actions.showMainFlow
        )
        let vc = dependencies.makeRegisterScreen(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }

    private func goBackToLoginScreen() {
        navigationController?.popViewController(animated: false)
    }
}
