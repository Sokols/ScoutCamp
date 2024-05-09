//
//  FetchRegimentsUseCase.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 09/05/2024.
//

import XCTest
@testable import ScoutCamp

final class FetchRegimentsUseCase: XCTestCase {

    func testFetchRegimentsUseCase_whenSuccessfullyFetchesRegiments_thenListIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: false)
        let useCase = DefaultFetchRegimentsUseCase(teamsRepository: teamsRepository)

        // when
        let result = await useCase.execute()
        let regiments = try result.get()

        // then
        XCTAssertTrue(regiments.contains(TestData.regiment))
    }

    func testFetchRegimentsUseCase_whenFailedFetchingRegiments_thenErrorIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: true)
        let useCase = DefaultFetchRegimentsUseCase(teamsRepository: teamsRepository)

        // when
        let result = await useCase.execute()

        // then
        do {
            _ = try result.get()
        } catch {
            if let error = error as? TeamsRepositoryMock.TeamsRepositoryMockError {
                XCTAssertTrue(error == .failedFetching)
            }
        }
    }
}
