//
//  FetchRegimentTroopsUseCase.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 09/05/2024.
//

import XCTest
@testable import ScoutCamp


final class FetchRegimentTroopsUseCase: XCTestCase {

    func testFetchRegimentTroopsUseCase_whenSuccessfullyFetchesRegimentTroops_thenListIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: false)
        let useCase = DefaultFetchRegimentTroopsUseCase(teamsRepository: teamsRepository)

        // when
        let requestValue = FetchRegimentTroopsUseCaseRequestValue(regimentId: TestData.regiment.id)
        let result = await useCase.execute(requestValue: requestValue)
        let troops = try result.get()

        // then
        XCTAssertTrue(troops.contains(TestData.troop))
    }

    func testFetchRegimentTroopsUseCase_whenFailedFetchingRegimentTroops_thenErrorIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: true)
        let useCase = DefaultFetchRegimentTroopsUseCase(teamsRepository: teamsRepository)

        // when
        let requestValue = FetchRegimentTroopsUseCaseRequestValue(regimentId: TestData.regiment.id)
        let result = await useCase.execute(requestValue: requestValue)

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
