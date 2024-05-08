//
//  MyTeamsFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/05/2024.
//

import UIKit

final class MyTeamsFlowCoordinator {

    private let navigationController: UINavigationController
    private let diContainer: MyTeamsDIContainer

    init(
        navigationController: UINavigationController,
        diContainer: MyTeamsDIContainer
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    func start() -> UIViewController {
        let actions = MyTeamsViewModelActions(showMyTeamScreen: showMyTeamScreen)
        let vc = diContainer.makeMyTeamsScreen(actions: actions)
        return vc
    }

    private func showMyTeamScreen(_ team: Team?) {
        let actions = CreateEditTeamViewModelActions(navigateBack: navigateBack)
        let vc = diContainer.makeCreateEditTeamScreen(team, actions: actions)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    private func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
