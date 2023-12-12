//
//  AssignmentGroupsChartView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 11/12/2023.
//

import SwiftUI

struct AssignmentGroupsChartView: View {
    let assignment: AppAssignment
    let backAction: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .tint(.primary)
                    .padding()
                    .onTapGesture {
                        backAction()
                    }
            }
            Spacer()
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
            if assignment.points > 0 {
                VStack {
                    Text("Total points:")
                    Text("\(assignment.points.pointsFormatted)")
                        .font(.system(size: 24, weight: .bold))
                }
            }
            Spacer()
        }
    }
}

#Preview {
    AssignmentGroupsChartView(assignment: TestData.numericAppAssignment) {}
}
