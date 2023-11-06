//
//  AssignmentsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation
import FirebaseFirestore

protocol AssignmentsServiceProtocol {
    func getAssignmentsFor(_ ids: [String]) async -> ResultArray<Assignment>
}

class AssignmentsService: BaseService, AssignmentsServiceProtocol {
    func getAssignmentsFor(_ ids: [String]) async -> ResultArray<Assignment> {
        if ids.isEmpty {
            return ([], nil)
        }
        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignments.rawValue)
            .whereField("id", in: ids)

        return await fetch(query: query)
    }
}
