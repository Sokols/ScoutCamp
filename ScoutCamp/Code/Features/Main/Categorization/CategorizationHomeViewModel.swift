//
//  CategorizationHomeViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Combine
import Foundation

@MainActor
final class CategorizationHomeViewModel: ObservableObject {

    @Service private var teamsService: TeamsServiceProtocol
    @Service private var teamSheetsService: TeamCategorizationSheetsServiceProtocol

    private let currentPeriodId = RemoteConfigManager.shared.currentPeriodId
    private var currentPeriodSheets: [CategorizationSheet] = []

    @Published var userTeams: [Team] = []
    @Published var currentSheets: [AppTeamSheet] = []
    @Published var oldSheets: [AppTeamSheet] = []
    @Published var error: Error?
    @Published var isLoading = false

    @Published var selectedTeam: DropdownOption?

    var currentPeriod: CategorizationPeriod? {
        CategorizationPeriodsService.categoryPeriodFor(id: currentPeriodId)
    }

    // MARK: - Public methods

    func selectTeam(option: DropdownOption) {
        selectedTeam = option
    }

    func getTeam() -> Team? {
        return userTeams.first(where: {$0.id == selectedTeam?.key})
    }

    func fetchInitData() async {
        isLoading = true
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.fetchMyTeams()
            }
            group.addTask {
                await self.fetchMySheets()
            }
        }
        isLoading = false
    }

    func fetchMySheets() async {
        guard let team = getTeam() else { return }
        updateCurrentSheets()
        let result = await teamSheetsService.getTeamCategorizationSheets(for: team.id)
        if let error = result.1 {
            self.error = error
        } else if let teamSheets = result.0 {
            oldSheets.removeAll()
            for teamSheet in teamSheets {
                guard let sheet = CategorizationSheetsService.categorizationSheetFor(id: teamSheet.categorizationSheetId) else { continue }
                if currentPeriodId == sheet.periodId {
                    let newSheet = AppTeamSheet.from(
                        teamSheet: teamSheet,
                        sheet: AppSheet.from(sheet: sheet),
                        team: team
                    )
                    if let index = currentSheets.firstIndex(where: {
                        $0.sheet.sheetId == sheet.id
                    }) {
                        currentSheets[index] = newSheet
                    }
                } else {
                    let allSheets = CategorizationSheetsService.categorizationSheets
                    if let oldSheet = allSheets.first(where: {
                        $0.id == teamSheet.categorizationSheetId
                    }) {
                        let newSheet = AppTeamSheet.from(
                            teamSheet: teamSheet,
                            sheet: AppSheet.from(sheet: oldSheet),
                            team: team
                        )
                        oldSheets.append(newSheet)
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func fetchMyTeams() async {
        let result = await teamsService.getUserTeams()
        if let error = result.1 {
            self.error = error
        } else if let userTeams = result.0 {
            self.userTeams = userTeams
            if let team = userTeams.first {
                self.selectedTeam = team.toDropdownOption()
            }
        }
    }

    private func updateCurrentSheets() {
        guard let team = getTeam() else { return }
        currentSheets = CategorizationSheetsService.getCurrentPeriodCategorizationSheets().map {
            let appSheet = AppSheet.from(sheet: $0)
            return AppTeamSheet.from(sheet: appSheet, team: team)
        }.sorted(by: { item1, item2 in
            let order1 = item1.sheet.sheetType.order
            let order2 = item2.sheet.sheetType.order
            return order1 < order2
        })
    }
}
