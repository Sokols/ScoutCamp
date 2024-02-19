//
//  CategorizationFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import SwiftUI

protocol CategorizationFlowCoordinatorDependencies {
    func makeCategorizationHomeScreen(actions: CategorizationHomeViewModelActions) -> UIViewController
    func makeCategorizationSheetScreen(sheet: TeamSheet) -> UIViewController
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
        let actions = CategorizationHomeViewModelActions(showSheetScreen: showSheetScreen)
        let vc = dependencies.makeCategorizationHomeScreen(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        categorizationHomeScreen = vc
    }

    private func showSheetScreen(sheet: TeamSheet) {
        let vc = dependencies.makeCategorizationSheetScreen(sheet: sheet)
        navigationController?.pushViewController(vc, animated: true)
    }
}
