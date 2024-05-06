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
    private let categoriesRepository: CategoriesRepository

    init(
        with dataService: FirebaseDataService,
        categorizationSheetsRepository: CategorizationSheetsRepository,
        categoriesRepository: CategoriesRepository
    ) {
        self.dataService = dataService
        self.categorizationSheetsRepository = categorizationSheetsRepository
        self.categoriesRepository = categoriesRepository
    }
}

extension DefaultTeamSheetsRepository: TeamSheetsRepository {
    func saveTeamSheet(_ sheet: TeamSheet) async -> Result<String, Error> {
        let collection = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheets.rawValue)

        do {
            var data = sheet.toTeamSheetData()
            if let id = sheet.teamSheetId {   // Update if teamSheetId exists
                let ref = collection.document(id)
                try await ref.updateData(data)
                return .success(ref.documentID)
            } else {   // Create if teamSheetId doesn't exist
                let ref = collection.document()
                data["id"] = ref.documentID
                try await ref.setData(data)
                return .success(ref.documentID)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func fetchTeamSheets(team: Team) async -> Result<[TeamSheet], Error> {
        // Fetch categorization sheets
        let sheetsResult = await categorizationSheetsRepository.fetchCategorizationSheets()
        if case .failure(let error) = sheetsResult {
            return .failure(error)
        }        

        // Fetch categories
        let categoriesResult = await categoriesRepository.fetchCategories()
        if case .failure(let error) = categoriesResult {
            return .failure(error)
        }

        var sheets: [CategorizationSheet] = []
        var categories: [Category] = []
        do {
            sheets = try sheetsResult.get()
            categories = try categoriesResult.get()
        } catch {
            return .failure(error)
        }

        // Fetch team sheets
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheets.rawValue)
            .whereField("teamId", isEqualTo: team.id)
        
        let result: ResultArray<TeamSheetDTO> = await dataService.fetch(query: query)

        // Parse data
        if let teamSheetDtos = result.0 {
            let mappedData: [TeamSheet] = sheets.map { sheet in
                // team sheet already exists
                if let teamSheet = teamSheetDtos.first(where: {$0.categorizationSheetId == sheet.sheetId}),
                   let category = categories.first(where: {$0.id == teamSheet.categoryId}) {
                    let newTeamSheet = teamSheet.toDomain(sheet: sheet, team: team, category: category)
                    return newTeamSheet
                }

                // sheet not filled by the team
                return TeamSheetDTO.from(sheet: sheet, team: team)
            }
            .sorted(by: {$0.sheet.sheetType.order < $1.sheet.sheetType.order})

            return .success(mappedData)
        }
        if let error = result.1 {
            return .failure(error)
        }
        return .failure(AppError.generalError)
    }
}
