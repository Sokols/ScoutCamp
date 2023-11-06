//
//  CategorizationSheetAssignmentsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol CategorizationSheetAssignmentsServiceProtocol {
    func getCategorizationSheetAssignments(for categorizationSheetId: String) async -> ResultArray<CategorizationSheetAssignment>
}

class CategorizationSheetAssignmentsService: BaseService, CategorizationSheetAssignmentsServiceProtocol {
    func getCategorizationSheetAssignments(for categorizationSheetId: String) async -> ResultArray<CategorizationSheetAssignment> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.categorizationSheetAssignments.rawValue)
            .whereField("categorizationSheetId", isEqualTo: categorizationSheetId)

        return await fetch(query: query)
    }
}
