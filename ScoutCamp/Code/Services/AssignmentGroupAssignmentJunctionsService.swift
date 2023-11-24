//
//  AssignmentGroupAssignmentJunctionsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/11/2023.
//

import Foundation
import FirebaseFirestore

protocol AssignmentGroupAssignmentJunctionsServiceProtocol {
    func getJunctionsForAssignmentIds(assignmentIds: [String]) async -> ResultArray<AssignmentGroupAssignmentJunction>
}

final class AssignmentGroupAssignmentJunctionsService: BaseService, AssignmentGroupAssignmentJunctionsServiceProtocol {
    func getJunctionsForAssignmentIds(assignmentIds: [String]) async -> ResultArray<AssignmentGroupAssignmentJunction> {
        if assignmentIds.isEmpty {
            return ([], nil)
        }
        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignmentGroupAssignmentJunctions.rawValue)
            .whereField("assignmentId", in: assignmentIds)

        return await fetch(query: query)
    }
}
