//
//  DeleteTeamUseCaseTests.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 09/05/2024.
//

import XCTest
@testable import ScoutCamp

final class DeleteTeamUseCaseTests: XCTestCase {

    func testDeleteTeamUseCase_whenSuccess_thenNilIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: false)
        let useCase = DefaultDeleteTeamUseCase(teamsRepository: teamsRepository)
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
        let requestValue = DeleteTeamUseCaseRequestValue(teamId: createdTeam.id)
        let error = await useCase.execute(requestValue: requestValue)

        // then
        XCTAssertNil(error)
    }

    func testDeleteTeamUseCase_whenFailure_thenErrorIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: true)
        let useCase = DefaultDeleteTeamUseCase(teamsRepository: teamsRepository)

        // when
        let requestValue = DeleteTeamUseCaseRequestValue(teamId: "team_id")
        let error = await useCase.execute(requestValue: requestValue)

        // then
        XCTAssertNotNil(error)
    }
}
