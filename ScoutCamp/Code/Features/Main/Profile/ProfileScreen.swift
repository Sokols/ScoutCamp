//
//  ProfileScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 28/08/2023.
//

import SwiftUI

struct ProfileScreen: View {
    @StateObject private var viewModel: ProfileViewModel

    init(authService: AuthService) {
        _viewModel = StateObject(
            wrappedValue: ProfileViewModel(authService: authService)
        )
        UIScrollView.appearance().bounces = false
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64, height: 64)
                    .padding(24)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Test User")
                        .font(.title)
                    Text("Role: User")
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)

            List {
                ForEach(optionItems) { item in
                    listItem(for: item)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .padding(.vertical)
            .frame(maxHeight: 250)

            Button("Profile.Logout".localized, action: viewModel.logOut)

            Spacer()
        }
    }

    // MARK: - Components

    private func listItem(for item: OptionItem) -> some View {
        ZStack {
            VStack {
                HStack {
                    Text(item.title)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.vertical, 8)
                Color.backgroundColor
                    .frame(height: 1)
            }
            NavigationLink(destination: item.navigationScreen) {
                EmptyView()
            }
            .opacity(0)
        }
    }

    // MARK: - Helpers

    private struct OptionItem: Identifiable {
        var id = UUID()
        var title: String
        var navigationScreen: AnyView
    }

    private var optionItems: [OptionItem] {
        [
            OptionItem(title: "Edit profile", navigationScreen: AnyView(Text("Edit profile"))),
            OptionItem(title: "Settings", navigationScreen: AnyView(Text("Settings")))
        ]
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(authService: AuthService())
    }
}
