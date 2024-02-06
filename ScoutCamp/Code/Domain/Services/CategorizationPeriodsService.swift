//
//  CategorizationPeriodsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

protocol CategorizationPeriodsServiceProtocol {
    func getCategorizationPeriods() async -> ResultArray<CategorizationPeriodDTO>
}

final class CategorizationPeriodsService: BaseService, CategorizationPeriodsServiceProtocol {
    private(set) static var periods: [CategorizationPeriodDTO] = []

    static func categoryPeriodFor(id: String?) -> CategorizationPeriodDTO? {
        return CategorizationPeriodsService.periods.first { $0.id == id }
    }

    func getCategorizationPeriods() async -> ResultArray<CategorizationPeriodDTO> {
        let result: ResultArray<CategorizationPeriodDTO> = await getAll(collection: .categorizationPeriods)
        result.0?.forEach { period in
            CategorizationPeriodsService.periods.append(period)
        }
        return result
    }
}
