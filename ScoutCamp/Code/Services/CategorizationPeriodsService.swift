//
//  CategorizationPeriodsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

protocol CategorizationPeriodsServiceProtocol {
    func getCategorizationPeriods() async -> ResultArray<CategorizationPeriod>
}

final class CategorizationPeriodsService: BaseService, CategorizationPeriodsServiceProtocol {
    private(set) static var periods: [CategorizationPeriod] = []

    static func categoryPeriodFor(id: String?) -> CategorizationPeriod? {
        return CategorizationPeriodsService.periods.first { $0.id == id }
    }

    func getCategorizationPeriods() async -> ResultArray<CategorizationPeriod> {
        let result: ResultArray<CategorizationPeriod> = await getAll(collection: .categorizationPeriods)
        result.0?.forEach { period in
            CategorizationPeriodsService.periods.append(period)
        }
        return result
    }
}
