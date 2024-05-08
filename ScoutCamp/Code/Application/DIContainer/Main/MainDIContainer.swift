//
//  MainDIContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 19/02/2024.
//

import Foundation
import SwiftUI

final class MainDIContainer: MainFlowCoordinatorDependencies {

    struct Dependencies {
        let firebaseDataService: FirebaseDataService
        let storageManager: StorageManager
    }

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Screens

    func makeHomeScreen() -> UIViewController {
        let view = HomeScreen()
        return UIHostingController(rootView: view)
    }

    func makeCategorizationScreen(_ navigationController: UINavigationController) -> UIViewController {
        let container = makeCategorizationDIContainer()
        let flow = container.makeCategorizationFlowCoordinator(navigationController)
        return flow.start()
    }

    func makeMyTeamsScreen(_ navigationController: UINavigationController) -> UIViewController {
        let container = makeMyTeamsDIContainer()
        let flow = container.makeMyTeamsFlowCoordinator(navigationController)
        return flow.start()
    }

    func makeProfileScreen(_ navigationController: UINavigationController) -> UIViewController {
        let container = makeProfileDIContainer()
        let flow = container.makeProfileFlowCoordinator(navigationController)
        return flow.start()
    }

    // MARK: - Flow Coordinators

    func makeMainFlowCoordinator(
        _ navigationController: UINavigationController
    ) -> MainFlowCoordinator {
        MainFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }

    // MARK: - DIContainers of screens

    private func makeCategorizationDIContainer() -> CategorizationDIContainer {
        let dependencies = CategorizationDIContainer.Dependencies(
            firebaseDataService: dependencies.firebaseDataService,
            storageManager: dependencies.storageManager
        )
        return CategorizationDIContainer(dependencies: dependencies)
    }

    private func makeMyTeamsDIContainer() -> MyTeamsDIContainer {
        let dependencies = MyTeamsDIContainer.Dependencies(
            firebaseDataService: dependencies.firebaseDataService
        )
        return MyTeamsDIContainer(dependencies: dependencies)
    }

    private func makeProfileDIContainer() -> ProfileDIContainer {
        let dependencies = ProfileDIContainer.Dependencies(
            firebaseDataService: dependencies.firebaseDataService
        )
        return ProfileDIContainer(dependencies: dependencies)
    }
}
