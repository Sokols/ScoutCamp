//
//  CategorizationDIContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import SwiftUI

final class CategorizationDIContainer {

    struct Dependencies {
        let firebaseDataService: FirebaseDataService
        let storageManager: StorageManager
    }

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases

    func makeFetchTeamSheetsUseCase() -> FetchTeamSheetsUseCase {
        DefaultFetchTeamSheetsUseCase(teamSheetsRepository: makeTeamSheetsRepository())
    }

    func makeFetchUserTeamsUseCase() -> FetchUserTeamsUseCase {
        DefaultFetchUserTeamsUseCase(teamsRepository: makeTeamsRepository())
    }

    func makeFetchSectionsUseCase() -> FetchAssignmentGroupSectionsUseCase {
        DefaultFetchAssignmentGroupSectionsUseCase(
            assignmentsRepository: makeAssignmentsRepository(),
            categorizationSheetsRepository: makeCategorizationSheetsRepository(),
            junctionsRepository: makeJunctionsRepository(),
            groupMinimumsRepository: makeGroupMinimumsRepository(), 
            groupsRepository: makeAssignmentGroupsRepository(),
            teamAssignmentsRepository: makeTeamAssignmentsRepository()
        )
    }

    func makeSaveTeamSheetUseCase() -> SaveTeamSheetUseCase {
        DefaultSaveTeamSheetUseCase(
            teamSheetsRepository: makeTeamSheetsRepository(),
            teamAssignmentsRepository: makeTeamAssignmentsRepository()
        )
    }

    func makeFetchPeriodsUseCase() -> FetchPeriodsUseCase {
        DefaultFetchPeriodsUseCase(periodsRepository: makeCategorizationPeriodsRepository())
    }

    func makeFetchCategoriesUseCase() -> FetchCategoriesUseCase {
        DefaultFetchCategoriesUseCase(categoriesRepository: makeCategoriesRepository())
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
        DefaultCategoriesRepository(with: dependencies.firebaseDataService, storageManager: dependencies.storageManager)
    }

    private func makeTeamSheetsRepository() -> TeamSheetsRepository {
        DefaultTeamSheetsRepository(
            with: dependencies.firebaseDataService,
            categorizationSheetsRepository: makeCategorizationSheetsRepository(),
            fetchCategoriesUseCase: makeFetchCategoriesUseCase()
        )
    }

    private func makeCategorizationSheetsRepository() -> CategorizationSheetsRepository {
        DefaultCategorizationSheetsRepository(
            with: dependencies.firebaseDataService,
            sheetTypesRepository: makeSheetTypesRepository(),
            categorizationPeriodsRepository: makeCategorizationPeriodsRepository()
        )
    }

    private func makeTeamAssignmentsRepository() -> TeamAssignmentsRepository {
        DefaultTeamAssignmentsRepository(with: dependencies.firebaseDataService)
    }

    private func makeAssignmentsRepository() -> AssignmentsRepository {
        DefaultAssignmentsRepository(with: dependencies.firebaseDataService)
    }

    private func makeJunctionsRepository() -> AssignmentGroupJunctionsRepository {
        DefaultAssignmentGroupJunctionsRepository(with: dependencies.firebaseDataService)
    }

    private func makeGroupMinimumsRepository() -> AssignmentGroupCategoryMinimumsRepository {
        DefaultAssignmentGroupCategoryMinimumsRepository(
            with: dependencies.firebaseDataService,
            fetchCategoriesUseCase: makeFetchCategoriesUseCase()
        )
    }

    private func makeAssignmentGroupsRepository() -> AssignmentGroupsRepository {
        DefaultAssignmentGroupsRepository(with: dependencies.firebaseDataService)
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
            fetchUserTeamsUseCase: makeFetchUserTeamsUseCase(),
            fetchPeriodsUseCase: makeFetchPeriodsUseCase()
        )
        return DefaultCategorizationHomeViewModel(useCases, actions: actions) as! T
    }

    // MARK: - Categorization Sheet Screen

    func makeCategorizationSheetScreen(
        actions: CategorizationSheetViewModelActions,
        sheet: TeamSheet
    ) -> UIViewController {
        let viewModel: DefaultCategorizationSheetViewModel = makeCategorizationSheetViewModel(actions: actions, sheet: sheet)
        let view = CategorizationSheetScreen(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    private func makeCategorizationSheetViewModel<T: CategorizationSheetViewModel>(
        actions: CategorizationSheetViewModelActions,
        sheet: TeamSheet
    ) -> T {
        return DefaultCategorizationSheetViewModel(
            fetchSectionsUseCase: makeFetchSectionsUseCase(),
            saveTeamSheetUseCase: makeSaveTeamSheetUseCase(),
            fetchCategoriesUseCase: makeFetchCategoriesUseCase(),
            actions: actions,
            sheet: sheet
        ) as! T
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
