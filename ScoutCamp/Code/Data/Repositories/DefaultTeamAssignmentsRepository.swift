//
//  DefaultTeamAssignmentsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/04/2024.
//

import Foundation
import FirebaseFirestore

final class DefaultTeamAssignmentsRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultTeamAssignmentsRepository: TeamAssignmentsRepository {
    func fetchTeamAssignments(teamSheetId: String) async -> Result<[TeamCategorizationSheetAssignment], Error> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheetAssignments.rawValue)
            .whereField("teamCategorizationSheetId", isEqualTo: teamSheetId)

        let result: ResultArray<TeamCategorizationSheetAssignmentDTO> = await dataService.fetch(query: query)

        if let data = result.0 {
            let mappedData = data.compactMap { $0.toDomain() }
            return .success(mappedData)
        }
        if let error = result.1 {
            return .failure(error)
        }
        return .failure(AppError.generalError)
    }
    
    func saveTeamAssignments(_ assignments: [AppAssignment], teamSheetId: String) async -> Error? {
        let firestore = Firestore.firestore()
        let batch = firestore.batch()
        let collection = firestore.collection(FirebaseCollection.teamCategorizationSheetAssignments.rawValue)

        for assignment in assignments {
            var data = assignment.toTeamSheetAssignmentData(from: teamSheetId)
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
