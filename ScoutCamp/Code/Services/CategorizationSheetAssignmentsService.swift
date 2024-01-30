//
//  CategorizationSheetAssignmentsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 29/01/2024.
//

import Foundation
import FirebaseFirestore

protocol CategorizationSheetAssignmentsServiceProtocol {
    func getAssignments(for categorizationSheetId: String) async -> ResultArray<CategorizationSheetAssignment>
}

final class CategorizationSheetAssignmentsService: BaseService, CategorizationSheetAssignmentsServiceProtocol {

    // MARK: - Public methods

    func getAssignments(for categorizationSheetId: String) async -> ResultArray<CategorizationSheetAssignment> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.categorizationSheetAssignments.rawValue)
            .whereField("categorizationSheetId", isEqualTo: categorizationSheetId)

        return await fetch(query: query)
    }
}
