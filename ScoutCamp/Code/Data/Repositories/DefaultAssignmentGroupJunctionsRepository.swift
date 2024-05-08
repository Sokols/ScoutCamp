//
//  DefaultAssignmentGroupJunctionsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 29/04/2024.
//


import Foundation
import FirebaseFirestore

final class DefaultAssignmentGroupJunctionsRepository: AssignmentGroupJunctionsRepository {
    
    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultAssignmentGroupJunctionsRepository {
    func fetchAssignmentJunctions(for assignmentIds: [String]) async -> Result<[AssignmentGroupJunction], Error> {
        if assignmentIds.isEmpty {
            return .success([])
        }
        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignmentGroupAssignmentJunctions.rawValue)
            .whereField("assignmentId", in: assignmentIds)

        let result: ResultArray<AssignmentGroupAssignmentJunctionDTO> = await dataService.fetch(query: query)

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
