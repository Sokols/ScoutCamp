//
//  SaveTeamSheetUseCaseTests.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import XCTest
@testable import ScoutCamp

final class SaveTeamSheetUseCaseTests: XCTestCase {

    func testSaveTeamSheetUseCase_whenSuccess_thenNilIsReturned() async throws {
        // given
        let teamSheetsRepository = TeamSheetsRepositoryMock(isFailure: false)
        let teamAssignmentsRepository = TeamAssignmentsRepositoryMock(isFailure: false, teamAssignments: [])
        let useCase = DefaultSaveTeamSheetUseCase(
            teamSheetsRepository: teamSheetsRepository,
            teamAssignmentsRepository: teamAssignmentsRepository
        )

        // when
        let requestValue = SaveTeamSheetUseCaseRequestValue(
            teamSheet: TestData.appTeamSheet,
            assignments: [TestData.booleanAppAssignment],
            isDraft: false
        )
        let error = await useCase.execute(requestValue: requestValue)

        // then
        XCTAssertNil(error)

        let teamSheetsResult = await teamSheetsRepository.fetchTeamSheets(team: TestData.appTeamSheet.team)
        let teamSheets = try teamSheetsResult.get()
        XCTAssertTrue(teamSheets.contains(TestData.appTeamSheet))
    }

    func testSaveTeamSheetUseCase_whenFailure_thenErrorIsReturned() async throws {
        // given
        let teamSheetsRepository = TeamSheetsRepositoryMock(isFailure: true)
        let teamAssignmentsRepository = TeamAssignmentsRepositoryMock(isFailure: true, teamAssignments: [])
        let useCase = DefaultSaveTeamSheetUseCase(
            teamSheetsRepository: teamSheetsRepository,
            teamAssignmentsRepository: teamAssignmentsRepository
        )

        // when
        let requestValue = SaveTeamSheetUseCaseRequestValue(
            teamSheet: TestData.appTeamSheet,
            assignments: [TestData.booleanAppAssignment],
            isDraft: false
        )
        let error = await useCase.execute(requestValue: requestValue)

        // then
        XCTAssertNotNil(error)
    }
}
