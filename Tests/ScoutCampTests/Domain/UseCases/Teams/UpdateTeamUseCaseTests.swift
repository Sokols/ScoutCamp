//
//  UpdateTeamUseCaseTests.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 09/05/2024.
//

import XCTest
@testable import ScoutCamp

final class UpdateTeamUseCaseTests: XCTestCase {

    func testUpdateTeamUseCase_whenSuccess_thenNilIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: false)
        let useCase = DefaultUpdateTeamUseCase(teamsRepository: teamsRepository)
        let createTeamResult = await teamsRepository.createTeam(
            regimentId: "regiment_id",
            troopId: "troop_id",
            name: "name"
        )
        let createdTeam = try createTeamResult.get()
        let userTeamsResult = await teamsRepository.getUserTeams()
        let userTeams = try userTeamsResult.get()
        XCTAssertTrue(userTeams.contains(createdTeam))

        // when
        let requestValue = UpdateTeamUseCaseRequestValue(
            team: createdTeam,
            regimentId: "regiment_id",
            troopId: "troop_id",
            name: "new_name"
        )
        let error = await useCase.execute(requestValue: requestValue)

        // then
        XCTAssertNil(error)
    }

    func testUpdateTeamUseCase_whenFailure_thenErrorIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: true)
        let useCase = DefaultUpdateTeamUseCase(teamsRepository: teamsRepository)

        // when
        let requestValue = UpdateTeamUseCaseRequestValue(
            team: TestData.team,
            regimentId: "regiment_id",
            troopId: "troop_id",
            name: "name"
        )
        let error = await useCase.execute(requestValue: requestValue)

        // then
        XCTAssertNotNil(error)
    }
}
