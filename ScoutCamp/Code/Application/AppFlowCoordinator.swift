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

    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        if isUserLoggedIn() {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }

    func showAuthFlow() {
        let authDIContainer = appDIContainer.makeAuthDIContainer()
        let flow = authDIContainer.makeAuthFlowCoordinator(navigationController)
        flow.start(self)
    }

    func showMainFlow() {
        #warning("TODO")
        let categorizationDIContainer = appDIContainer.makeCategorizationDIContainer()
        let flow = categorizationDIContainer.makeCategorizationFlowCoordinator(navigationController)
        flow.start()
    }

    // MARK: - Private

    private func isUserLoggedIn() -> Bool {
        let auth = appDIContainer.makeAuthRepository()
        return auth.loggedInUser != nil
    }
}
