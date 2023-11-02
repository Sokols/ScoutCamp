//
//  CategorizationHomeViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Combine
import Foundation

struct CategorizationSheetJoint: Hashable {
    var categorizationSheet: CategorizationSheet
    var teamCategorizationSheet: TeamCategorizationSheet?
}

@MainActor
class CategorizationHomeViewModel: ObservableObject {

    private let teamsService: TeamServiceProtocol
    private let teamSheetsService: TeamCategorizationSheetsServiceProtocol
    private let storageManager: StorageManagerProtocol

    private let currentPeriodId = RemoteConfigManager.shared.currentPeriodId
    private var currentPeriodSheets: [CategorizationSheet] = []

    @Published var userTeams: [Team] = []
    @Published var currentPeriodSheetJoints: [CategorizationSheetJoint] = []
    @Published var oldTeamSheetJoints: [CategorizationSheetJoint] = []
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
        updateCurrentPeriodSheetJoints()
        isLoading = true
        let result = await teamSheetsService.getTeamCategorizationSheets(for: teamId)
        isLoading = false
        if let error = result.1 {
            self.error = error
        } else if let teamSheets = result.0 {
            oldTeamSheetJoints.removeAll()
            for teamSheet in teamSheets {
                let sheet = CategorizationSheetsService.categorizationSheetFor(id: teamSheet.categorizationSheetId)
                if currentPeriodId == sheet?.periodId {
                    let newJoint = CategorizationSheetJoint(
                        categorizationSheet: sheet!,
                        teamCategorizationSheet: teamSheet
                    )
                    if let index = currentPeriodSheetJoints.firstIndex(where: {
                        $0.categorizationSheet.id == sheet?.id
                    }) {
                        currentPeriodSheetJoints[index] = newJoint
                    }
                } else {
                    let allSheets = CategorizationSheetsService.categorizationSheets
                    if let oldCategorizationSheet = allSheets.first(where: {
                        $0.id == teamSheet.categorizationSheetId
                    }) {
                        let newJoint = CategorizationSheetJoint(
                            categorizationSheet: oldCategorizationSheet,
                            teamCategorizationSheet: teamSheet
                        )
                        oldTeamSheetJoints.append(newJoint)
                    }
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

    // MARK: - Helpers

    private func updateCurrentPeriodSheetJoints() {
        currentPeriodSheetJoints = CategorizationSheetsService.getCurrentPeriodCategorizationSheets().map {
            CategorizationSheetJoint(categorizationSheet: $0, teamCategorizationSheet: nil)
        }.sorted(by: { item1, item2 in
            let sheetType1 = SheetTypesService.sheetTypeFor(id: item1.categorizationSheet.sheetTypeId)
            let sheetType2 = SheetTypesService.sheetTypeFor(id: item2.categorizationSheet.sheetTypeId)
            return sheetType1?.order ?? 0 < sheetType2?.order ?? 0
        })
    }
}
