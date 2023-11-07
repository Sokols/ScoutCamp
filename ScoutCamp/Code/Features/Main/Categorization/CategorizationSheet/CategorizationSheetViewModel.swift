//
//  CategorizationSheetViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import Combine

struct TeamAssignmentJoint: Hashable {
    var assignment: Assignment
    var teamAssignment: TeamCategorizationSheetAssignment?
}

@MainActor
class CategorizationSheetViewModel: ObservableObject {

    @Published var assignmentJoints: [TeamAssignmentJoint] = []

    @Published var error: Error?
    @Published var isLoading = false

    private let sheetJoint: CategorizationSheetJoint
    private let assignmentsService: AssignmentsServiceProtocol
    private let teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    private let isInitialFill: Bool

    init(
        sheetJoint: CategorizationSheetJoint,
        assignmentsService: AssignmentsServiceProtocol,
        teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    ) {
        self.sheetJoint = sheetJoint
        self.assignmentsService = assignmentsService
        self.teamAssignmentsService = teamAssignmentsService

        isInitialFill = sheetJoint.teamCategorizationSheet == nil
    }

    func fetchAssignments() async {
        let categorizationSheetId = sheetJoint.categorizationSheet.id
        isLoading = true
        let result = await assignmentsService.getAssignmentsFor(categorizationSheetId)
        let teamAssignments = await fetchTeamAssignments()
        isLoading = false
        if let error = result.1 {
            self.error = error
        } else if let assignments = result.0 {
            self.assignmentJoints = assignments.map { item in
                TeamAssignmentJoint(
                    assignment: item,
                    teamAssignment: teamAssignments.first(where: { $0.assignmentId == item.id })
                )
            }
        }
    }

    // MARK: - Helpers

    private func fetchTeamAssignments() async -> [TeamCategorizationSheetAssignment] {
        guard let teamCategorizationSheetId = sheetJoint.teamCategorizationSheet?.id else {
            return []
        }
        let result = await teamAssignmentsService.getTeamCategorizationSheetAssignmentsFor(teamCategorizationSheetId)
        if let error = result.1 {
            self.error = error
            return []
        } else {
            return result.0 ?? []
        }
    }
}
