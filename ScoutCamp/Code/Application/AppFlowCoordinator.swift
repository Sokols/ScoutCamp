//
//  AppFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import UIKit

final class AppFlowCoordinator: AuthFlowCoordinatorActions {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    // MARK: - Init

    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    // MARK: - Public

    func start() {
        showAuthFlow()
        if isUserLoggedIn() {
            showMainFlow()
        }
    }

    func showAuthFlow() {
        let authDIContainer = appDIContainer.makeAuthDIContainer()
        let flow = authDIContainer.makeAuthFlowCoordinator(navigationController, actions: self)
        flow.start()
    }

    func showMainFlow() {
        let mainDIContainer = appDIContainer.makeMainDIContainer()
        let flow = mainDIContainer.makeMainFlowCoordinator(navigationController)
        flow.start()
    }

    private func isUserLoggedIn() -> Bool {
        let auth = appDIContainer.makeAuthRepository()
        return auth.loggedInUser != nil
    }
}
