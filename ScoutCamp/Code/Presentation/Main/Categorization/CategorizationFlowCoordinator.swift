//
//  CategorizationFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import SwiftUI

final class CategorizationFlowCoordinator {

    private let navigationController: UINavigationController
    private let categorizationDIContainer: CategorizationDIContainer

    init(
        navigationController: UINavigationController,
        categorizationDIContainer: CategorizationDIContainer
    ) {
        self.navigationController = navigationController
        self.categorizationDIContainer = categorizationDIContainer
    }

    func start() -> UIViewController {
        let actions = CategorizationHomeViewModelActions(showSheetScreen: showSheetScreen)
        let vc = categorizationDIContainer.makeCategorizationHomeScreen(actions: actions)
        return vc
    }

    private func showSheetScreen(sheet: TeamSheet) {
        let actions = CategorizationSheetViewModelActions(navigateBack: navigateBack)
        let vc = categorizationDIContainer.makeCategorizationSheetScreen(actions: actions, sheet: sheet)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    private func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
