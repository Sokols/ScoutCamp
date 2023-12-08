//
//  TeamAssignmentsGroupView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/12/2023.
//

import SwiftUI

struct TeamAssignmentsGroupView: View {

    @Binding var section: AssignmentGroupSection

    var body: some View {
        DisclosureGroup(section.group.name) {
            ForEach($section.assignments, id: \.assignmentId) { item in
                TeamAssignmentView(assignment: item)
            }
            .listRowSeparator(.hidden)
        }
        .foregroundColor(.primaryColor)
    }
}

#Preview {
    TeamAssignmentsGroupView(
        section: .constant(TestData.assignmentGroupSection)
    )
}
