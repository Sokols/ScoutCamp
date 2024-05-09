//
//  CreateTeamUseCase.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 09/05/2024.
//

import XCTest
@testable import ScoutCamp

final class CreateTeamUseCaseTests: XCTestCase {

    func testCreateTeamUseCase_whenSuccess_thenTeamIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: false)
        let useCase = DefaultCreateTeamUseCase(teamsRepository: teamsRepository)

        // when
        let requestValue = CreateTeamUseCaseRequestValue(
            regimentId: "regiment_id",
            troopId: "troop_id",
            name: "name"
        )
        let result = await useCase.execute(requestValue: requestValue)
        let createdTeam = try result.get()

        // then
        let userTeamsResult = await teamsRepository.getUserTeams()
        let userTeams = try userTeamsResult.get()

        XCTAssertTrue(userTeams.contains(createdTeam))
    }

    func testCreateTeamUseCase_whenFailure_thenErrorIsReturned() async throws {
        // given
        let teamsRepository = TeamsRepositoryMock(isFailure: true)
        let useCase = DefaultCreateTeamUseCase(teamsRepository: teamsRepository)

        // when
        let requestValue = CreateTeamUseCaseRequestValue(
            regimentId: "regiment_id",
            troopId: "troop_id",
            name: "name"
        )
        let result = await useCase.execute(requestValue: requestValue)

        // then
        do {
            _ = try result.get()
        } catch {
            if let error = error as? TeamsRepositoryMock.TeamsRepositoryMockError {
                XCTAssertTrue(error == .failedCreation)
            }
        }
    }

}
