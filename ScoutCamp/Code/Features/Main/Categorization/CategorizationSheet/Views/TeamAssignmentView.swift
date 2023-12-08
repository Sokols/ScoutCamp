//
//  TeamAssignmentView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct TeamAssignmentView: View {
    @Binding var assignment: AppAssignment

    var body: some View {
        HStack {
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
    private func getInputForAssignmentType(_ type: AssignmentType) -> some View {
        switch type {
        case .boolean:
            AssignmentCheckbox(isChecked: $assignment.isCompleted)
        case .numeric:
            AssignmentNumericInput(
                value: $assignment.value,
                prompt: assignment.errorPrompt
            )
        }
    }
}

struct TeamAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TeamAssignmentView(assignment: .constant(TestData.booleanAppAssignment))
            TeamAssignmentView(assignment: .constant(TestData.numericAppAssignment))
        }
    }
}
