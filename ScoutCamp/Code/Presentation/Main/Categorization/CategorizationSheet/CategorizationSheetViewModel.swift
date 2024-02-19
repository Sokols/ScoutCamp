//
//  CategorizationSheetViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class CategorizationSheetViewModel: ObservableObject {

    // MARK: - Stored properties

    @Service private var assignmentsService: AssignmentsServiceProtocol
    @Service private var teamCategorizationSheetsService: TeamCategorizationSheetsServiceProtocol
    @Service private var teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    @Service private var groupAssignmentJunctionsService: AssignmentGroupAssignmentJunctionsServiceProtocol
    @Service private var groupMinimumsService: AssignmentGroupCategoryMinimumsServiceProtocol
    @Service private var categorizationSheetAssignmentsService: CategorizationSheetAssignmentsServiceProtocol
    @Service private var assignmentGroupsService: AssignmentGroupsServiceProtocol

    @Published var sections: [AssignmentGroupSection] = []
    @Published var sheet: TeamSheet
    @Published var assignmentToShowSharesInfo: Assignment?

    @Published var error: Error?
    @Published var isLoading = false
    @Published var successfulUpdate = false

    private let isInitialFill: Bool

    // MARK: - Computed properties

    var appAssignments: [Assignment] {
        var assignments: [Assignment] = []
        sections.forEach {
            assignments.append(contentsOf: $0.assignments)
        }
        return assignments
    }

    var points: Double {
        let sum = sections.map { $0.totalPoints }.reduce(0, +)
        return sum.isNaN ? 0 : sum
    }

    var expectedCategory: Category? {
        var category = CategoriesService.categories.last?.toDomain()
        let expectedCategories = sections
            .compactMap { $0.highestPossibleCategory }
            .sorted(by: {$0.order < $1.order })
        if let first = expectedCategories.first {
            category = first
        }
        return category
    }

    // MARK: - Initialization

    init(sheet: TeamSheet) {
        self.sheet = sheet
        isInitialFill = sheet.teamSheetId == nil
    }

    // MARK: - Public

    func fetchData() async {
        isLoading = true
        let sections = await fetchSections()
        updateSections(sections)
        isLoading = false
    }

    func complete() async {
        await createUpdateTeamSheet(isDraft: false)
    }

    func saveAsDraft() async {
        await createUpdateTeamSheet(isDraft: true)
    }

    func showAssignmentSharesInfo(_ assignment: Assignment?) {
        assignmentToShowSharesInfo = assignment
    }

    // MARK: - Data handling

    private func fetchSections() async -> [AssignmentGroupSection] {
        let assignmentDtos = await fetchAssignments()
        let groupIds = assignmentDtos.map { $0.mainAssignmentGroupId }

        async let groupMinimums = fetchGroupMinimums(groupIds)
        async let teamAssignments = fetchTeamAssignments()
        async let junctions = fetchAssignmentGroupJunctions(assignments: assignmentDtos)
        async let groups = fetchGroups(groupIds)

        let data = await (groupMinimums, teamAssignments, junctions, groups)

        let assignments = assignmentDtos.compactMap { item in
            item.toDomain(
                teamAssignment: data.1.first(where: { $0.assignmentId == item.id }),
                groupAssignmentJunctions: data.2.filter { $0.assignmentId == item.id },
                groups: data.3
            )
        }

        for assignment in assignments {
            let dependentOnAssignmentId = assignmentDtos
                .first { $0.id == assignment.assignmentId }?.dependentOnAssignmentId
            assignment.dependentOnAssignment = assignments
                .first { $0.assignmentId == dependentOnAssignmentId }
        }

        var sections: [AssignmentGroupSection] = []
        for group in data.3 {
            let partialAssignments = appAssignments.filter { assignment in
                guard let shares = assignment.assignmentGroupShares else {
                    return false
                }
                return shares.contains(where: {
                    $0.assignmentGroup.id != assignment.mainAssignmentGroup.id &&
                    $0.assignmentGroup.id == group.id
                })
            }
            let section = AssignmentGroupSection(
                group: group,
                groupMinimums: data.0
                    .filter { $0.assignmentGroupId == group.id }
                    .sorted(by: { $0.category.order < $1.category.order }),
                assignments: appAssignments
                    .filter { $0.mainAssignmentGroup.id == group.id },
                partialAssignments: partialAssignments
            )
            sections.append(section)
        }
        return sections
    }

    private func createUpdateTeamSheet(isDraft: Bool) async {
        guard let newAppSheet = generateAppTeamSheet(isDraft: isDraft) else { return }
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

    private func fetchAssignmentGroupJunctions(assignments: [AssignmentDTO]) async -> [AssignmentGroupAssignmentJunctionDTO] {
        let ids = assignments.map { $0.id }
        let result = await groupAssignmentJunctionsService.getJunctionsForAssignmentIds(assignmentIds: ids)
        if let error = result.1 {
            self.error = error
            return []
        }
        return result.0 ?? []
    }

    private func fetchAssignments() async -> [AssignmentDTO] {
        let categorizationSheetId = sheet.sheet.sheetId
        let categorizationSheetAssignments = await fetchCategorizationSheetAssignments(for: categorizationSheetId)
        let mappedAssignmentIds = categorizationSheetAssignments.map { $0.assignmentId }
        let result = await assignmentsService.getAssignmentsFor(mappedAssignmentIds)
        if let error = result.1 {
            self.error = error
            return []
        }
        return result.0 ?? []
    }

    private func fetchCategorizationSheetAssignments(
        for categorizationSheetId: String
    ) async -> [CategorizationSheetAssignment] {
        let result = await categorizationSheetAssignmentsService.getAssignments(for: categorizationSheetId)
        if let error = result.1 {
            self.error = error
            return []
        }
        return result.0?.map { $0.toDomain() } ?? []
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
        let mappedResult = result.0?.compactMap { $0.toDomain() }
        return mappedResult ?? []    
    }

    private func fetchGroupMinimums(_ groupIds: [String]) async -> [AssignmentGroupCategoryMinimum] {
        let result = await groupMinimumsService.getGroupCategoryMinimums(groupIds: groupIds)
        if let error = result.1 {
            self.error = error
            return []
        }
        let mappedResult = result.0?.compactMap { $0.toDomain(category: Category.init(id: "polowa", name: "Polowa", imagePath: "", order: 0)) }
        return mappedResult ?? []
    }

    private func fetchGroups(_ groupIds: [String]) async -> [AssignmentGroup] {
        let result = await assignmentGroupsService.getAssignmentGroups(for: groupIds)
        if let error = result.1 {
            self.error = error
            return []
        }
        return result.0?
            .map { $0.toDomain() }
            .sorted(by: { $0.order < $1.order }) ?? []
    }

    // MARK: - Helpers

    private func updateSections(_ sections: [AssignmentGroupSection]) {
        self.sections = sections
    }

    private func generateAppTeamSheet(isDraft: Bool) -> TeamSheet? {
        guard let category = expectedCategory else { return nil }
        return TeamSheet(
            teamSheetId: sheet.teamSheetId,
            sheet: sheet.sheet,
            team: sheet.team,
            category: category,
            points: points,
            isDraft: isDraft,
            createdAt: sheet.createdAt,
            updatedAt: .now
        )
    }
}
