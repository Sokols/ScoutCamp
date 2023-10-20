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

class CategorizationPeriodsService: BaseService, CategorizationPeriodsServiceProtocol {
    func getCategorizationPeriods() async -> ResultArray<CategorizationPeriod> {
        await getAll(collection: .categorizationPeriods)
    }
}
