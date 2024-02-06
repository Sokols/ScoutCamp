//
//  CategorizationSheetsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestore

protocol CategorizationSheetsServiceProtocol {
    func getCategorizationSheets() async -> ResultArray<CategorizationSheetDTO>
}

final class CategorizationSheetsService: BaseService, CategorizationSheetsServiceProtocol {
    private(set) static var categorizationSheets: [CategorizationSheetDTO] = []

    // MARK: - Public methods

    static func categorizationSheetFor(id: String?) -> CategorizationSheetDTO? {
        return CategorizationSheetsService.categorizationSheets.first { $0.id == id }
    }

    static func getCurrentPeriodCategorizationSheets() -> [CategorizationSheetDTO] {
        let currentPeriodId = RemoteConfigManager.shared.currentPeriodId
        return CategorizationSheetsService.categorizationSheets.filter { $0.periodId == currentPeriodId }
    }

    func getCategorizationSheets() async -> ResultArray<CategorizationSheetDTO> {
        let result: ResultArray<CategorizationSheetDTO> = await getAll(collection: .categorizationSheets)
        result.0?.forEach { period in
            CategorizationSheetsService.categorizationSheets.append(period)
        }
        return result
    }
}
