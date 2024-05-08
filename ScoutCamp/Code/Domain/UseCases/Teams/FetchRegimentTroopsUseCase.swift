//
//  FetchRegimentTroopsUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/05/2024.
//

import Foundation

protocol FetchRegimentTroopsUseCase {
    func execute(requestValue: FetchRegimentTroopsUseCaseRequestValue) async -> Result<[Team], Error>
}

final class DefaultFetchRegimentTroopsUseCase: FetchRegimentTroopsUseCase {

    private let teamsRepository: TeamsRepository

    init(teamsRepository: TeamsRepository) {
        self.teamsRepository = teamsRepository
    }

    func execute(requestValue: FetchRegimentTroopsUseCaseRequestValue) async -> Result<[Team], Error> {
        return await teamsRepository.getTroopsForRegiment(regimentId: requestValue.regimentId)
    }
}

struct FetchRegimentTroopsUseCaseRequestValue {
    let regimentId: String
}
