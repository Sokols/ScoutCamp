//
//  TeamAssignmentView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct TeamAssignmentView: View {
    @Binding var assignment: AppAssignment
    let openSharesView: (AppAssignment) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(assignment.description)
                        .padding()
                    if assignment.doesContainShares {
                        Spacer()
                        Image(systemName: "info.circle")
                            .tint(.primary)
                            .frame(width: 16, height: 16)
                            .padding()
                            .onTapGesture {
                                onInfoClicked()
                            }
                    }
                }
                getInputForAssignmentType()
                    .padding(.horizontal)
                HStack {
                    getMinimumsView()
                        .padding(.horizontal)
                        .padding(.bottom)
                    Spacer()
                    getPointsView()
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            Spacer()
        }
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
            if let nextCategoryMinimum = assignment.nextCategoryMinimumBasedOnPoints {
                HStack {
                    Text("\(nextCategoryMinimum.minimum.pointsFormatted) required for")
                        .font(.system(size: 14, weight: .light))
                    CategoryAsyncImage(url: nextCategoryMinimum.category.url, size: 24)
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

    @ViewBuilder
    private func getPointsView() -> some View {
        HStack(spacing: 0) {
            Text("Points: ")
                .font(.system(size: 14, weight: .light))
            Text("\(assignment.points.pointsFormatted)")
                .font(.system(size: 14, weight: .bold))
            Text("/\(assignment.maxPoints.pointsFormatted)")
                .font(.system(size: 14, weight: .light))
        }
    }

    private func onInfoClicked() {
        openSharesView(assignment)
    }
}

struct TeamAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TeamAssignmentView(assignment: .constant(TestData.booleanAppAssignment)) {_ in}
            TeamAssignmentView(assignment: .constant(TestData.numericAppAssignment)) {_ in}
        }
    }
}
