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
    var prompt: String
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
                Group {
                    if isSecure {
                        SecureField("", text: $field)
                    } else {
                        TextField("", text: $field)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                    }
                }
                .placeholder(when: field.isEmpty && placeholder != nil) {
                    Text(placeholder!)
                        .foregroundColor(.gray)
                }
            }
            .withLoginTextFieldStyle(height: 45)
            Text(prompt.localized)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 14))
                .foregroundColor(.errorColor)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
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
