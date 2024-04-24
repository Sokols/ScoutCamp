//
//  CategorizationDIContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import UIKit
import SwiftUI

final class CategorizationDIContainer {

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

    private func makeSheetTypesRepository() -> SheetTypesRepository {
        DefaultSheetTypesRepository(with: dependencies.firebaseDataService)
    }

    private func makeCategorizationPeriodsRepository() -> CategorizationPeriodsRepository {
        DefaultCategorizationPeriodsRepository(with: dependencies.firebaseDataService)
    }

    private func makeCategoriesRepository() -> CategoriesRepository {
        DefaultCategoriesRepository(with: dependencies.firebaseDataService)
    }

    private func makeTeamSheetsRepository() -> TeamSheetsRepository {
        DefaultTeamSheetsRepository(
            with: dependencies.firebaseDataService,
            categorizationSheetsRepository: makeCategorizationSheetsRepository(),
            categoriesRepository: makeCategoriesRepository()
        )
    }

    private func makeCategorizationSheetsRepository() -> CategorizationSheetsRepository {
        DefaultCategorizationSheetsRepository(
            with: dependencies.firebaseDataService,
            sheetTypesRepository: makeSheetTypesRepository(),
            categorizationPeriodsRepository: makeCategorizationPeriodsRepository()
        )
    }

    // MARK: - Categorization Home Screen

    func makeCategorizationHomeScreen(
        actions: CategorizationHomeViewModelActions
    ) -> UIViewController {
        let viewModel: DefaultCategorizationHomeViewModel = makeCategorizationHomeViewModel(actions: actions)
        let view = CategorizationHomeScreen(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    private func makeCategorizationHomeViewModel<T: CategorizationHomeViewModel>(
        actions: CategorizationHomeViewModelActions
    ) -> T {
        let useCases = CategorizationHomeViewModelUseCases(
            fetchTeamSheetsUseCase: makeFetchTeamSheetsUseCase(),
            fetchUserTeamsUseCase: makeFetchUserTeamsUseCase()
        )
        return DefaultCategorizationHomeViewModel(useCases, actions: actions) as! T
    }

    // MARK: - Categorization Sheet Screen

    func makeCategorizationSheetScreen(sheet: TeamSheet) -> UIViewController {
        let view = CategorizationSheetScreen(sheet: sheet)
        return UIHostingController(rootView: view)
    }

    // MARK: - Flow Coordinators

    func makeCategorizationFlowCoordinator(
        _ navigationController: UINavigationController
    ) -> CategorizationFlowCoordinator {
        CategorizationFlowCoordinator(
            navigationController: navigationController,
            categorizationDIContainer: self
        )
    }
}
