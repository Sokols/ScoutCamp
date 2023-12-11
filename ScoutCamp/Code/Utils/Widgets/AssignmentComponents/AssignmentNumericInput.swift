//
//  AssignmentNumericInput.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct AssignmentNumericInput: View {

    // MARK: - Stored properties

    @Binding var value: Double
    var title = "Value:"
    var placeholder: String? = "0"
    var prompt: String?

    private var textValue: Binding<String> {
        Binding(get: {
            value.pointsFormatted
        }, set: { newValue in
            let validValue = newValue.isEmpty ? "0" : newValue
            guard let doubleValue = Double(validValue) else { return }
            value = doubleValue
        })
    }

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                TextField(placeholder ?? "", text: textValue)
                    .keyboardType(.numberPad)
                    .withTextFieldStyle(height: 45)
            }
            if let prompt {
                Text(prompt.localized)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 14))
                    .foregroundColor(.errorColor)
            }
        }
    }
}

#Preview {
    @State var value: Double = 0

    return AssignmentNumericInput(value: $value)
}
