//
//  DefaultAssignmentGroupsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation
import FirebaseFirestore

final class DefaultAssignmentGroupsRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultAssignmentGroupsRepository: AssignmentGroupsRepository {
    func fetchAssignmentGroups(for groupIds: [String]) async -> Result<[AssignmentGroup], Error> {
        if groupIds.isEmpty {
            return .success([])
        }
        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignmentGroups.rawValue)
            .whereField("id", in: groupIds)

        let result: ResultArray<AssignmentGroupDTO> = await dataService.fetch(query: query)

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
