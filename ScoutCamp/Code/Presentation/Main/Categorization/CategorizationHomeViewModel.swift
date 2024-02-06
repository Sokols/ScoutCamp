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
    private var currentPeriodSheets: [CategorizationSheetDTO] = []

    @Published var userTeams: [Team] = []
    @Published var currentSheets: [TeamSheet] = []
    @Published var oldSheets: [TeamSheet] = []
    @Published var error: Error?
    @Published var isLoading = false

    @Published var selectedTeam: DropdownOption?

    var currentPeriod: CategorizationPeriod? {
        CategorizationPeriodsService.categoryPeriodFor(id: currentPeriodId)?.toDomain()
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
                guard let sheetDTO = CategorizationSheetsService.categorizationSheetFor(id: teamSheet.categorizationSheetId) else { continue }
                if currentPeriodId == sheetDTO.periodId {
                    guard let sheet = sheetDTO.toDomain(),
                          let newSheet = TeamSheet.from(
                            teamSheet: teamSheet,
                            sheet: sheet,
                            team: team
                          ) else { return }
                    if let index = currentSheets.firstIndex(where: {
                        $0.sheet.sheetId == sheetDTO.id
                    }) {
                        currentSheets[index] = newSheet
                    }
                } else {
                    let allSheets = CategorizationSheetsService.categorizationSheets
                    if let oldSheet = allSheets.first(where: {
                        $0.id == teamSheet.categorizationSheetId
                    }) {
                        guard let sheet = oldSheet.toDomain(),
                              let newSheet = TeamSheet.from(
                                teamSheet: teamSheet,
                                sheet: sheet,
                                team: team
                              ) else { return }
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
            self.userTeams = userTeams.map { $0.toDomain() }
            if let team = self.userTeams.first {
                self.selectedTeam = team.toDropdownOption()
            }
        }
    }

    private func updateCurrentSheets() {
        guard let team = getTeam() else { return }
        currentSheets = CategorizationSheetsService.getCurrentPeriodCategorizationSheets().compactMap {
            guard let sheet = $0.toDomain() else { return nil }
            return TeamSheet.from(sheet: sheet, team: team)
        }.sorted(by: { item1, item2 in
            let order1 = item1.sheet.sheetType.order
            let order2 = item2.sheet.sheetType.order
            return order1 < order2
        })
    }
}
