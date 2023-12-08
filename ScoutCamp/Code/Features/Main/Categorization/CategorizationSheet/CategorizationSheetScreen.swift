//
//  CategorizationSheetScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import SwiftUI

struct CategorizationSheetScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: CategorizationSheetViewModel

    init(sheet: AppTeamSheet) {
        _viewModel = StateObject(
            wrappedValue: CategorizationSheetViewModel(sheet: sheet)
        )
    }

    // MARK: - UI

    var body: some View {
        VStack {
            BaseToolbarView(title: "\(viewModel.sheet.sheet.sheetType.name)")
                .padding(.bottom)
            List {
                ForEach($viewModel.sections, id: \.group) { item in
                    TeamAssignmentsGroupView(section: item)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            Divider()
            bottomBar()
                .padding(.horizontal)
                .padding(.vertical, 8)
        }
        .task {
            await viewModel.fetchData()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onChange(of: viewModel.successfulUpdate) { _ in
            navigateBack()
        }
        .navigationBarBackButtonHidden()
        .errorAlert(error: $viewModel.error)
    }

    private func bottomBar() -> some View {
        HStack {
            Text("Points: \(viewModel.points.pointsFormatted)")
            Spacer()
            Text("Category: \(viewModel.sheet.category.name)")
                .padding(.horizontal)
            Spacer()
            CircleButton(
                systemImageName: "square.and.arrow.down",
                backgroundColor: .white,
                foregroundColor: .secondaryColor,
                strokeColor: .secondaryColor,
                action: saveAsDraft
            )
            CircleButton(
                systemImageName: "checkmark",
                backgroundColor: viewModel.isSheetValid ? .secondaryColor : .gray,
                action: complete
            )
            .disabled(!viewModel.isSheetValid)
        }
    }

    // MARK: - Helpers

    private func saveAsDraft() {
        Task {
            await viewModel.saveAsDraft()
        }
    }

    private func complete() {
        Task {
            await viewModel.complete()
        }
    }

    // MARK: - Navigation

    private func navigateBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct CategorizationSheetScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategorizationSheetScreen(sheet: TestData.appTeamSheet)
    }
}
