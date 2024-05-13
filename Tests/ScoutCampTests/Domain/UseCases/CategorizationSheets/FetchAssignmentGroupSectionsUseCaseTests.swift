//
//  FetchAssignmentGroupSectionsUseCaseTests.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import XCTest
@testable import ScoutCamp

final class FetchAssignmentGroupSectionsUseCaseTests: XCTestCase {

    func testFetchAssignmentGroupSectionsUseCase_whenSuccess_thenSectionsIsReturned() async throws {
        // given
        let assignments = [TestData.assignment]
        let sheetAssignments = [TestData.sheetAssignment]
        let junctions = [TestData.junction]
        let minimums = [TestData.firstAssignmentGroupMinimum]
        let groups = [TestData.assignmentGroup]
        let teamAssignments = [TestData.teamAssignment]

        let assignmentsRepository = AssignmentsRepositoryMock(isFailure: false, assignments: assignments)
        let sheetAssignmentsRepository = CategorizationSheetAssignmentsRepositoryMock(isFailure: false, assignments: sheetAssignments)
        let junctionsRepository = AssignmentGroupJunctionsRepositoryMock(isFailure: false, junctions: junctions)
        let minimumsRepository = AssignmentGroupCategoryMinimumsRepositoryMock(isFailure: false, minimums: minimums)
        let groupsRepository = AssignmentGroupsRepositoryMock(isFailure: false, groups: groups)
        let teamAssignmentsRepository = TeamAssignmentsRepositoryMock(isFailure: false, teamAssignments: teamAssignments)

        let useCase = DefaultFetchAssignmentGroupSectionsUseCase(
            assignmentsRepository: assignmentsRepository,
            categorizationSheetAssignmentsRepository: sheetAssignmentsRepository,
            junctionsRepository: junctionsRepository,
            groupMinimumsRepository: minimumsRepository,
            groupsRepository: groupsRepository,
            teamAssignmentsRepository: teamAssignmentsRepository
        )

        // when
        let requestValue = FetchSectionsUseCaseRequestValue(teamSheet: TestData.appTeamSheet)
        let result = await useCase.execute(requestValue: requestValue)
        let sections = try result.get().sections

        // then
        XCTAssertFalse(sections.isEmpty)
    }

    func testFetchAssignmentGroupSectionsUseCase_whenFailure_thenErrorIsReturned() async throws {
        // given
        let assignments = [TestData.assignment]
        let sheetAssignments = [TestData.sheetAssignment]
        let junctions = [TestData.junction]
        let minimums = [TestData.firstAssignmentGroupMinimum]
        let groups = [TestData.assignmentGroup]
        let teamAssignments = [TestData.teamAssignment]

        let assignmentsRepository = AssignmentsRepositoryMock(isFailure: true, assignments: assignments)
        let sheetAssignmentsRepository = CategorizationSheetAssignmentsRepositoryMock(isFailure: true, assignments: sheetAssignments)
        let junctionsRepository = AssignmentGroupJunctionsRepositoryMock(isFailure: true, junctions: junctions)
        let minimumsRepository = AssignmentGroupCategoryMinimumsRepositoryMock(isFailure: true, minimums: minimums)
        let groupsRepository = AssignmentGroupsRepositoryMock(isFailure: true, groups: groups)
        let teamAssignmentsRepository = TeamAssignmentsRepositoryMock(isFailure: true, teamAssignments: teamAssignments)

        let useCase = DefaultFetchAssignmentGroupSectionsUseCase(
            assignmentsRepository: assignmentsRepository,
            categorizationSheetAssignmentsRepository: sheetAssignmentsRepository,
            junctionsRepository: junctionsRepository,
            groupMinimumsRepository: minimumsRepository,
            groupsRepository: groupsRepository,
            teamAssignmentsRepository: teamAssignmentsRepository
        )

        // when
        let requestValue = FetchSectionsUseCaseRequestValue(teamSheet: TestData.appTeamSheet)
        let result = await useCase.execute(requestValue: requestValue)

        // then
        XCTAssertThrowsError(try result.get())
    }
}
