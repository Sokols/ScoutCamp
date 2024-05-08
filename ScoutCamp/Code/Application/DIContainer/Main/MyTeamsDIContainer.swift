//
//  MyTeamsDIContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/05/2024.
//

import SwiftUI

final class MyTeamsDIContainer {
    
    struct Dependencies {
        let firebaseDataService: FirebaseDataService
    }

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases

    private func makeFetchRegimentsUseCase() -> FetchRegimentsUseCase {
        DefaultFetchRegimentsUseCase(teamsRepository: makeTeamsRepository())
    }

    private func makeFetchRegimentTroopsUseCase() -> FetchRegimentTroopsUseCase {
        DefaultFetchRegimentTroopsUseCase(teamsRepository: makeTeamsRepository())
    }

    private func makeCreateTeamUseCase() -> CreateTeamUseCase {
        DefaultCreateTeamUseCase(teamsRepository: makeTeamsRepository())
    }

    private func makeUpdateTeamUseCase() -> UpdateTeamUseCase {
        DefaultUpdateTeamUseCase(teamsRepository: makeTeamsRepository())
    }

    private func makeDeleteTeamUseCase() -> DeleteTeamUseCase {
        DefaultDeleteTeamUseCase(teamsRepository: makeTeamsRepository())
    }

    private func makeFetchUserTeamsUseCase() -> FetchUserTeamsUseCase {
        DefaultFetchUserTeamsUseCase(teamsRepository: makeTeamsRepository())
    }

    // MARK: - Repositories

    private func makeTeamsRepository() -> TeamsRepository {
        DefaultTeamsRepository(with: dependencies.firebaseDataService)
    }

    // MARK: - Screens

    func makeMyTeamsScreen(
        actions: MyTeamsViewModelActions
    ) -> UIViewController {
        let viewModel: DefaultMyTeamsViewModel = makeMyTeamsViewModel(actions: actions)
        let view = MyTeamsScreen(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func makeCreateEditTeamScreen(
        _ teamToEdit: Team?,
        actions: CreateEditTeamViewModelActions
    ) -> UIViewController {
        let viewModel: DefaultCreateEditTeamViewModel = makeCreateEditTeamViewModel(teamToEdit, actions: actions)
        let view = CreateEditTeamScreen(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    // MARK: - View Models

    private func makeMyTeamsViewModel<T: MyTeamsViewModel>(
        actions: MyTeamsViewModelActions
    ) -> T {
        return DefaultMyTeamsViewModel(
            fetchUserTeamsUseCase: makeFetchUserTeamsUseCase(),
            actions: actions
        ) as! T
    }

    private func makeCreateEditTeamViewModel<T: CreateEditTeamViewModel>(
        _ teamToEdit: Team?,
        actions: CreateEditTeamViewModelActions
    ) -> T {
        let useCases = CreateEditTeamViewModelUseCases(
            fetchRegimentsUseCase: makeFetchRegimentsUseCase(),
            fetchRegimentTroopsUseCase: makeFetchRegimentTroopsUseCase(),
            createTeamUseCase: makeCreateTeamUseCase(),
            updateTeamUseCase: makeUpdateTeamUseCase(),
            deleteTeamUseCase: makeDeleteTeamUseCase()
        )
        return DefaultCreateEditTeamViewModel(
            teamToEdit: teamToEdit,
            useCases: useCases,
            actions: actions
        ) as! T
    }

    // MARK: - Flow Coordinators

    func makeMyTeamsFlowCoordinator(
        _ navigationController: UINavigationController
    ) -> MyTeamsFlowCoordinator {
        MyTeamsFlowCoordinator(
            navigationController: navigationController,
            diContainer: self
        )
    }
}
