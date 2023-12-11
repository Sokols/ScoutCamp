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
                getInputForAssignmentType()
                getMinimumsView()
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
    private func getMinimumsView() -> some View {
        switch assignment.assignmentType {
        case .numeric:
            if let minimums = assignment.minimums {
                ForEach(minimums) { item in
                    HStack {
                        Text("Minimum \(item.minimum.description) for")
                            .font(.system(size: 14, weight: .light))
                        CategoryAsyncImage(url: item.category.url, size: 24)
                    }
                }
            }
        case .boolean:
            if let category = assignment.category {
                HStack {
                    Text("Required for")
                        .font(.system(size: 14, weight: .light))
                    CategoryAsyncImage(url: category.url, size: 24)
                }
            }
        }
        EmptyView()
    }

    @ViewBuilder
    private func getInputForAssignmentType() -> some View {
        switch assignment.assignmentType {
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
