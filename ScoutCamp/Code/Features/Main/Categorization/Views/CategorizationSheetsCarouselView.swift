//
//  CategorizationSheetsCarouselView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 31/10/2023.
//

import SwiftUI

struct CategorizationSheetsCarouselView: View {
    @Binding var sheets: [TeamCategorizationSheet]

    var body: some View {
        VStack {
            TabView {
                ForEach(sheets, id: \.self) { item in
                    CategorizationSheetItemView(item: item, categoryUrl: nil)
                        .padding(.horizontal)
                }
            }
            .frame(maxHeight: 225)
            .tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct CategorizationSheetsCarouselView_Previews: PreviewProvider {
    private static let sheets = [
        TeamCategorizationSheet(
            id: "test_id",
            categorizationSheetId: "test_id",
            teamId: "test_id",
            categoryId: "test_id",
            points: 0,
            isDraft: true,
            createdAt: .now,
            updatedAt: .now
        ),
        TeamCategorizationSheet(
            id: "test_id",
            categorizationSheetId: "test_id",
            teamId: "test_id",
            categoryId: "test_id",
            points: 0,
            isDraft: true,
            createdAt: .now,
            updatedAt: .now
        ),
        TeamCategorizationSheet(
            id: "test_id",
            categorizationSheetId: "test_id",
            teamId: "test_id",
            categoryId: "test_id",
            points: 0,
            isDraft: true,
            createdAt: .now,
            updatedAt: .now
        )
    ]
    static var previews: some View {
        CategorizationSheetsCarouselView(sheets: .constant(sheets))
    }
}
