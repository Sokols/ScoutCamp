//
//  TeamAssignmentView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct TeamAssignmentView: View {
    @Binding var assignment: Assignment
    @Binding var teamAssignment: TeamCategorizationSheetAssignment?

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading) {
                Text(assignment.description)
                getInputForAssignmentType(assignment.assignmentType)
            }
            Spacer()
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
        )
    }

    @ViewBuilder
    private func getInputForAssignmentType(_ type: String) -> some View {
        switch AssignmentType(rawValue: type) {
        case .boolean:
            AssignmentCheckbox(isChecked: .constant(teamAssignment?.isCompleted ?? false))
        case .numeric:
            AssignmentNumericInput(value: .constant(teamAssignment?.value))
        default:
            Text("Unknown")
        }
    }
}

struct TeamAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        TeamAssignmentView(
            assignment: .constant(TestData.assignment),
            teamAssignment: .constant(nil)
        )
    }
}
