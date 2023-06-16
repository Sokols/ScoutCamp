//
//  View+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import SwiftUI

extension View {
    func withLoginTextFieldStyle() -> some View {
        return self.padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
            .foregroundColor(.primaryColor)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                    .opacity(0.8)
                    .shadow(radius: 10, y: 10)
            )
    }
}
