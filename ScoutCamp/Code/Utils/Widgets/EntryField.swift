//
//  EntryField.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import SwiftUI

struct EntryField: View {
    var symbolName: String?
    var title: String?
    var placeholder: String?
    var prompt: String?
    @Binding var field: String
    var isSecure = false

    var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                Text(title)
            }
            HStack {
                if let symbolName = symbolName {
                    Image(systemName: symbolName)
                        .foregroundColor(.primaryColor)
                        .font(.headline)
                }
                getProperField()
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .placeholder(when: field.isEmpty) {
                        if let placeholder {
                            Text(placeholder).foregroundColor(.gray)
                        }
                    }
            }
            .withTextFieldStyle(height: 45)
            if let prompt {
                Text(prompt.localized)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 14))
                    .foregroundColor(.errorColor)
            }
        }
    }

    @ViewBuilder
    private func getProperField() -> some View {
        Group {
            if isSecure {
                SecureField("", text: $field)
            } else {
                TextField("", text: $field)
            }
        }
    }
}

struct EntryField_Previews: PreviewProvider {
    static var previews: some View {
        EntryField(
            symbolName: "person.fill",
            placeholder: "Username",
            field: .constant("")
        )
    }
}
