//
//  CategorizationPeriodsRepositoryMock.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 13/05/2024.
//

import Foundation
@testable import ScoutCamp

final class CategorizationPeriodsRepositoryMock: CategorizationPeriodsRepository {

    enum CategorizationPeriodsRepositoryMockError: Error {
        case failedFetching
    }

    private let isFailure: Bool
    private let periods = [TestData.period]

    init(isFailure: Bool) {
        self.isFailure = isFailure
    }

    func fetchCategorizationPeriods() async -> Result<[CategorizationPeriod], Error> {
        if isFailure {
            return .failure(CategorizationPeriodsRepositoryMockError.failedFetching)
        }
        return .success(periods)
    }
}

