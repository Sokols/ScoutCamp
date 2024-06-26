//
//  ProfileFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/04/2024.
//

import UIKit

protocol ProfileFlowCoordinatorDependencies {
    func makeProfileScreen(actions: ProfileViewModelActions) -> UIViewController
}

final class ProfileFlowCoordinator {

    private weak var navigationController: UINavigationController?
    private let dependencies: ProfileFlowCoordinatorDependencies

    init(
        navigationController: UINavigationController,
        dependencies: ProfileFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() -> UIViewController {
        let actions = ProfileViewModelActions(
            navigateToEditProfile: navigateToEditProfile,
            navigateToSettings: navigateToSettings,
            navigateToAuthFlow: navigateToAuthFlow
        )
        let vc = dependencies.makeProfileScreen(actions: actions)
        return vc
    }

    private func navigateToEditProfile() {
        #warning("TODO")
    }

    private func navigateToSettings() {
        #warning("TODO")
    }

    private func navigateToAuthFlow() {
        guard let loginVC = navigationController?.viewControllers
            .first(where: {$0.className.contains("LoginViewController")}) else { return }
        navigationController?.popToViewController(loginVC, animated: true)
    }
}
