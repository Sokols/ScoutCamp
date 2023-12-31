//
//  CategorizationSheetItemView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/10/2023.
//

import SwiftUI

struct CategorizationSheetItemView: View {
    let item: CategorizationSheetJoint
    let categoryUrl: URL?

    private let radius: CGFloat = 12

    private var sheetType: String {
        SheetTypesService.sheetTypeFor(id: item.categorizationSheet.sheetTypeId)?.name ?? "-"
    }

    private var category: Category? {
        CategoriesService.categoryFor(id: item.teamCategorizationSheet?.categoryId)
    }

    var body: some View {
        HStack {
            AsyncImage(url: categoryUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)

            } placeholder: {
                Image(systemName: "doc.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(maxWidth: 80, alignment: .center)
            .padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text("\(sheetType)")
                    .font(.system(size: 18, weight: .bold))

                if let teamItem = item.teamCategorizationSheet {
                    Text("Category: \(category?.name ?? "-")")
                    Text("Points: \(teamItem.points)")
                    Text("Date: \(teamItem.createdAt.formatted())")
                } else {
                    Text("Fill sheet")
                        .foregroundColor(Color.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: radius)
                                .fill(Color.primaryColor)
                        )
                }
            }
            Spacer()
        }
        .frame(minHeight: 100)
        .padding()
        .cornerRadius(radius)
        .overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(Color.gray, lineWidth: 2)
        )
    }
}

struct CategorizationSheetItemView_Previews: PreviewProvider {
    private static let item = CategorizationSheetJoint(
        categorizationSheet: CategorizationSheet(
            id: "",
            periodId: "",
            sheetTypeId: ""
        ),
        teamCategorizationSheet: TeamCategorizationSheet(
            id: "1",
            categorizationSheetId: "1",
            teamId: "1",
            categoryId: "1",
            points: 1,
            isDraft: true,
            createdAt: Date(),
            updatedAt: Date()
        )
    )

    static var previews: some View {
        CategorizationSheetItemView(item: item, categoryUrl: nil)
    }
}
