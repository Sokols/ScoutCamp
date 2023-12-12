//
//  TeamCategorizationSheetsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol TeamCategorizationSheetsServiceProtocol {
    func getTeamCategorizationSheets(for teamId: String) async -> ResultArray<TeamCategorizationSheet>
    func createUpdateTeamSheet(_ sheet: AppTeamSheet) async -> ResultObject<String>
}

final class TeamCategorizationSheetsService: BaseService, TeamCategorizationSheetsServiceProtocol {
    func getTeamCategorizationSheets(for teamId: String) async -> ResultArray<TeamCategorizationSheet> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheets.rawValue)
            .whereField("teamId", isEqualTo: teamId)

        return await fetch(query: query)
    }

    func createUpdateTeamSheet(_ sheet: AppTeamSheet) async -> ResultObject<String> {
        let collection = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheets.rawValue)

        do {
            var data = sheet.toTeamSheetData()
            if let id = sheet.teamSheetId {
                let ref = collection.document(id)
                try await ref.updateData(data)
                return (ref.documentID, nil)
            } else {
                let ref = collection.document()
                data["id"] = ref.documentID
                try await ref.setData(data)
                return (ref.documentID, nil)
            }
        } catch {
            return (nil, error)
        }
    }
}
