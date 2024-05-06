//
//  DefaultAssignmentsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation
import FirebaseFirestore

final class DefaultAssignmentsRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultAssignmentsRepository: AssignmentsRepository {
    func fetchAssignments(for ids: [String]) async -> Result<[Assignment], Error> {
        if ids.isEmpty {
            return .success([])
        }

        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignments.rawValue)
            .whereField("id", in: ids)
        let result: ResultArray<AssignmentDTO> = await dataService.fetch(query: query)

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
