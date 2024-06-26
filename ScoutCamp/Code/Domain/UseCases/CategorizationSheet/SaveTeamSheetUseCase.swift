//
//  SaveTeamSheetUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/04/2024.
//

import Foundation

protocol SaveTeamSheetUseCase {
    func execute(requestValue: SaveTeamSheetUseCaseRequestValue) async -> Error?
}

final class DefaultSaveTeamSheetUseCase: SaveTeamSheetUseCase {

    private let teamSheetsRepository: TeamSheetsRepository
    private let teamAssignmentsRepository: TeamAssignmentsRepository

    init(
        teamSheetsRepository: TeamSheetsRepository,
        teamAssignmentsRepository: TeamAssignmentsRepository
    ) {
        self.teamSheetsRepository = teamSheetsRepository
        self.teamAssignmentsRepository = teamAssignmentsRepository
    }

    func execute(requestValue: SaveTeamSheetUseCaseRequestValue) async -> Error? {
        do {
            let result = await teamSheetsRepository.saveTeamSheet(
                requestValue.teamSheet
            )
            let teamSheetId = try result.get()
            let assignmentsResult = await teamAssignmentsRepository.saveTeamAssignments(
                requestValue.assignments,
                teamSheetId: teamSheetId
            )

            if let error = assignmentsResult {
                return error
            }

            return nil
        } catch {
            return error
        }
    }
}

struct SaveTeamSheetUseCaseRequestValue {
    let teamSheet: TeamSheet
    let assignments: [AppAssignment]
    let isDraft: Bool
}
