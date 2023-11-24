//
//  CategorizationSheetItemView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/10/2023.
//

import SwiftUI

struct CategorizationSheetItemView: View {
    let item: CategorizationSheetJunction
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
                    Text("Date: \(teamItem.createdAt.sheetDate)")
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
    static var previews: some View {
        CategorizationSheetItemView(
            item: TestData.categorizationSheetJunction,
            categoryUrl: nil
        )
    }
}
