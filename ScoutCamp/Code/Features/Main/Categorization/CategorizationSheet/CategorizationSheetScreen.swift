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
        teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: CategorizationSheetViewModel(
                sheetJoint: sheetJoint,
                assignmentsService: assignmentsService,
                teamAssignmentsService: teamAssignmentsService
            )
        )
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.assignmentJoints, id: \.self) { item in
                    VStack {
                        Text(item.assignment.description)
                        Text("Done: \(item.teamAssignment?.id ?? "-")")
                    }
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
            teamAssignmentsService: TeamCategorizationSheetAssignmentsService()
        )
    }
}
