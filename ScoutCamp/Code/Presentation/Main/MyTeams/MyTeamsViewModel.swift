//
//  MyTeamsViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Combine

struct MyTeamsViewModelActions {
    let showMyTeamScreen: (Team?) -> Void
}

protocol MyTeamsViewModelInput {
    func onLoad() async
    func onAppear() async
    func showMyTeamScreen(_ team: Team?)
}

protocol MyTeamsViewModelOutput: ObservableObject {
    var userTeams: [Team] { get }
    var error: Error? { get set }
    var isLoading: Bool { get }
}

protocol MyTeamsViewModel: MyTeamsViewModelInput, MyTeamsViewModelOutput {}

final class DefaultMyTeamsViewModel: MyTeamsViewModel {

    private let fetchUserTeamsUseCase: FetchUserTeamsUseCase
    private let actions: MyTeamsViewModelActions

    // MARK: - OUTPUT

    @Published var userTeams: [Team] = []
    @Published var error: Error?
    @Published var isLoading = false

    // MARK: - Init

    init(
        fetchUserTeamsUseCase: FetchUserTeamsUseCase,
        actions: MyTeamsViewModelActions
    ) {
        self.fetchUserTeamsUseCase = fetchUserTeamsUseCase
        self.actions = actions
    }

    // MARK: - Private

    @MainActor
    private func fetchMyTeams() async {
        isLoading = true
        let result = await fetchUserTeamsUseCase.execute()
        isLoading = false
        switch result {
        case .success(let success):
            self.userTeams = success
        case .failure(let error):
            self.error = error
        }
    }
}

extension DefaultMyTeamsViewModel {
    func onAppear() async {
        await fetchMyTeams()
    }

    func onLoad() async {
        await fetchMyTeams()
    }

    func showMyTeamScreen(_ team: Team?) {
        actions.showMyTeamScreen(team)
    }
}
