//
//  CategorizationSheetsCarouselView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 31/10/2023.
//

import SwiftUI

struct CategorizationSheetsCarouselView: View {
    let sheets: [AppTeamSheet]

    var body: some View {
        VStack {
            TabView {
                ForEach(sheets, id: \.self) { item in
                    NavigationLink(destination: CategorizationSheetScreen(sheet: item)) {
                        CategorizationSheetItemView(item: item)
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
            sheets: [TestData.appTeamSheet]
        )
    }
}
