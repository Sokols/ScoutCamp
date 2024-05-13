//
//  DefaultCategorizationSheetAssignmentsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
import FirebaseFirestore

final class DefaultCategorizationSheetAssignmentsRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultCategorizationSheetAssignmentsRepository: CategorizationSheetAssignmentsRepository {
    func fetchAssignments(for sheetId: String) async -> Result<[CategorizationSheetAssignment], Error> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.categorizationSheetAssignments.rawValue)
            .whereField("categorizationSheetId", isEqualTo: sheetId)

        let result: ResultArray<CategorizationSheetAssignmentDTO> = await dataService.fetch(query: query)

        if let data = result.0 {
            let mappedData = data.compactMap { $0.toDomain() }
            return .success(mappedData)
        }
        if let error = result.1 {
            return .failure(error)
        }
        return .failure(AppError.generalError)
    }
}
