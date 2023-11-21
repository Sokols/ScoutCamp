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

    @Published var assignmentJunctions: [TeamAssignmentJunction] = []
    @Published var sheetJunction: CategorizationSheetJunction

    @Published var error: Error?
    @Published var isLoading = false

    private let assignmentsService: AssignmentsServiceProtocol
    private let teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    private let isInitialFill: Bool

    var sheetType: String {
        SheetTypesService.sheetTypeFor(id: sheetJunction.categorizationSheet.sheetTypeId)?.name ?? ""
    }

    var category: Category? {
        CategoriesService.categoryFor(id: sheetJunction.teamCategorizationSheet?.categoryId)
    }

    var points: Int {
        sheetJunction.teamCategorizationSheet?.points ?? 0
    }

    init(
        sheetJunction: CategorizationSheetJunction,
        assignmentsService: AssignmentsServiceProtocol,
        teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    ) {
        self.sheetJunction = sheetJunction
        self.assignmentsService = assignmentsService
        self.teamAssignmentsService = teamAssignmentsService

        isInitialFill = sheetJunction.teamCategorizationSheet == nil
        if sheetJunction.teamCategorizationSheet == nil {
            self.sheetJunction.teamCategorizationSheet = TeamCategorizationSheet(
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
    }

    // MARK: - Public

    func fetchAssignments() async {
        let categorizationSheetId = sheetJunction.categorizationSheet.id
        isLoading = true
        let result = await assignmentsService.getAssignmentsFor(categorizationSheetId)
        let teamAssignments = await fetchTeamAssignments()
        isLoading = false
        if let error = result.1 {
            self.error = error
        } else if let assignments = result.0 {
            self.assignmentJunctions = assignments.map { item in
                TeamAssignmentJunction(
                    assignment: item,
                    teamAssignment: teamAssignments.first(where: { $0.assignmentId == item.id })
                )
            }
        }
    }

    func complete() async {
        // TODO: Implement
    }

    func saveAsDraft() async {
        // TODO: Implement
    }

    // MARK: - Helpers

    private func fetchTeamAssignments() async -> [TeamCategorizationSheetAssignment] {
        guard let teamCategorizationSheetId = sheetJunction.teamCategorizationSheet?.id else {
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
