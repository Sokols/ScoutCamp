//
//  AssignmentGroupAssignmentJunctionsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/11/2023.
//

import Foundation
import FirebaseFirestore

protocol AssignmentGroupAssignmentJunctionsServiceProtocol {
    func getAssignmentJunctions(assignmentId: String) async -> ResultArray<AssignmentGroupAssignmentJunction>
}

class AssignmentGroupAssignmentJunctionsService: BaseService, AssignmentGroupAssignmentJunctionsServiceProtocol {
    func getAssignmentJunctions(assignmentId: String) async -> ResultArray<AssignmentGroupAssignmentJunction> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignmentGroupAssignmentJunctions.rawValue)
            .whereField("assignmentId", isEqualTo: assignmentId)

        return await fetch(query: query)
    }
}
