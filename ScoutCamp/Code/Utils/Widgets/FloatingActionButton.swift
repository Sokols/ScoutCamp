//
//  FloatingActionButton.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import SwiftUI

struct FloatingActionButton: View {
    var body: some View {
        Image(systemName: "plus")
            .font(.title.weight(.semibold))
            .padding()
            .background(Color.secondaryColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: 4, x: 0, y: 4)
    }
}

struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionButton()
    }
}
