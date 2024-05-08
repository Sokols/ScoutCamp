//
//  FetchAssignmentGroupSectionsUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/04/2024.
//

import Foundation

protocol FetchAssignmentGroupSectionsUseCase {
    func execute(requestValue: FetchSectionsUseCaseRequestValue) async -> Result<FetchSectionsUseCaseResponse, Error>
}

final class DefaultFetchAssignmentGroupSectionsUseCase: FetchAssignmentGroupSectionsUseCase {

    private let assignmentsRepository: AssignmentsRepository
    private let categorizationSheetsRepository: CategorizationSheetsRepository
    private let junctionsRepository: AssignmentGroupJunctionsRepository
    private let groupMinimumsRepository: AssignmentGroupCategoryMinimumsRepository
    private let groupsRepository: AssignmentGroupsRepository
    private let teamAssignmentsRepository: TeamAssignmentsRepository

    init(
        assignmentsRepository: AssignmentsRepository,
        categorizationSheetsRepository: CategorizationSheetsRepository,
        junctionsRepository: AssignmentGroupJunctionsRepository,
        groupMinimumsRepository: AssignmentGroupCategoryMinimumsRepository,
        groupsRepository: AssignmentGroupsRepository,
        teamAssignmentsRepository: TeamAssignmentsRepository
    ) {
        self.assignmentsRepository = assignmentsRepository
        self.categorizationSheetsRepository = categorizationSheetsRepository
        self.junctionsRepository = junctionsRepository
        self.groupMinimumsRepository = groupMinimumsRepository
        self.groupsRepository = groupsRepository
        self.teamAssignmentsRepository = teamAssignmentsRepository
    }

    func execute(requestValue: FetchSectionsUseCaseRequestValue) async -> Result<FetchSectionsUseCaseResponse, Error> {
        return await fetchSections(requestValue)
    }
}

struct FetchSectionsUseCaseRequestValue {
    let teamSheet: TeamSheet
}

struct FetchSectionsUseCaseResponse {
    let sections: [AssignmentGroupSection]
}

extension DefaultFetchAssignmentGroupSectionsUseCase {
    private func fetchSections(_ requestValue: FetchSectionsUseCaseRequestValue) async -> Result<FetchSectionsUseCaseResponse, Error> {
        do {
            let sheetAssignmentsResult = await categorizationSheetsRepository.fetchAssignments(for: requestValue.teamSheet.sheet.sheetId)
            let assignmentIds = try sheetAssignmentsResult.get().map { $0.assignmentId }

            let assignmentsResult = await assignmentsRepository.fetchAssignments(for: assignmentIds)
            let assignments = try assignmentsResult.get()

            let groupIds = assignments.map { $0.mainAssignmentGroupId }

            async let groupMinimumsResult = groupMinimumsRepository.fetchGroupMinimums(for: groupIds)
            async let teamAssignmentsResult = requestValue.teamSheet.teamSheetId == nil ? .success([])
            : teamAssignmentsRepository.fetchTeamAssignments(teamSheetId: requestValue.teamSheet.teamSheetId!)
            async let junctionsResult = junctionsRepository.fetchAssignmentJunctions(for: assignmentIds)
            async let groupsResult = groupsRepository.fetchAssignmentGroups(for: groupIds)

            let data = await (groupMinimumsResult, teamAssignmentsResult, junctionsResult, groupsResult)

            let groupMinimums = try data.0.get()
            let teamAssignments = try data.1.get()
            let junctions = try data.2.get()
            let groups = try data.3.get()

            let appAssignments = assignments.compactMap { item in
                item.toDomain(
                    teamAssignment: teamAssignments.first(where: { $0.assignmentId == item.id }),
                    groupAssignmentJunctions: junctions.filter { $0.assignmentId == item.id },
                    groups: groups
                )
            }

            for assignment in appAssignments {
                let dependentOnAssignmentId = assignments
                    .first { $0.id == assignment.assignmentId }?.dependentOnAssignmentId
                assignment.dependentOnAssignment = appAssignments
                    .first { $0.assignmentId == dependentOnAssignmentId }
            }

            var sections: [AssignmentGroupSection] = []
            for group in groups {
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
                    groupMinimums: groupMinimums
                        .filter { $0.assignmentGroupId == group.id }
                        .sorted(by: { $0.category.order < $1.category.order }),
                    assignments: appAssignments
                        .filter { $0.mainAssignmentGroup.id == group.id },
                    partialAssignments: partialAssignments
                )
                sections.append(section)
            }
            let response = FetchSectionsUseCaseResponse(sections: sections)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
