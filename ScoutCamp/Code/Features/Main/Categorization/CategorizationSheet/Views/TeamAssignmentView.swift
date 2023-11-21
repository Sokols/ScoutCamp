//
//  TeamAssignmentView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct TeamAssignmentView: View {
    let junction: TeamAssignmentJunction

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading) {
                Text(junction.assignment.description)
                getInputForAssignmentType(junction.assignment.assignmentType)
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

    private func getInputForAssignmentType(_ type: String) -> some View {
        switch AssignmentType(rawValue: type) {
        case .boolean:
            return Text("Boolean")
        case .numeric:
            return Text("Numeric")
        default:
            return Text("Unknown")
        }
    }
}

struct TeamAssignmentView_Previews: PreviewProvider {
    private static let junction = TeamAssignmentJunction(
        assignment: Assignment(
            id: "",
            categoryId: "",
            mainAssignmentGroupId: "",
            categorizationSheetId: "",
            assignmentType: "numeric",
            description: "TEST DESCRIPTION",
            maxPoints: 5,
            maxScoringValue: nil,
            minimums: nil
        )
    )

    static var previews: some View {
        TeamAssignmentView(junction: junction)
    }
}
