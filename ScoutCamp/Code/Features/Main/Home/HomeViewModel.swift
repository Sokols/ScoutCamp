//
//  HomeViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/10/2023.
//

import Combine
import Foundation

@MainActor
class HomeViewModel: ObservableObject {

    @Service private var sheetTypesService: SheetTypesServiceProtocol
    @Service private var categoriesService: CategoriesServiceProtocol
    @Service private var categorizationPeriodsService: CategorizationPeriodsServiceProtocol
    @Service private var categorizationSheetsService: CategorizationSheetsServiceProtocol
    @Service private var assignmentGroupsService: AssignmentGroupsServiceProtocol
    @Service private var storageManager: StorageManagerProtocol

    @Published var error: Error?
    @Published var isLoading = false

    // MARK: Public

    func fetchStaticData() async {
        isLoading = true
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.fetchCategories()
            }
            group.addTask {
                await self.fetchSheetTypes()
            }
            group.addTask {
                await self.fetchAssignmentGroups()
            }
            group.addTask {
                await self.fetchCategorizationSheets()
            }
            group.addTask {
                await self.fetchCategorizationPeriods()
            }
            group.addTask {
                await self.fetchCategorizationPeriods()
            }
        }
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
        } else {
            await fetchCategoryUrls()
        }
    }

    private func fetchAssignmentGroups() async {
        let result = await assignmentGroupsService.getAssignmentGroups()
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

    private func fetchCategoryUrls() async {
        let categories = CategoriesService.categories
        do {
            var urls: [String: URL] = [:]
            for category in categories {
                let url = try await storageManager.getImageRef(path: category.imagePath)
                urls[category.id] = url
            }
            categoriesService.setupCategoryUrls(urls)
        } catch {
            self.error = error
        }
    }
}
