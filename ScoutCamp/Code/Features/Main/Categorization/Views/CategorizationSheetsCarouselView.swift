//
//  CategorizationSheetsCarouselView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 31/10/2023.
//

import SwiftUI

struct CategorizationSheetsCarouselView: View {
    let assignmentsService: AssignmentsServiceProtocol
    let teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol

    @Binding var joints: [CategorizationSheetJoint]

    var body: some View {
        VStack {
            TabView {
                ForEach(joints, id: \.self) { item in
                    NavigationLink(destination: CategorizationSheetScreen(
                        sheetJoint: item,
                        assignmentsService: assignmentsService,
                        teamAssignmentsService: teamAssignmentsService
                    )) {
                        CategorizationSheetItemView(item: item, categoryUrl: nil)
                            .padding(.horizontal)
                    }
                    .foregroundColor(Color.primaryColor)
                }
            }
            .frame(maxHeight: 225)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct CategorizationSheetsCarouselView_Previews: PreviewProvider {
    private static let joints = [
        CategorizationSheetJoint(
            categorizationSheet: CategorizationSheet(
                id: "",
                periodId: "",
                sheetTypeId: ""
            ),
            teamCategorizationSheet: TeamCategorizationSheet(
                id: "test_id",
                categorizationSheetId: "test_id",
                teamId: "test_id",
                categoryId: "test_id",
                points: 0,
                isDraft: true,
                createdAt: .now,
                updatedAt: .now
            )
        ),
        CategorizationSheetJoint(
            categorizationSheet: CategorizationSheet(
                id: "",
                periodId: "",
                sheetTypeId: ""
            ),
            teamCategorizationSheet: TeamCategorizationSheet(
                id: "test_id",
                categorizationSheetId: "test_id",
                teamId: "test_id",
                categoryId: "test_id",
                points: 0,
                isDraft: true,
                createdAt: .now,
                updatedAt: .now
            )
        )
    ]
    static var previews: some View {
        CategorizationSheetsCarouselView(
            assignmentsService: AssignmentsService(),
            teamAssignmentsService: TeamCategorizationSheetAssignmentsService(),
            joints: .constant(joints)
        )
    }
}
