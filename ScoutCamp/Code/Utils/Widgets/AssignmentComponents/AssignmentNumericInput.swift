//
//  AssignmentNumericInput.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct AssignmentNumericInput: View {

    @Binding var value: Int
    let title = "Value:"

    var body: some View {
        HStack {
            Text(title)
            TextField("", value: $value, formatter: NumberFormatter())
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    @State var value = 0

    return AssignmentNumericInput(value: $value)
}
