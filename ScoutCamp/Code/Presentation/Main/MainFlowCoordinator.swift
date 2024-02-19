//
//  MainFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import SwiftUI

protocol MainFlowCoordinatorDependencies {
    func makeMainContainer() -> UITabBarController
    func makeHomeScreen() -> UIViewController
}

final class MainFlowCoordinator {

    private weak var navigationController: UINavigationController?
    private let dependencies: MainFlowCoordinatorDependencies

    init(
        navigationController: UINavigationController?,
        dependencies: MainFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let vc = dependencies.makeMainContainer()
        navigationController?.pushViewController(vc, animated: false)
    }
}
