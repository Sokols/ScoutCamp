//
//  CategorizationFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import SwiftUI

protocol CategorizationFlowCoordinatorDependencies {
    func makeCategorizationHomeScreen() -> UIViewController
}

final class CategorizationFlowCoordinator {

    private weak var navigationController: UINavigationController?
    private let dependencies: CategorizationFlowCoordinatorDependencies

    private weak var categorizationHomeScreen: UIViewController?

    init(
        navigationController: UINavigationController,
        dependencies: CategorizationFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let vc = dependencies.makeCategorizationHomeScreen()
        navigationController?.pushViewController(vc, animated: false)
        categorizationHomeScreen = vc
    }
}
