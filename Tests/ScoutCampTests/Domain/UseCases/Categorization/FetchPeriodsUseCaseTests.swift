//
//  FetchPeriodsUseCaseTests.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 13/05/2024.
//

import XCTest
@testable import ScoutCamp

final class FetchPeriodsUseCaseTests: XCTestCase {

    func testFetchPeriodsUseCase_whenSuccess_thenPeriodsAreReturned() async throws {
        // given
        let periodsRepository = CategorizationPeriodsRepositoryMock(isFailure: false)
        let useCase = DefaultFetchPeriodsUseCase(periodsRepository: periodsRepository)

        // when
        let result = await useCase.execute()
        let periods = try result.get().periods

        // then
        XCTAssertFalse(periods.isEmpty)
    }

    func testFetchPeriodsUseCase_whenFailure_thenErrorIsReturned() async throws {
        // given
        let periodsRepository = CategorizationPeriodsRepositoryMock(isFailure: true)
        let useCase = DefaultFetchPeriodsUseCase(periodsRepository: periodsRepository)

        // when
        let result = await useCase.execute()

        // then
        XCTAssertThrowsError(try result.get())
    }

}
