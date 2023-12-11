//
//  AssignmentGroupsChartView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 11/12/2023.
//

import SwiftUI

struct AssignmentGroupsChartView: View {
    let assignment: AppAssignment

    var body: some View {
        VStack {
            Text("This assignment affects several task groups. Below you can see how many points go to each group.")
                .multilineTextAlignment(.center)
                .padding()
            ZStack {
                SharesPieChartView(entries: assignment.dataEntries())
                Text("Assignment\ngroups' shares")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .bold))
            }
            .frame(height: 300)
            VStack {
                Text("Total points:")
                Text("\(assignment.points.pointsFormatted)")
                    .font(.system(size: 24, weight: .bold))
            }
        }
    }
}

#Preview {
    AssignmentGroupsChartView(assignment: TestData.numericAppAssignment)
}
