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
    func getCategorizationSheet(for periodId: String, sheetTypeId: String) async -> ResultObject<CategorizationSheet>
}

class CategorizationSheetsService: BaseService, CategorizationSheetsServiceProtocol {
    func getCategorizationSheet(for periodId: String, sheetTypeId: String) async -> ResultObject<CategorizationSheet> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.categorizationSheets.rawValue)
            .whereField("periodId", isEqualTo: periodId)
            .whereField("sheetTypeId", isEqualTo: sheetTypeId)

        let response: ResultArray<CategorizationSheet> = await fetch(query: query)
        return (response.0?.first, response.1)
    }
}
