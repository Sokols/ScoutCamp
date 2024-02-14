//
//  CategorizationDIContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import UIKit
import SwiftUI

final class CategorizationDIContainer: CategorizationFlowCoordinatorDependencies {

    struct Dependencies {
        let firebaseDataService: FirebaseDataService
    }

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases

    func makeFetchTeamSheetsUseCase() -> FetchTeamSheetsUseCase {
        DefaultFetchTeamSheetsUseCase(
            teamSheetsRepository: makeTeamSheetsRepository()
        )
    }

    func makeFetchUserTeamsUseCase() -> FetchUserTeamsUseCase {
        DefaultFetchUserTeamsUseCase(teamsRepository: makeTeamsRepository())
    }

    // MARK: - Repositories

    private func makeTeamsRepository() -> TeamsRepository {
        DefaultTeamsRepository(with: dependencies.firebaseDataService)
    }

    private func makeTeamSheetsRepository() -> TeamSheetsRepository {
        DefaultTeamSheetsRepository(
            with: dependencies.firebaseDataService,
            categorizationSheetsRepository: makeCategorizationSheetsRepository()
        )
    }

    private func makeCategorizationSheetsRepository() -> CategorizationSheetsRepository {
        DefaultCategorizationSheetsRepository(with: dependencies.firebaseDataService)
    }

    // MARK: - Categorization Home Screen

    func makeCategorizationHomeScreen() -> UIViewController {
        let viewModel: DefaultCategorizationHomeViewModel = makeCategorizationHomeViewModel()
        let view = CategorizationHomeScreen(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func makeCategorizationHomeViewModel<T: CategorizationHomeViewModel>() -> T {
        let useCases = CategorizationHomeViewModelUseCases(
            fetchTeamSheetsUseCase: makeFetchTeamSheetsUseCase(),
            fetchUserTeamsUseCase: makeFetchUserTeamsUseCase()
        )
        return DefaultCategorizationHomeViewModel(useCases) as! T
    }

    // MARK: - Flow Coordinators

    func makeCategorizationFlowCoordinator(
        _ navigationController: UINavigationController
    ) -> CategorizationFlowCoordinator {
        CategorizationFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
