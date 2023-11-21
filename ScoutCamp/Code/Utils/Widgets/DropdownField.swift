//
//  DropdownField.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 09/10/2023.
//

import SwiftUI

struct DropdownOption: Hashable {
    let key: String
    let value: String

    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }
}

private struct DropdownRow: View {
    var option: DropdownOption
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }, label: {
            HStack {
                Text(self.option.value)
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                Spacer()
            }
        })
        .background(Color.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}

private struct Dropdown: View {
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                }
            }
        }
        .frame(minHeight: CGFloat(options.count) * 30, maxHeight: 250)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct DropdownField: View {
    @State private var shouldShowDropdown = false
    var title: String
    var placeholder: String
    var options: [DropdownOption]
    @Binding var selectedOption: DropdownOption?
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    private let buttonHeight: CGFloat = 45

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Button(action: {
                if !options.isEmpty {
                    self.shouldShowDropdown.toggle()
                }
            }, label: {
                HStack {
                    Text(selectedOption == nil ? placeholder : selectedOption!.value)
                        .foregroundColor(selectedOption == nil ? Color.gray: Color.black)

                    Spacer()

                    Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 9, height: 5)
                        .font(Font.system(size: 9, weight: .medium))
                        .foregroundColor(Color.black)
                }
            })
            .withTextFieldStyle(height: buttonHeight)
            .overlay(
                VStack {
                    if self.shouldShowDropdown {
                        Spacer(minLength: buttonHeight + 10)
                        Dropdown(options: self.options, onOptionSelected: { option in
                            shouldShowDropdown = false
                            selectedOption = option
                            self.onOptionSelected?(option)
                        })
                    }
                }, alignment: .topLeading
            )
        }
    }
}

struct DropdownField_Previews: PreviewProvider {

    private static let options: [DropdownOption] = [
        DropdownOption(key: "lubelska", value: "Lubelska"),
        DropdownOption(key: "mazowiecka", value: "Mazowiecka"),
        DropdownOption(key: "dolnoslaska", value: "Dolnośląska")
    ]

    static var previews: some View {
        VStack(spacing: 20) {
            DropdownField(
                title: "Regiment",
                placeholder: "Select regiment",
                options: options,
                selectedOption: .constant(nil),
                onOptionSelected: {_ in}
            )
            .padding(.horizontal)
            .zIndex(1)
        }
    }
}
