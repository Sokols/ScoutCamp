//
//  ProfileScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 28/08/2023.
//

import SwiftUI

struct ProfileScreen<T: ProfileViewModel>: View {
    @StateObject private var viewModel: T

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
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

            Button("Profile.Logout".localized, action: viewModel.signOut)

            Spacer()
        }
    }

    // MARK: - Components

    private func listItem(for item: OptionItem) -> some View {
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
        .onTapGesture {
            item.navigationAction()
        }
    }

    // MARK: - Helpers

    private struct OptionItem: Identifiable {
        var id = UUID()
        var title: String
        var navigationAction: () -> Void
    }

    private var optionItems: [OptionItem] {
        [
            OptionItem(title: "Edit profile", navigationAction: viewModel.navigateToEditProfile),
            OptionItem(title: "Settings", navigationAction: viewModel.navigateToSettings)
        ]
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    class MockViewModel: ProfileViewModel {
        func navigateToEditProfile() {}
        func navigateToSettings() {}
        func signOut() {}
        func deleteAccount() {}

        var error: Error? = nil
    }

    private static var mockViewModel: MockViewModel = MockViewModel()

    static var previews: some View {
        ProfileScreen(viewModel: mockViewModel)
    }
}
