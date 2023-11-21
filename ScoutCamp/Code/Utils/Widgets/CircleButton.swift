//
//  CircleButton.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 07/11/2023.
//

import SwiftUI

struct CircleButton: View {
    let systemImageName: String
    let backgroundColor: Color
    let foregroundColor: Color
    let strokeColor: Color?
    let action: () -> Void

    init(
        systemImageName: String,
        backgroundColor: Color = Color.secondaryColor,
        foregroundColor: Color = Color.white,
        strokeColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.systemImageName = systemImageName
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.strokeColor = strokeColor
        self.action = action
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(strokeColor ?? backgroundColor, lineWidth: 1)
                .background(Circle().foregroundColor(backgroundColor))
            Button(action: {
                print("Circular Button tapped")
            }, label: {
                Image(systemName: systemImageName)
                    .foregroundColor(foregroundColor)
            })
            .padding()
        }
        .fixedSize()
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(systemImageName: "checkmark", action: {})
    }
}
