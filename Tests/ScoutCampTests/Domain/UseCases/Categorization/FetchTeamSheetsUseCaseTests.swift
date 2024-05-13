//
//  FetchTeamSheetsUseCaseTests.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 13/05/2024.
//

import XCTest
@testable import ScoutCamp

final class FetchTeamSheetsUseCaseTests: XCTestCase {

    func testFetchTeamSheetsUseCase_whenSuccess_thenSheetsAreReturned() async throws {
        // given
        let teamSheetsRepository = TeamSheetsRepositoryMock(isFailure: false)
        let useCase = DefaultFetchTeamSheetsUseCase(teamSheetsRepository: teamSheetsRepository)
        _ = await teamSheetsRepository.saveTeamSheet(TestData.appTeamSheet)

        // when
        let requestValue = FetchTeamSheetsUseCaseRequestValue(
            team: TestData.team,
            currentPeriodId: TestData.period.id
        )
        let result = await useCase.execute(requestValue: requestValue)
        let response = try result.get()

        // then
        XCTAssertTrue(response.currentSheets.contains(TestData.appTeamSheet))
        XCTAssertFalse(response.oldSheets.contains(TestData.appTeamSheet))
    }

    func testFetchTeamSheetsUseCase_whenFailure_thenErrorIsReturned() async throws {
        // given
        let teamSheetsRepository = TeamSheetsRepositoryMock(isFailure: true)
        let useCase = DefaultFetchTeamSheetsUseCase(teamSheetsRepository: teamSheetsRepository)

        // when
        let requestValue = FetchTeamSheetsUseCaseRequestValue(
            team: TestData.team,
            currentPeriodId: TestData.period.id
        )
        let result = await useCase.execute(requestValue: requestValue)

        // then
        XCTAssertThrowsError(try result.get())
    }
}
