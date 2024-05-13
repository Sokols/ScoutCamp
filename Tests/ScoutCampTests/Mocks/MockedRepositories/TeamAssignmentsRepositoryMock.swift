//
//  TeamAssignmentsRepositoryMock.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
@testable import ScoutCamp

final class TeamAssignmentsRepositoryMock: TeamAssignmentsRepository {

    enum TeamAssignmentsRepositoryMockError: Error {
        case failedFetching
        case failedSaving
    }

    private let isFailure: Bool
    private var teamAssignments: [TeamCategorizationSheetAssignment] = []

    init(isFailure: Bool, teamAssignments: [TeamCategorizationSheetAssignment]) {
        self.isFailure = isFailure
        self.teamAssignments = teamAssignments
    }

    func saveTeamAssignments(
        _ assignments: [AppAssignment],
        teamSheetId: String
    ) async -> Error? {
        if isFailure {
            return TeamAssignmentsRepositoryMockError.failedSaving
        }
        let mappedAssignments = assignments.map {
            TeamCategorizationSheetAssignment(
                id: $0.id,
                assignmentId: $0.assignmentId, 
                teamCategorizationSheetId: teamSheetId
            )
        }
        for mappedAssignment in mappedAssignments {
            if let index = teamAssignments.firstIndex(where: { mappedAssignment.id == $0.id }) {
                teamAssignments[index] = mappedAssignment
            } else {
                teamAssignments.append(mappedAssignment)
            }
        }
        return nil
    }

    func fetchTeamAssignments(
        teamSheetId: String
    ) async -> Result<[TeamCategorizationSheetAssignment], Error> {
        if isFailure {
            return .failure(TeamAssignmentsRepositoryMockError.failedFetching)
        }
        let result = teamAssignments.filter { $0.teamCategorizationSheetId == teamSheetId }
        return .success(result)
    }
}

