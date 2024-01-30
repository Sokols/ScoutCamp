//
//  TeamAssignmentsGroupView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/12/2023.
//

import SwiftUI

struct TeamAssignmentsGroupView: View {
    @Binding var section: AssignmentGroupSection
    let openSharesView: (AppAssignment) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(section.group.name)
                .font(.title)
            HStack {
                ForEach(section.groupMinimums, id: \.groupMinimumId) { item in
                    getCategoryMinimumView(item)
                }
            }
            ScrollView {
                ForEach($section.assignments, id: \.assignmentId) { item in
                    TeamAssignmentView(assignment: item, openSharesView: openSharesView)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
    }

    @ViewBuilder
    private func getCategoryMinimumView(_ item: AppGroupMinimum) -> some View {
        VStack {
            CategoryAsyncImage(url: item.category.url)
            if Int(section.totalPoints) >= item.minimumPoints {
                Text("Complete")
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
