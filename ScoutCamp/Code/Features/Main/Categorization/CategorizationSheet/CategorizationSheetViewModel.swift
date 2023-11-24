//
//  CategorizationSheetViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import Combine

struct TeamAssignmentJunction: Hashable {
    var assignment: Assignment
    var teamAssignment: TeamCategorizationSheetAssignment?
}

@MainActor
class CategorizationSheetViewModel: ObservableObject {

    @Published var appAssignments: [AppAssignment] = []
    @Published var sheetJunction: CategorizationSheetJunction

    @Published var error: Error?
    @Published var isLoading = false

    private let assignmentsService: AssignmentsServiceProtocol
    private let teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    private let groupAssignmentJunctionsService: AssignmentGroupAssignmentJunctionsServiceProtocol
    private let isInitialFill: Bool

    var sheetType: String {
        SheetTypesService.sheetTypeFor(id: sheetJunction.categorizationSheet.sheetTypeId)?.name ?? ""
    }

    var category: Category? {
        CategoriesService.categoryFor(id: sheetJunction.teamCategorizationSheet?.categoryId)
    }

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

    init(
        sheetJunction: CategorizationSheetJunction,
        assignmentsService: AssignmentsServiceProtocol,
        teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol,
        groupAssignmentJunctionsService: AssignmentGroupAssignmentJunctionsServiceProtocol
    ) {
        self.sheetJunction = sheetJunction
        self.assignmentsService = assignmentsService
        self.teamAssignmentsService = teamAssignmentsService
        self.groupAssignmentJunctionsService = groupAssignmentJunctionsService

        isInitialFill = sheetJunction.teamCategorizationSheet == nil
        initTeamCategorizationSheetIfNeeded()
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

    private func initTeamCategorizationSheetIfNeeded() {
        if sheetJunction.teamCategorizationSheet != nil {
            return
        }
        sheetJunction.teamCategorizationSheet = TeamCategorizationSheet(
            id: "",
            categorizationSheetId: sheetJunction.categorizationSheet.id,
            teamId: sheetJunction.team.id,
            categoryId: CategoriesService.getFirstCategory()?.id ?? "",
            points: 0,
            isDraft: true,
            createdAt: .now,
            updatedAt: .now
        )
    }

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
        let categorizationSheetId = sheetJunction.categorizationSheet.id
        let result = await assignmentsService.getAssignmentsFor(categorizationSheetId)
        if let error = result.1 {
            self.error = error
            return []
        }
        return result.0 ?? []
    }

    private func fetchTeamAssignments() async -> [TeamCategorizationSheetAssignment] {
        guard let teamCategorizationSheetId = sheetJunction.teamCategorizationSheet?.id else {
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
