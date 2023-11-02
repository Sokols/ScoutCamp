//
//  CategorizationHomeViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Combine
import Foundation

@MainActor
class CategorizationHomeViewModel: ObservableObject {

    private let teamsService: TeamServiceProtocol
    private let teamSheetsService: TeamCategorizationSheetsServiceProtocol
    private let storageManager: StorageManagerProtocol

    private let currentPeriodId = RemoteConfigManager.shared.currentPeriodId

    @Published var userTeams: [Team] = []
    @Published var currentPeriodTeamSheets: [TeamCategorizationSheet] = []
    @Published var oldTeamSheets: [TeamCategorizationSheet] = []
    @Published var categoryUrls: [String: URL] = [:]
    @Published var error: Error?
    @Published var isLoading = false

    @Published var selectedTeam: DropdownOption?

    var currentPeriod: CategorizationPeriod? {
        CategorizationPeriodsService.categoryPeriodFor(id: currentPeriodId)
    }

    init(
        teamsService: TeamServiceProtocol,
        teamSheetsService: TeamCategorizationSheetsServiceProtocol,
        storageManager: StorageManagerProtocol
    ) {
        self.teamsService = teamsService
        self.teamSheetsService = teamSheetsService
        self.storageManager = storageManager
    }

    // MARK: - Public methods

    func getUrlForCategoryId(_ id: String) -> URL? {
        return categoryUrls[id]
    }

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
            currentPeriodTeamSheets.removeAll()
            oldTeamSheets.removeAll()
            for sheet in sheets {
                let categorizationSheet = CategorizationSheetsService.categorizationSheetFor(id: sheet.categorizationSheetId)
                if currentPeriodId == categorizationSheet?.periodId {
                    currentPeriodTeamSheets.append(sheet)
                } else {
                    oldTeamSheets.append(sheet)
                }
            }
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

    func fetchCategoryUrls() async {
        let categories = CategoriesService.categories
        isLoading = true
        do {
            var urls: [String: URL] = [:]
            for category in categories {
                let url = try await storageManager.getImageRef(path: category.imagePath)
                urls[category.id] = url
            }
            self.categoryUrls = urls
            isLoading = false
        } catch {
            isLoading = false
            self.error = error
        }
    }
}
