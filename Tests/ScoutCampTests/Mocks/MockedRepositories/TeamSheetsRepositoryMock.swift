//
//  TeamSheetsRepositoryMock.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
@testable import ScoutCamp

final class TeamSheetsRepositoryMock: TeamSheetsRepository {

    enum TeamSheetsRepositoryMockError: Error {
        case failedFetching
        case failedSaving
    }

    private let isFailure: Bool
    private var teamSheets: [TeamSheet] = []

    init(isFailure: Bool) {
        self.isFailure = isFailure
    }

    func fetchTeamSheets(
        team: ScoutCamp.Team
    ) async -> Result<[ScoutCamp.TeamSheet], Error> {
        if isFailure {
            return .failure(TeamSheetsRepositoryMockError.failedFetching)
        }
        let result = teamSheets.filter { $0.team.id == team.id }
        return .success(result)
    }
    
    func saveTeamSheet(
        _ sheet: ScoutCamp.TeamSheet
    ) async -> Result<String, Error> {
        if isFailure {
            return .failure(TeamSheetsRepositoryMockError.failedSaving)
        }
        if let index = teamSheets.firstIndex(where: { $0.teamSheetId == sheet.teamSheetId }) {
            let newSheet = TeamSheet(
                teamSheetId: "team_sheet_id",
                sheet: sheet.sheet,
                team: sheet.team,
                category: sheet.category,
                points: sheet.points,
                isDraft: sheet.isDraft,
                createdAt: sheet.createdAt,
                updatedAt: sheet.updatedAt
            )
            teamSheets[index] = newSheet
            return .success(newSheet.teamSheetId!)
        } else {
            teamSheets.append(sheet)
            return .success(sheet.teamSheetId!)
        }
    }
}
