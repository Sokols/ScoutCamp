//
//  FetchRegimentsUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/05/2024.
//

import Foundation

protocol FetchRegimentsUseCase {
    func execute() async -> Result<[Team], Error>
}

final class DefaultFetchRegimentsUseCase: FetchRegimentsUseCase {

    private let teamsRepository: TeamsRepository

    init(teamsRepository: TeamsRepository) {
        self.teamsRepository = teamsRepository
    }

    func execute() async -> Result<[Team], Error> {
        return await teamsRepository.getRegiments()
    }
}
