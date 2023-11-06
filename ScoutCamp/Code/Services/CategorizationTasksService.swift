//
//  AssignmentsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol CategorizationAssignmentsServiceProtocol {
    func getCategorizationAssignments() async -> ResultArray<Assignment>
}

class CategorizationAssignmentsService: BaseService, CategorizationAssignmentsServiceProtocol {
    func getCategorizationAssignments() async -> ResultArray<Assignment> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.categorizationAssignments.rawValue)
            .order(by: "order")

        return await fetch(query: query)
    }
}
