//
//  TeamsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

protocol TeamServiceProtocol {
    func createTeam(regimentId: String, troopId: String, name: String) async -> ResultObject<Team>
    func getRegiments() async -> ResultArray<Team>
    func getTroopsForRegiment(regimentId: String) async -> ResultArray<Team>
    func getTeamsForTroop(troopId: String) async -> ResultArray<Team>
    func getUserTeams() async -> ResultArray<Team>
    func updateTeam(_ team: Team, regimentId: String?, troopId: String?, name: String?) async -> Error?
    func deleteTeam(teamId: String) async -> Error?
}

class TeamsService: BaseService, TeamServiceProtocol {

    // MARK: - CREATE

    func createTeam(
        regimentId: String,
        troopId: String,
        name: String
    ) async -> ResultObject<Team> {
        let uid = Auth.auth().currentUser!.uid
        let document = Firestore.firestore()
            .collection(FirebaseCollection.teams.rawValue)
            .document()
        let teamId = document.documentID
        let date = Date.init()
        let team = Team.init(
            id: teamId,
            userId: uid,
            troopId: troopId,
            regimentId: regimentId,
            name: name,
            createdAt: date
        )

        do {
            try await withCheckedThrowingContinuation { continuation in
                document.setData(team.toCreateMap(), merge: true) { _ in
                    continuation.resume()
                }
            }
        } catch {
            return (nil, error)
        }
        return (team, nil)
    }

    // MARK: - READ

    func getRegiments() async -> ResultArray<Team> {
        return await getAll(collection: .regiments)
    }

    func getTroopsForRegiment(regimentId: String) async -> ResultArray<Team> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.troops.rawValue)
            .whereField("regimentId", isEqualTo: regimentId)

        return await fetch(query: query)
    }

    func getTeamsForTroop(troopId: String) async -> ResultArray<Team> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teams.rawValue)
            .whereField("troopId", isEqualTo: troopId)

        return await fetch(query: query)
    }

    func getUserTeams() async -> ResultArray<Team> {
        return await getUserItems(
            collection: .teams,
            orderBy: "name"
        )
    }

    // MARK: - UPDATE

    func updateTeam(
        _ team: Team,
        regimentId: String?,
        troopId: String?,
        name: String?
    ) async -> Error? {
        let database = Firestore.firestore()
            .collection(FirebaseCollection.teams.rawValue)
            .document(team.id)

        var fields: [AnyHashable: Any] = [:]

        fields["regimentId"] = regimentId
        fields["troopId"] = troopId
        fields["name"] = name

        do {
            try await database.updateData(fields)
            return nil
        } catch let error {
            return error
        }
    }

    // MARK: - DELETE

    func deleteTeam(teamId: String) async -> Error? {
        guard (Auth.auth().currentUser?.uid) != nil else {
            return nil
        }

        do {
            let database = Firestore.firestore()
                .collection(FirebaseCollection.teams.rawValue)
                .document(teamId)
            try await database.delete()
            return nil
        } catch {
            return error
        }
    }
}
