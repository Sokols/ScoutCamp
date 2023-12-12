//
//  CategorizationSheetViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import Combine
import Foundation
import SwiftUI

final class CategorizationSheetViewModel: ObservableObject {

    // MARK: - Stored properties

    @Service private var assignmentsService: AssignmentsServiceProtocol
    @Service private var teamCategorizationSheetsService: TeamCategorizationSheetsServiceProtocol
    @Service private var teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    @Service private var groupAssignmentJunctionsService: AssignmentGroupAssignmentJunctionsServiceProtocol

    @Published var sections: [AssignmentGroupSection] = []
    @Published var sheet: AppTeamSheet
    @Published var assignmentToShowSharesInfo: AppAssignment?

    @Published var error: Error?
    @Published var isLoading = false
    @Published var successfulUpdate = false

    private let isInitialFill: Bool

    // MARK: - Computed properties

    var appAssignments: [AppAssignment] {
        var assignments: [AppAssignment] = []
        sections.forEach {
            assignments.append(contentsOf: $0.assignments)
        }
        return assignments
    }

    var points: Double {
        return appAssignments.map { $0.points }.reduce(0, +)
    }

    var isSheetValid: Bool {
        return appAssignments.filter { !$0.isValid }.isEmpty
    }

    var expectedCategory: Category {
        var category = CategoriesService.categories.last
        let expectedCategories = appAssignments
            .compactMap { $0.highestPossibleCategory }
            .sorted(by: {$0.order < $1.order })
        if let first = expectedCategories.first {
            category = first
        }
        return category ?? CategoriesService.getFirstCategory()!
    }

    // MARK: - Initialization

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
        let appAssignments = assignments.map { item in
            AppAssignment.from(
                assignment: item,
                teamAssignment: teamAssignments.first(where: { $0.assignmentId == item.id }),
                groupAssignmentJunctions: junctions.filter { $0.assignmentId == item.id }
            )
        }
        await MainActor.run {
            updateSections(appAssignments)
        }
    }

    func complete() async {
        await createUpdateTeamSheet(isDraft: false)
    }

    func saveAsDraft() async {
        await createUpdateTeamSheet(isDraft: true)
    }

    func showAssignmentSharesInfo(_ assignment: AppAssignment?) {
        assignmentToShowSharesInfo = assignment
    }

    // MARK: - Data handling

    private func createUpdateTeamSheet(isDraft: Bool) async {
        let newAppSheet = generateAppTeamSheet(isDraft: isDraft)
        let result = await teamCategorizationSheetsService.createUpdateTeamSheet(newAppSheet)
        if let error = result.1 {
            self.error = error
            return
        }
        if let teamCategorizationSheetId = result.0 {
            let error = await teamAssignmentsService.createUpdateTeamAssignments(
                appAssignments,
                teamCategorizationSheetId: teamCategorizationSheetId
            )
            if let error {
                self.error = error
            } else {
                successfulUpdate = true
            }
        }
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

    // MARK: - Helpers

    private func updateSections(_ appAssignments: [AppAssignment]) {
        sections.removeAll()
        let groups = Set(appAssignments.map { $0.mainAssignmentGroup }).sorted(by: { $0.order < $1.order })
        for group in groups {
            let section = AssignmentGroupSection(
                group: group,
                assignments: appAssignments.filter { $0.mainAssignmentGroup == group}
            )
            sections.append(section)
        }
    }

    private func generateAppTeamSheet(isDraft: Bool) -> AppTeamSheet {
        return AppTeamSheet(
            teamSheetId: sheet.teamSheetId,
            sheet: sheet.sheet,
            team: sheet.team,
            category: expectedCategory,
            points: points,
            isDraft: isDraft,
            createdAt: sheet.createdAt,
            updatedAt: .now
        )
    }
}
