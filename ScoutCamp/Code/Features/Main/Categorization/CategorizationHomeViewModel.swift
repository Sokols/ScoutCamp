//
//  CategorizationHomeViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Combine

@MainActor
class CategorizationHomeViewModel: ObservableObject {

    private let teamsService: TeamServiceProtocol
    private let teamSheetsService: TeamCategorizationSheetsServiceProtocol

    @Published var userTeams: [Team] = []
    @Published var teamSheets: [TeamCategorizationSheet] = []
    @Published var error: Error?
    @Published var isLoading = false

    @Published var selectedTeam: DropdownOption?

    init(
        teamsService: TeamServiceProtocol,
        teamSheetsService: TeamCategorizationSheetsServiceProtocol
    ) {
        self.teamsService = teamsService
        self.teamSheetsService = teamSheetsService
    }

    // MARK: - Public methods

    func selectTeam(option: DropdownOption) {
        selectedTeam = option
    }

    func getTeam() -> Team? {
        return userTeams.first(where: {$0.id == selectedTeam?.key})
    }

    func fetchMySheets() async {
        guard let teamId = getTeam()?.id else { return }
        isLoading = true
        let result = await teamSheetsService.getTeamCategorizationSheets(for: teamId)
        isLoading = false
        if let error = result.1 {
            self.error = error
        } else if let sheets = result.0 {
            self.teamSheets = sheets
        }
    }

    func fetchMyTeams() async {
        isLoading = true
        let result = await teamsService.getUserTeams()
        isLoading = false
        if let error = result.1 {
            self.error = error
        } else if let userTeams = result.0 {
            self.userTeams = userTeams
            if let team = userTeams.first {
                self.selectedTeam = team.toDropdownOption()
            }
        }
    }
}
