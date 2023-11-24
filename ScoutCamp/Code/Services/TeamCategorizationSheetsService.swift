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
}

final class TeamCategorizationSheetsService: BaseService, TeamCategorizationSheetsServiceProtocol {
    func getTeamCategorizationSheets(for teamId: String) async -> ResultArray<TeamCategorizationSheet> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheets.rawValue)
            .whereField("teamId", isEqualTo: teamId)

        return await fetch(query: query)
    }
}
