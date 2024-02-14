//
//  AppFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import UIKit

final class AppFlowCoordinator {

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
        let categorizationDIContainer = appDIContainer.makeCategorizationDIContainer()
        let flow = categorizationDIContainer.makeCategorizationFlowCoordinator(navigationController)
        flow.start()
    }
}
