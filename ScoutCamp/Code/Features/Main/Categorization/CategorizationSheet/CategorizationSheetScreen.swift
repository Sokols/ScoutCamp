//
//  CategorizationSheetScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import SwiftUI

struct CategorizationSheetScreen: View {
    @StateObject private var viewModel: CategorizationSheetViewModel

    init(sheetJoint: CategorizationSheetJoint) {
        _viewModel = StateObject(
            wrappedValue: CategorizationSheetViewModel(sheetJoint: sheetJoint)
        )
    }

    var body: some View {
        Text("Categorization Sheet")
    }
}

struct CategorizationSheetScreen_Previews: PreviewProvider {
    private static let joint = CategorizationSheetJoint(
        categorizationSheet: CategorizationSheet(
            id: "",
            periodId: "",
            sheetTypeId: ""
        ),
        teamCategorizationSheet: TeamCategorizationSheet(
            id: "1",
            categorizationSheetId: "1",
            teamId: "1",
            categoryId: "1",
            points: 1,
            isDraft: true,
            createdAt: Date(),
            updatedAt: Date()
        )
    )
    static var previews: some View {
        CategorizationSheetScreen(
            sheetJoint: joint
        )
    }
}
