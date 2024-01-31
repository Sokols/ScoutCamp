//
//  AssignmentGroupsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation
import FirebaseFirestore

protocol AssignmentGroupsServiceProtocol {
    func getAssignmentGroups(for groupIds: [String]) async -> ResultArray<AssignmentGroup>
}

final class AssignmentGroupsService: BaseService, AssignmentGroupsServiceProtocol {
    func getAssignmentGroups(for groupIds: [String]) async -> ResultArray<AssignmentGroup> {
        if groupIds.isEmpty {
            return ([], nil)
        }
        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignmentGroups.rawValue)
            .whereField("id", in: groupIds)

        return await fetch(query: query)
    }
}
