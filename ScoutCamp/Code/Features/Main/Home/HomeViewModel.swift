//
//  HomeViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/10/2023.
//

import Combine

@MainActor
class HomeViewModel: ObservableObject {

    private let sheetTypesService: SheetTypesServiceProtocol
    private let categoriesService: CategoriesServiceProtocol
    private let categorizationPeriodsService: CategorizationPeriodsServiceProtocol
    private let categorizationSheetsService: CategorizationSheetsServiceProtocol

    @Published var error: Error?
    @Published var isLoading = false

    init(
        sheetTypesService: SheetTypesServiceProtocol,
        categoriesService: CategoriesServiceProtocol,
        categorizationPeriodsService: CategorizationPeriodsServiceProtocol,
        categorizationSheetsService: CategorizationSheetsServiceProtocol
    ) {
        self.sheetTypesService = sheetTypesService
        self.categoriesService = categoriesService
        self.categorizationPeriodsService = categorizationPeriodsService
        self.categorizationSheetsService = categorizationSheetsService
    }

    func fetchStaticData() async {
        isLoading = true
        await fetchSheetTypes()
        await fetchCategories()
        await fetchCategorizationPeriods()
        await fetchCategorizationSheets()
        isLoading = false
    }

    // MARK: - Private methods

    private func fetchSheetTypes() async {
        let result = await sheetTypesService.getSheetTypes()
        if let error = result.1 {
            self.error = error
        }
    }

    private func fetchCategories() async {
        let result = await categoriesService.getCategories()
        if let error = result.1 {
            self.error = error
        }
    }

    private func fetchCategorizationPeriods() async {
        let result = await categorizationPeriodsService.getCategorizationPeriods()
        if let error = result.1 {
            self.error = error
        }
    }

    private func fetchCategorizationSheets() async {
        let result = await categorizationSheetsService.getCategorizationSheets()
        if let error = result.1 {
            self.error = error
        }
    }
}
