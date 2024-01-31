//
//  CenterModifier.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 21/11/2023.
//

import SwiftUI

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
} 
