//
//  DefaultTeamSheetsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation
import FirebaseFirestore

final class DefaultTeamSheetsRepository {

    private let dataService: FirebaseDataService
    private let categorizationSheetsRepository: CategorizationSheetsRepository

    init(
        with dataService: FirebaseDataService,
        categorizationSheetsRepository: CategorizationSheetsRepository
    ) {
        self.dataService = dataService
        self.categorizationSheetsRepository = categorizationSheetsRepository
    }
}

extension DefaultTeamSheetsRepository: TeamSheetsRepository {
    func fetchTeamSheets(team: Team) async -> Result<[TeamSheet], Error> {
        // Fetch categorization sheets
        let sheetsResult = await categorizationSheetsRepository.fetchCategorizationSheets()
        if case .failure(let error) = sheetsResult {
            return .failure(error)
        }

        var sheets: [CategorizationSheet] = []
        do {
            sheets = try sheetsResult.get()
        } catch {
            return .failure(error)
        }

        // Fetch team sheets
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheets.rawValue)
            .whereField("teamId", isEqualTo: team.id)
        
        let result: ResultArray<TeamSheetDTO> = await dataService.fetch(query: query)

        // Parse data
        if let data = result.0 {
            let mappedData: [TeamSheet] = data.compactMap { teamSheetDto in
                guard let sheet: CategorizationSheet = sheets
                    .first(where: { item in item.sheetId == teamSheetDto.categorizationSheetId }) 
                else { return nil }
                return teamSheetDto.toDomain(sheet: sheet, team: team)
            }
            return .success(mappedData)
        }
        if let error = result.1 {
            return .failure(error)
        }
        return .failure(AppError.generalError)
    }
}
