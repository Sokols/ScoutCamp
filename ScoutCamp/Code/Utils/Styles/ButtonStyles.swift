//
//  ButtonStyles.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import SwiftUI

struct MainActionButton: ButtonStyle {
    var isDisabled = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(isDisabled ? Color.gray : Color.primaryColor)
            .cornerRadius(8)
            .font(.system(size: 20, weight: .bold))
    }
}
