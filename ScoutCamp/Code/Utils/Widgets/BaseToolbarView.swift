//
//  BaseToolbarView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 07/11/2023.
//

import SwiftUI

struct BaseToolbarView: View {    
    @Environment(\.dismiss) private var dismiss
    var title: String?
    var backAction: (() -> Void)?

    var body: some View {
        ZStack {
            if let title = title {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
            }
            HStack {
                Button(action: {
                    if let backAction = backAction {
                        backAction()
                    } else {
                        dismiss()
                    }
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .padding(.leading)
                        Text("Back")
                    }
                })
                Spacer()
            }
        }
        .padding(.top)
        .foregroundColor(Color.primaryColor)
    }
}

struct BaseToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        BaseToolbarView(title: "Toolbar")
    }
}
