//
//  View+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "General.Ok") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle.localized) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion?.localized ?? "")
        }
    }

    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}
