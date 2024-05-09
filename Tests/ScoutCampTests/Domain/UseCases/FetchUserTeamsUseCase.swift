//
//  FetchUserTeamsUseCase.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 09/05/2024.
//

import XCTest
@testable import ScoutCamp

final class FetchUserTeamsUseCase: XCTestCase {
    func testFetchUserTeamsUseCase_whenSuccessfullyFetchesUserTeams_thenListIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: false)
        let useCase = DefaultFetchUserTeamsUseCase(teamsRepository: teamsRepository)
        let createTeamResult = await teamsRepository.createTeam(
            regimentId: "regiment_id",
            troopId: "troop_id",
            name: "name"
        )
        let createdTeam = try createTeamResult.get()

        // when
        let result = await useCase.execute()
        let userTeams = try result.get()

        // then
        XCTAssertTrue(userTeams.contains(createdTeam))
    }

    func testFetchUserTeamsUseCase_whenSFailedFetchingUserTeams_thenErrorIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: true)
        let useCase = DefaultFetchUserTeamsUseCase(teamsRepository: teamsRepository)

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
