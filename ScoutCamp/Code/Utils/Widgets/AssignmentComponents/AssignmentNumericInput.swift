//
//  AssignmentNumericInput.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct AssignmentNumericInput: View {

    // MARK: - Stored properties
    
    @Binding var value: Decimal
    var title = "Value:"
    var placeholder: String? = "0"
    var prompt: String?

    private var textValue: Binding<String> {
        Binding(get: {
            value.description
        }, set: { newValue in
            guard let decimalValue = Decimal(string: newValue) else { return }
            value = decimalValue
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
    @State var value: Decimal = 0

    return AssignmentNumericInput(value: $value)
}
