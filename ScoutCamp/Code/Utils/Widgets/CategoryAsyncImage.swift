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
    var isDraft: Bool = false

    var body: some View {
        ZStack {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)

            } placeholder: {
                Image(systemName: "doc.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if isDraft {
                Circle()
                    .fill(.gray.opacity(0.7))
                Text("DRAFT")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
            }
        }
        .frame(width: size, height: size)
    }

}

#Preview {
    CategoryAsyncImage(
        url: URL.init(string: "https://kategoryzacja.harcerze.zhr.pl/assets/img/harcerze/rz2.png"),
        size: 100,
        isDraft: true
    )
}
