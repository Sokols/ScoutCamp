//
//  DefaultCategorizationSheetsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation
import FirebaseFirestore

final class DefaultCategorizationSheetsRepository {

    private let dataService: FirebaseDataService
    private let sheetTypesRepository: SheetTypesRepository
    private let categorizationPeriodsRepository: CategorizationPeriodsRepository

    init(
        with dataService: FirebaseDataService,
        sheetTypesRepository: SheetTypesRepository,
        categorizationPeriodsRepository: CategorizationPeriodsRepository
    ) {
        self.dataService = dataService
        self.sheetTypesRepository = sheetTypesRepository
        self.categorizationPeriodsRepository = categorizationPeriodsRepository
    }
}

extension DefaultCategorizationSheetsRepository: CategorizationSheetsRepository {
    func fetchCategorizationSheets() async -> Result<[CategorizationSheet], Error> {
        // Fetch sheet types
        let sheetTypesResult = await sheetTypesRepository.fetchSheetTypes()
        if case .failure(let error) = sheetTypesResult {
            return .failure(error)
        }

        // Fetch categorization periods
        let periodsResult = await categorizationPeriodsRepository.fetchCategorizationPeriods()
        if case .failure(let error) = periodsResult {
            return .failure(error)
        }

        var sheetTypes: [SheetType] = []
        var periods: [CategorizationPeriod] = []

        do {
            sheetTypes = try sheetTypesResult.get()
            periods = try periodsResult.get()
        } catch {
            return .failure(error)
        }

        // Fetch categorization sheets
        let result: ResultArray<CategorizationSheetDTO> = await dataService.getAll(collection: .categorizationSheets)

        // Parse data
        if let data = result.0 {
            let mappedData: [CategorizationSheet] = data.compactMap { item in
                guard let sheetType = sheetTypes.first(where: { $0.id == item.sheetTypeId }),
                      let period = periods.first(where: { $0.id == item.periodId }) else {
                    return nil
                }
                return item.toDomain(period: period, sheetType: sheetType)
            }
            return .success(mappedData)
        }
        if let error = result.1 {
            return .failure(error)
        }
        return .failure(AppError.generalError)
    }
}
