//
//  CategorizationSheetViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import Combine
import Foundation

struct CategorizationSheetViewModelActions {
    let navigateBack: () -> Void
}

protocol CategorizationSheetViewModelInput {
    func onLoad() async
    func completeSheet() async
    func saveAsDraft() async
    func navigateBack()
    func showAssignmentSharesInfo(_ assignment: AppAssignment?)
}

protocol CategorizationSheetViewModelOutput: ObservableObject {
    var sections: [AssignmentGroupSection] { get set }
    var assignmentToShowSharesInfo: AppAssignment? { get set }
    var sheet: TeamSheet { get set }

    var error: Error? { get set }
    var isLoading: Bool { get }

    var points: Double { get }
    var expectedCategory: Category? { get }
}

protocol CategorizationSheetViewModel: CategorizationSheetViewModelInput, CategorizationSheetViewModelOutput {}

final class DefaultCategorizationSheetViewModel: CategorizationSheetViewModel {

    private let fetchSectionsUseCase: FetchAssignmentGroupSectionsUseCase
    private let saveTeamSheetUseCase: SaveTeamSheetUseCase
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private let actions: CategorizationSheetViewModelActions

    private var categories: [Category] = []

    // MARK: - OUTPUT

    @Published var sheet: TeamSheet
    @Published var sections: [AssignmentGroupSection] = []
    @Published var assignmentToShowSharesInfo: AppAssignment?
    @Published var error: Error?
    @Published var isLoading = false

    var points: Double {
        let sum = sections.map { $0.totalPoints }.reduce(0, +)
        return sum.isNaN ? 0 : sum
    }

    var expectedCategory: Category? {
        var category = categories.last
        let expectedCategories = sections
            .compactMap { $0.getHighestPossibleCategory(from: categories) }
            .sorted(by: {$0.order < $1.order })
        if let first = expectedCategories.first {
            category = first
        }
        return category
    }

    // MARK: - Computed properties

    private var appAssignments: [AppAssignment] {
        var assignments: [AppAssignment] = []
        sections.forEach {
            assignments.append(contentsOf: $0.assignments)
        }
        return assignments
    }

    // MARK: - Initialization

    init(
        fetchSectionsUseCase: FetchAssignmentGroupSectionsUseCase,
        saveTeamSheetUseCase: SaveTeamSheetUseCase,
        fetchCategoriesUseCase: FetchCategoriesUseCase,
        actions: CategorizationSheetViewModelActions,
        sheet: TeamSheet
    ) {
        self.fetchSectionsUseCase = fetchSectionsUseCase
        self.saveTeamSheetUseCase = saveTeamSheetUseCase
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.actions = actions
        self.sheet = sheet
    }

    // MARK: - Data handling

    @MainActor
    private func fetchSections() async {
        let requestValue = FetchSectionsUseCaseRequestValue(teamSheet: sheet)
        let result = await fetchSectionsUseCase.execute(requestValue: requestValue)

        switch result {
        case .success(let success):
            self.sections = success.sections
        case .failure(let error):
            self.error = error
        }
    }

    @MainActor
    private func fetchCategories() async {
        let result = await fetchCategoriesUseCase.execute()

        switch result {
        case .success(let success):
            self.categories = success.categories
        case .failure(let error):
            self.error = error
        }
    }

    @MainActor
    private func createUpdateTeamSheet(isDraft: Bool) async {
        guard let newAppSheet = generateAppTeamSheet(isDraft: isDraft) else { return }
        let requestValue = SaveTeamSheetUseCaseRequestValue(
            teamSheet: newAppSheet,
            assignments: appAssignments,
            isDraft: isDraft
        )
        let result = await saveTeamSheetUseCase.execute(requestValue: requestValue)
        if let error = result {
            self.error = error
        } else {
            actions.navigateBack()
        }
    }

    // MARK: - Helpers

    private func generateAppTeamSheet(isDraft: Bool) -> TeamSheet? {
        guard let category = expectedCategory else { return nil }
        return TeamSheet(
            teamSheetId: sheet.teamSheetId,
            sheet: sheet.sheet,
            team: sheet.team,
            category: category,
            points: points,
            isDraft: isDraft,
            createdAt: sheet.createdAt,
            updatedAt: .now
        )
    }
}

extension DefaultCategorizationSheetViewModel {
    @MainActor
    func onLoad() async {
        isLoading = true
        async let categories: () = fetchCategories()
        async let sections: () = fetchSections()
        (_, _) = await (categories, sections)
        isLoading = false
    }

    func completeSheet() async {
        await createUpdateTeamSheet(isDraft: false)
    }

    func saveAsDraft() async {
        await createUpdateTeamSheet(isDraft: true)
    }

    func navigateBack() {
        actions.navigateBack()
    }

    func showAssignmentSharesInfo(_ assignment: AppAssignment?) {
        assignmentToShowSharesInfo = assignment
    }
}
