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

#warning("TODO")
//extension DefaultAssignmentsRepository: AssignmentsRepository {
//    func fetchAssignments(for ids: [String]) async -> Result<[Assignment], Error> {
//        if ids.isEmpty {
//            return .success([])
//        }
//        // Fetch assignments
//        let query = Firestore.firestore()
//            .collection(FirebaseCollection.assignments.rawValue)
//            .whereField("id", in: ids)
//        let result: ResultArray<AssignmentDTO> = await dataService.fetch(query: query)
//
//        if let error = result.1 {
//            return .failure(error)
//        }
//
//        //Fetch junctions
//        let assignmentDtos = result.0 ?? []
//        let assignmentIds = assignmentDtos.map { $0.id }
//        let junctionsResult = await fetchAssignmentJunctions(for: assignmentIds)
//
//        if let error = junctionsResult.1 {
//            return .failure(error)
//        }
//
//        if let data = result.0 {
//            let mappedData = data.compactMap { $0.toDomain() }
//            return .success(mappedData)
//        }
//
//        return .failure(AppError.generalError)
//    }
//
//    private func fetchAssignmentJunctions(
//        for assignmentIds: [String]
//    ) async -> ResultArray<AssignmentGroupAssignmentJunctionDTO> {
//        if assignmentIds.isEmpty {
//            return ([], nil)
//        }
//        let query = Firestore.firestore()
//            .collection(FirebaseCollection.assignmentGroupAssignmentJunctions.rawValue)
//            .whereField("assignmentId", in: assignmentIds)
//
//        return await dataService.fetch(query: query)
//    }
//}
