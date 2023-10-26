//
//  CategorizationSheetsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol CategorizationSheetsServiceProtocol {
    func getCategorizationSheets() async -> ResultArray<CategorizationSheet>
}

class CategorizationSheetsService: BaseService, CategorizationSheetsServiceProtocol {
    private(set) static var categorizationSheets: [CategorizationSheet] = []

    static func categorizationSheetFor(id: String?) -> CategorizationSheet? {
        return CategorizationSheetsService.categorizationSheets.first { $0.id == id }
    }

    func getCategorizationSheets() async -> ResultArray<CategorizationSheet> {
        let result: ResultArray<CategorizationSheet> = await getAll(collection: .categorizationSheets)
        result.0?.forEach { period in
            CategorizationSheetsService.categorizationSheets.append(period)
        }
        return result
    }
}
