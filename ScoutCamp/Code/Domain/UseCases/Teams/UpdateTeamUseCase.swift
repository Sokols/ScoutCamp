//
//  UpdateTeamUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/05/2024.
//

import Foundation

protocol UpdateTeamUseCase {
    func execute(requestValue: UpdateTeamUseCaseRequestValue) async -> Error?
}

final class DefaultUpdateTeamUseCase: UpdateTeamUseCase {

    private let teamsRepository: TeamsRepository

    init(teamsRepository: TeamsRepository) {
        self.teamsRepository = teamsRepository
    }

    func execute(requestValue: UpdateTeamUseCaseRequestValue) async -> Error? {
        return await teamsRepository.updateTeam(
            requestValue.team,
            regimentId: requestValue.regimentId,
            troopId: requestValue.troopId,
            name: requestValue.name
        )
    }
}

struct UpdateTeamUseCaseRequestValue {
    let team: Team
    let regimentId: String?
    let troopId: String?
    let name: String?
}
