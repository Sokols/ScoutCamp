//
//  AssignmentGroupCategoryMinimumsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/01/2024.
//

import Foundation
import FirebaseFirestore

protocol AssignmentGroupCategoryMinimumsServiceProtocol {
    func getGroupCategoryMinimums(groupIds: [String]) async -> ResultArray<AssignmentGroupCategoryMinimumDTO>
}

final class AssignmentGroupCategoryMinimumsService: BaseService, AssignmentGroupCategoryMinimumsServiceProtocol {
    func getGroupCategoryMinimums(groupIds: [String]) async -> ResultArray<AssignmentGroupCategoryMinimumDTO> {
        if groupIds.isEmpty {
            return ([], nil)
        }
        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignmentGroupCategoryMinimums.rawValue)
            .whereField("assignmentGroupId", in: groupIds)

        return await fetch(query: query)
    }
}
