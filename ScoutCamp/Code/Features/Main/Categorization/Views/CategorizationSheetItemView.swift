//
//  CategorizationSheetItemView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/10/2023.
//

import SwiftUI

struct CategorizationSheetItemView: View {
    let item: TeamCategorizationSheet

    private let radius: CGFloat = 12

    private var sheet: CategorizationSheet? {
        CategorizationSheetsService.categorizationSheetFor(id: item.categorizationSheetId)
    }

    private var sheetType: String {
        SheetTypesService.sheetTypeFor(id: sheet?.sheetTypeId)
    }

    private var category: String {
        CategoriesService.categoryFor(id: item.categoryId)
    }

    var body: some View {
        HStack {
            Image(systemName: "doc.fill")
                .resizable()
                .frame(width: 32, height: 36)
                .padding()
            VStack(alignment: .leading) {
                Text("Sheet type: \(sheetType)")
                Text("Category: \(category)")
                Text("Points: \(item.points)")
                Text("Date: \(item.createdAt.formatted())")
            }
            Spacer()
        }
        .padding()
        .cornerRadius(radius)
        .overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(Color.gray, lineWidth: 2)
        )
    }
}

struct CategorizationSheetItemView_Previews: PreviewProvider {
    private static let item = TeamCategorizationSheet(
        id: "1",
        categorizationSheetId: "1",
        teamId: "1",
        categoryId: "1",
        points: 1,
        isDraft: true,
        createdAt: Date(),
        updatedAt: Date()
    )

    static var previews: some View {
        CategorizationSheetItemView(item: item)
    }
}
