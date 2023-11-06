//
//  CategorizationSheetScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import SwiftUI

struct CategorizationSheetScreen: View {
    @StateObject private var viewModel: CategorizationSheetViewModel

    init(
        sheetJoint: CategorizationSheetJoint,
        assignmentsService: AssignmentsServiceProtocol,
        categorizationSheetAssignmentsService: CategorizationSheetAssignmentsServiceProtocol,
        teamCategorizationSheetAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: CategorizationSheetViewModel(
                sheetJoint: sheetJoint,
                assignmentsService: assignmentsService,
                categorizationSheetAssignmentsService: categorizationSheetAssignmentsService,
                teamCategorizationSheetAssignmentsService: teamCategorizationSheetAssignmentsService
            )
        )
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.assignmentJoints, id: \.self) { item in
                    Text(item.assignment.description)
                }
            }
            HStack {
                Spacer()
                Text("CategorizationSheetScreen")
                Spacer()
            }
        }.task {
            await viewModel.fetchAssignments()
        }
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
            sheetJoint: joint,
            assignmentsService: AssignmentsService(),
            categorizationSheetAssignmentsService: CategorizationSheetAssignmentsService(),
            teamCategorizationSheetAssignmentsService: TeamCategorizationSheetAssignmentsService()
        )
    }
}
