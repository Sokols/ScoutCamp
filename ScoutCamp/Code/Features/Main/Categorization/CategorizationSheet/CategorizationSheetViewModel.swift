//
//  CategorizationSheetViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import Combine

@MainActor
class CategorizationSheetViewModel: ObservableObject {

    @Service private var assignmentsService: AssignmentsServiceProtocol
    @Service private var teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    @Service private var groupAssignmentJunctionsService: AssignmentGroupAssignmentJunctionsServiceProtocol

    @Published var appAssignments: [AppAssignment] = []
    @Published var sheet: AppTeamSheet

    @Published var error: Error?
    @Published var isLoading = false

    private let isInitialFill: Bool

    var sheetType: String { sheet.sheet.sheetType.name }

    var points: Double {
        var points: Double = 0
        appAssignments.forEach { assignment in
            switch assignment.assignmentType {
            case .numeric:
                points += Double((assignment.intValue / (assignment.maxScoringValue ?? 1))).rounded() * Double(assignment.maxPoints)
            case .boolean:
                if assignment.isCompleted {
                    points += Double(assignment.maxPoints)
                }
            }
        }
        return points
    }

    init(sheet: AppTeamSheet) {
        self.sheet = sheet

        isInitialFill = sheet.teamSheetId == nil
    }

    // MARK: - Public

    func fetchData() async {
        isLoading = true
        let teamAssignments = await fetchTeamAssignments()
        let assignments = await fetchAssignments()
        let junctions = await fetchAssignmentGroupJunctions(assignments: assignments)
        isLoading = false
        appAssignments = assignments.map { item in
            AppAssignment.from(
                assignment: item,
                teamAssignment: teamAssignments.first(where: { $0.assignmentId == item.id }),
                groupAssignmentJunctions: junctions.filter { $0.assignmentId == item.id }
            )
        }
    }

    func complete() async {
        // TODO: Implement
    }

    func saveAsDraft() async {
        // TODO: Implement
    }

    // MARK: - Helpers

    private func fetchAssignmentGroupJunctions(assignments: [Assignment]) async -> [AssignmentGroupAssignmentJunction] {
        let ids = assignments.map { $0.id }
        let result = await groupAssignmentJunctionsService.getJunctionsForAssignmentIds(assignmentIds: ids)
        if let error = result.1 {
            self.error = error
            return []
        }
        return result.0 ?? []
    }

    private func fetchAssignments() async -> [Assignment] {
        let categorizationSheetId = sheet.sheet.sheetId
        let result = await assignmentsService.getAssignmentsFor(categorizationSheetId)
        if let error = result.1 {
            self.error = error
            return []
        }
        return result.0 ?? []
    }

    private func fetchTeamAssignments() async -> [TeamCategorizationSheetAssignment] {
        guard let teamCategorizationSheetId = sheet.teamSheetId else {
            return []
        }
        let result = await teamAssignmentsService.getTeamCategorizationSheetAssignmentsFor(teamCategorizationSheetId)
        if let error = result.1 {
            self.error = error
            return []
        }
        return result.0 ?? []
    }
}
