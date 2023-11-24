//
//  AssignmentCheckbox.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/11/2023.
//

import SwiftUI

struct AssignmentCheckbox: View {
    @Binding var isChecked: Bool
    let title = "Done:"

    var body: some View {
        Toggle(isOn: $isChecked) {
            Text(title)
        }
        .toggleStyle(CheckboxToggleStyle())
    }
}

#Preview {
    @State var isChecked = false

    return AssignmentCheckbox(isChecked: $isChecked)
}
