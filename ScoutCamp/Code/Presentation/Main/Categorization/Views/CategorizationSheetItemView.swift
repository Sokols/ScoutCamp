//
//  CategorizationSheetItemView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/10/2023.
//

import SwiftUI

struct CategorizationSheetItemView: View {
    let item: TeamSheet

    private let radius: CGFloat = 12

    var body: some View {
        HStack {
            CategoryAsyncImage(url: item.category?.url, size: 80, isDraft: item.isDraft)
                .padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text("\(item.sheet.sheetType.name)")
                    .font(.system(size: 18, weight: .bold))

                if item.teamSheetId != nil {
                    Text("Category: \(item.category?.name ?? "-")")
                    Text("Points: \(item.points.pointsFormatted)")
                    Text("Updated: \(item.updatedAt.sheetDate)")
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
        CategorizationSheetItemView(item: TestData.appTeamSheet)
    }
}
