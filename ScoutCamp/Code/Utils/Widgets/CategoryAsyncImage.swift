//
//  CategoryAsyncImage.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/12/2023.
//

import SwiftUI

struct CategoryAsyncImage: View {

    let url: URL?
    var size: CGFloat = 50

    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)

        } placeholder: {
            Image(systemName: "doc.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: size, height: size)
    }

}
