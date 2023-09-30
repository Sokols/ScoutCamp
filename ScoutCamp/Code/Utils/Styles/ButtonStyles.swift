//
//  ButtonStyles.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import SwiftUI

struct MainActionButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.primaryColor)
            .cornerRadius(8)
            .font(.system(size: 20, weight: .bold))
            .shadow(radius: 10, y: 5)
    }
}
