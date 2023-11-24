//
//  CategorizationSheetScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import SwiftUI

struct CategorizationSheetScreen: View {
    @StateObject private var viewModel: CategorizationSheetViewModel

    init(sheet: AppTeamSheet) {
        _viewModel = StateObject(
            wrappedValue: CategorizationSheetViewModel(sheet: sheet)
        )
    }

    var body: some View {
        VStack {
            BaseToolbarView(title: "\(viewModel.sheet.sheet.sheetType.name)")
                .padding(.bottom)
            List {
                ForEach($viewModel.appAssignments, id: \.assignmentId) { item in
                    TeamAssignmentView(assignment: item)
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
        .navigationBarBackButtonHidden()
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
            CircleButton(systemImageName: "checkmark", action: complete)
        }
    }

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
}

struct CategorizationSheetScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategorizationSheetScreen(sheet: TestData.appTeamSheet)
    }
}
