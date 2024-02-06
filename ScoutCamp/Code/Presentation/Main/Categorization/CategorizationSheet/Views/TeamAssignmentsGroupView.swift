//
//  TeamAssignmentsGroupView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/12/2023.
//

import SwiftUI

struct TeamAssignmentsGroupView: View {
    @Binding var section: AssignmentGroupSection
    let openSharesView: (Assignment) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(section.group.name)
                .font(.title)
            if section.groupMinimums.isEmpty {
                Text("This assignment group doesn't have any minimums.")
            } else {
                Text("Minimums:")
                    .font(.title3)
                HStack {
                    ForEach(section.groupMinimums, id: \.groupMinimumId) { item in
                        getCategoryMinimumView(item)
                    }
                }
            }
            ForEach($section.assignments, id: \.assignmentId) { item in
                TeamAssignmentView(
                    assignment: item,
                    partialAssignmentGroupId: nil,
                    openSharesView: openSharesView
                )
            }
            if !section.partialAssignments.isEmpty {
                Text("Partial points assignments")
                    .font(.title3)
                    .padding(.top)
                ForEach($section.partialAssignments, id: \.assignmentId) { item in
                    TeamAssignmentView(
                        assignment: item,
                        partialAssignmentGroupId: section.group.id,
                        openSharesView: openSharesView
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func getCategoryMinimumView(_ item: AssignmentGroupCategoryMinimum) -> some View {
        VStack {
            CategoryAsyncImage(url: item.category.url)
            if Int(section.totalPoints) >= item.minimumPoints {
                Text("Done")
            } else {
                Text("\(Int(section.totalPoints))/\(item.minimumPoints)")
            }
        }
    }
}

#Preview {
    TeamAssignmentsGroupView(
        section: .constant(TestData.assignmentGroupSection)
    ) {_ in}
}
