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
        let mainDIContainer = appDIContainer.makeMainDIContainer()
        let flow = mainDIContainer.makeMainFlowCoordinator(navigationController)
        flow.start()
    }

    private func isUserLoggedIn() -> Bool {
        let auth = appDIContainer.makeAuthRepository()
        return auth.loggedInUser != nil
    }
}
