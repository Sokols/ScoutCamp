//
//  CategorizationHomeViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Combine
import Foundation

protocol CategorizationHomeViewModelInput {
    func onLoad() async
    func onAppear() async
    func onTeamDidChange() async
    func selectTeam(option: DropdownOption)
}

protocol CategorizationHomeViewModelOutput: ObservableObject {
    var userTeams: [Team] { get }
    var currentSheets: [TeamSheet] { get }
    var oldSheets: [TeamSheet] { get }
    var error: Error? { get set }
    var isLoading: Bool { get }
    var selectedTeam: DropdownOption? { get set }
    var currentPeriod: CategorizationPeriod? { get }
}

protocol CategorizationHomeViewModel: CategorizationHomeViewModelInput, CategorizationHomeViewModelOutput {}

struct CategorizationHomeViewModelUseCases {
    let fetchTeamSheetsUseCase: FetchTeamSheetsUseCase
    let fetchUserTeamsUseCase: FetchUserTeamsUseCase
}

final class DefaultCategorizationHomeViewModel: CategorizationHomeViewModel {

    private let fetchTeamSheetsUseCase: FetchTeamSheetsUseCase
    private let fetchUserTeamsUseCase: FetchUserTeamsUseCase

    private let currentPeriodId = RemoteConfigManager.shared.currentPeriodId

    // MARK: - OUTPUT

    @Published var userTeams: [Team] = []
    @Published var currentSheets: [TeamSheet] = []
    @Published var oldSheets: [TeamSheet] = []
    @Published var error: Error?
    @Published var isLoading = false
    @Published var selectedTeam: DropdownOption?

    var currentPeriod: CategorizationPeriod? {
        CategorizationPeriodsService.categoryPeriodFor(id: currentPeriodId)?.toDomain()
    }

    // MARK: - Init

    init(_ useCases: CategorizationHomeViewModelUseCases) {
        self.fetchTeamSheetsUseCase = useCases.fetchTeamSheetsUseCase
        self.fetchUserTeamsUseCase = useCases.fetchUserTeamsUseCase
    }

    // MARK: - Private

    private func getTeam() -> Team? {
        return userTeams.first(where: {$0.id == selectedTeam?.key})
    }

    private func loadUserTeams() async {
        let result = await fetchUserTeamsUseCase.execute()
        switch result {
        case .success(let userTeams):
            self.userTeams = userTeams
            if let team = self.userTeams.first {
                self.selectedTeam = team.toDropdownOption()
            }
        case .failure(let error):
            self.error = error
        }
    }

    private func loadTeamSheets() async {
        guard let team = getTeam(),
              let currentPeriodId = currentPeriodId else { return }
        let requestValue = FetchTeamSheetsUseCaseRequestValue(
            team: team,
            currentPeriodId: currentPeriodId
        )
        let result = await fetchTeamSheetsUseCase.execute(requestValue: requestValue)
        switch result {
        case .success(let response):
            self.currentSheets = response.currentSheets
            self.oldSheets = response.oldSheets
        case .failure(let error):
            self.error = error
        }
    }
}

extension DefaultCategorizationHomeViewModel {

    func selectTeam(option: DropdownOption) {
        selectedTeam = option
    }

    func onLoad() async {
        await loadUserTeams()
        await loadTeamSheets()
    }

    func onAppear() async {
        await loadTeamSheets()
    }

    func onTeamDidChange() async {
        await loadTeamSheets()
    }
}
