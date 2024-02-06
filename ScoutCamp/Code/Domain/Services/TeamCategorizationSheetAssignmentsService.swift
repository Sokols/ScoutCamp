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
    func getTeamCategorizationSheetAssignmentsFor(_ teamCategorizationSheetId: String) async -> ResultArray<TeamCategorizationSheetAssignmentDTO>
    func createUpdateTeamAssignments(_ assignments: [Assignment], teamCategorizationSheetId: String) async -> Error?
}

final class TeamCategorizationSheetAssignmentsService: BaseService, TeamCategorizationSheetAssignmentsServiceProtocol {
    func getTeamCategorizationSheetAssignmentsFor(_ teamCategorizationSheetId: String) async -> ResultArray<TeamCategorizationSheetAssignmentDTO> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheetAssignments.rawValue)
            .whereField("teamCategorizationSheetId", isEqualTo: teamCategorizationSheetId)

        return await fetch(query: query)
    }

    func createUpdateTeamAssignments(_ assignments: [Assignment], teamCategorizationSheetId: String) async -> Error? {
        let firestore = Firestore.firestore()
        let batch = firestore.batch()
        let collection = firestore.collection(FirebaseCollection.teamCategorizationSheetAssignments.rawValue)

        for assignment in assignments {
            var data = assignment.toTeamSheetAssignmentData(from: teamCategorizationSheetId)
            if let id = assignment.teamAssignmentId {
                let ref = collection.document(id)
                batch.updateData(data, forDocument: ref)
            } else {
                let ref = collection.document()
                data["id"] = ref.documentID
                batch.setData(data, forDocument: ref)
            }
        }

        do {
            try await batch.commit()
            return nil
        } catch {
            return error
        }
    }
}
