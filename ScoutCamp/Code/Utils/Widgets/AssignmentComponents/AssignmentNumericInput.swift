//
//  AssignmentNumericInput.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct AssignmentNumericInput: View {
    @Binding var value: String
    var title = "Value:"
    var placeholder: String? = "0"
    var prompt: String?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                TextField(placeholder ?? "", text: $value)
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
    @State var value = ""

    return AssignmentNumericInput(value: $value)
}
