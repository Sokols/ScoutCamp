//
//  EntryField.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import SwiftUI

struct EntryField: View {
    var symbolName: String
    var placeholder: String
    var prompt: String
    @Binding var field: String
    var isSecure = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: symbolName)
                    .foregroundColor(.primaryColor)
                    .font(.headline)
                if isSecure {
                    SecureField(placeholder.localized, text: $field)
                } else {
                    TextField(placeholder.localized, text: $field)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
            }
            .withLoginTextFieldStyle()
            Text(prompt.localized)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 14))
                .foregroundColor(.errorColor)
        }
    }
}

struct EntryField_Previews: PreviewProvider {
    static var previews: some View {
        EntryField(
            symbolName: "person.fill",
            placeholder: "Username",
            prompt: "Enter valid username",
            field: .constant("")
        )
    }
}
