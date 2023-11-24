//
//  TeamCategorizationSheetAssignmentsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol TeamCategorizationSheetAssignmentsServiceProtocol {
    func getTeamCategorizationSheetAssignmentsFor(_ teamCategorizationSheetId: String) async -> ResultArray<TeamCategorizationSheetAssignment>
}

final class TeamCategorizationSheetAssignmentsService: BaseService, TeamCategorizationSheetAssignmentsServiceProtocol {
    func getTeamCategorizationSheetAssignmentsFor(_ teamCategorizationSheetId: String) async -> ResultArray<TeamCategorizationSheetAssignment> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheetAssignments.rawValue)
            .whereField("teamCategorizationSheetId", isEqualTo: teamCategorizationSheetId)

        return await fetch(query: query)
    }
}
