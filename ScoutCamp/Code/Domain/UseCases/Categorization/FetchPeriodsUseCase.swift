//
//  FetchPeriodsUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/05/2024.
//

import Foundation

protocol FetchPeriodsUseCase {
    func execute() async -> Result<FetchPeriodsUseCaseResponseValue, Error>
}

final class DefaultFetchPeriodsUseCase: FetchPeriodsUseCase {

    private let periodsRepository: CategorizationPeriodsRepository

    init(periodsRepository: CategorizationPeriodsRepository) {
        self.periodsRepository = periodsRepository
    }

    func execute() async -> Result<FetchPeriodsUseCaseResponseValue, Error> {
        let result = await periodsRepository.fetchCategorizationPeriods()

        switch result {
        case .success(let success):
            return .success(FetchPeriodsUseCaseResponseValue(periods: success))
        case .failure(let failure):
            return .failure(failure)
        }
    }
}

struct FetchPeriodsUseCaseResponseValue {
    let periods: [CategorizationPeriod]
}
