//
//  CategorizationSheetViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import Combine

@MainActor
class CategorizationSheetViewModel: ObservableObject {

    @Published var error: Error?
    @Published var isLoading = false

    private let sheetJoint: CategorizationSheetJoint
    private let categorizationAssignmentsService: CategorizationAssignmentsServiceProtocol
    private let isInitialFill: Bool

    init(
        sheetJoint: CategorizationSheetJoint,
        categorizationAssignmentsService: CategorizationAssignmentsServiceProtocol
    ) {
        self.sheetJoint = sheetJoint
        self.categorizationAssignmentsService = categorizationAssignmentsService

        isInitialFill = sheetJoint.teamCategorizationSheet == nil
    }

    func fetchAssignments() async {
        isLoading = true
        let result = await categorizationAssignmentsService.getCategorizationAssignments()
        isLoading = false
        if let error = result.1 {
            self.error = error
        } else if let assignments = result.0 {
            // TODO: Finish fetching data
        }
    }
}
