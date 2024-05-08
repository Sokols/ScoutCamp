//
//  DefaultTeamsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DefaultTeamsRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultTeamsRepository: TeamsRepository {

    // MARK: - CREATE

    func createTeam(
        regimentId: String,
        troopId: String,
        name: String
    ) async -> Result<Team, Error> {
        let uid = Auth.auth().currentUser!.uid
        let document = Firestore.firestore()
            .collection(FirebaseCollection.teams.rawValue)
            .document()
        let teamId = document.documentID
        let team = TeamDTO.init(
            id: teamId,
            userId: uid,
            troopId: troopId,
            regimentId: regimentId,
            name: name
        )

        do {
            try await withCheckedThrowingContinuation { continuation in
                document.setData(team.toCreateMap(), merge: true) { _ in
                    continuation.resume()
                }
            }
        } catch {
            return .failure(error)
        }
        return .success(team.toDomain())
    }
    
    // MARK: - READ

    func getRegiments() async -> Result<[Team], Error> {
        let result: ResultArray<TeamDTO> = await dataService.getAll(collection: .regiments)
        return mapResult(result)
    }
    
    func getTroopsForRegiment(regimentId: String) async -> Result<[Team], Error> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.troops.rawValue)
            .whereField("regimentId", isEqualTo: regimentId)

        let result: ResultArray<TeamDTO> = await dataService.fetch(query: query)
        return mapResult(result)
    }
    
    func getTeamsForTroop(troopId: String) async -> Result<[Team], Error> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teams.rawValue)
            .whereField("troopId", isEqualTo: troopId)

        let result: ResultArray<TeamDTO> = await dataService.fetch(query: query)
        return mapResult(result)
    }

    func getUserTeams() async -> Result<[Team], Error> {
        let result: ResultArray<TeamDTO> = await dataService.getUserItems(
            collection: .teams,
            orderBy: "name",
            limit: nil,
            offset: nil
        )
        return mapResult(result)
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

    // MARK: - Helpers

    private func mapResult(_ result: ResultArray<TeamDTO>) -> Result<[Team], Error> {
        if let data = result.0 {
            let mappedData = data.compactMap { $0.toDomain() }
            return .success(mappedData)
        }
        if let error = result.1 {
            return .failure(error)
        }
        return .failure(AppError.generalError)
    }
}
