//
//  CategorizationSheetItemView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/10/2023.
//

import SwiftUI

struct CategorizationSheetItemView: View {
    let item: TeamCategorizationSheet
    let categoryUrl: URL?

    private let radius: CGFloat = 12

    private var sheet: CategorizationSheet? {
        CategorizationSheetsService.categorizationSheetFor(id: item.categorizationSheetId)
    }

    private var sheetType: String {
        SheetTypesService.sheetTypeFor(id: sheet?.sheetTypeId)
    }

    private var category: Category? {
        CategoriesService.categoryFor(id: item.categoryId)
    }

    var body: some View {
        HStack {
            AsyncImage(url: categoryUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)

            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: 80, alignment: .center)
            VStack(alignment: .leading) {
                Text("\(sheetType)")
                    .font(.system(size: 18, weight: .bold))
                Text("Category: \(category?.name ?? "-")")
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
        CategorizationSheetItemView(item: item, categoryUrl: nil)
    }
}
