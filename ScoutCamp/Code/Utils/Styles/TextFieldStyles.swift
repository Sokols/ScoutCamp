//
//  TextFieldStyles.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 09/10/2023.
//

import SwiftUI

extension View {
    func withTextFieldStyle(height: CGFloat? = nil) -> some View {
        let radius: CGFloat = 5
        return self
            .padding(.horizontal, 8)
            .foregroundColor(.primaryColor)
            .cornerRadius(radius)
            .if(height != nil) { view in
                view.frame(height: height)
            }
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .background(
                RoundedRectangle(cornerRadius: radius).fill(Color.white)
            )
    }
}
