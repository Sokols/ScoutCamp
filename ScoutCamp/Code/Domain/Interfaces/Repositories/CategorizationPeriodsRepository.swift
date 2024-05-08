//
//  CategorizationPeriodsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

protocol CategorizationPeriodsRepository {
    func fetchCategorizationPeriods() async -> Result<[CategorizationPeriod], Error>
}
