//
//  CategorizationSheetsCarouselView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 31/10/2023.
//

import SwiftUI

struct CategorizationSheetsCarouselView: View {
    let assignmentsService: AssignmentsServiceProtocol
    let teamAssignmentsService: TeamCategorizationSheetAssignmentsServiceProtocol

    @Binding var junctions: [CategorizationSheetJunction]

    var body: some View {
        VStack {
            TabView {
                ForEach(junctions, id: \.self) { item in
                    NavigationLink(destination: CategorizationSheetScreen(
                        sheetJunction: item,
                        assignmentsService: assignmentsService,
                        teamAssignmentsService: teamAssignmentsService
                    )) {
                        CategorizationSheetItemView(item: item, categoryUrl: nil)
                            .padding(.horizontal)
                    }
                    .foregroundColor(Color.primaryColor)
                }
            }
            .frame(maxHeight: 225)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct CategorizationSheetsCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CategorizationSheetsCarouselView(
            assignmentsService: AssignmentsService(),
            teamAssignmentsService: TeamCategorizationSheetAssignmentsService(),
            junctions: .constant(TestData.categorizationSheetJunctions)
        )
    }
}
