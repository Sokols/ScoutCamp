//
//  CategorizationSheetScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import SwiftUI

struct CategorizationSheetScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CategorizationSheetViewModel

    init(sheet: AppTeamSheet) {
        _viewModel = StateObject(
            wrappedValue: CategorizationSheetViewModel(sheet: sheet)
        )
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            BaseToolbarView(backAction: navigateBack)
            Text("\(viewModel.sheet.sheet.sheetType.name)")
                .font(.system(size: 18, weight: .bold))
                .padding(.vertical)
            TabView {
                ForEach($viewModel.sections, id: \.group) { item in
                    sectionView(item)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            Divider()
            bottomBar()
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
        .fullScreenCover(
            item: $viewModel.assignmentToShowSharesInfo,
            content: { item in
                AssignmentGroupsChartView(assignment: item, backAction: hideInfoView)
            }
        )
    }

    private func sectionView(_ item: Binding<AssignmentGroupSection>) -> some View {
        ScrollView(showsIndicators: false) {
            TeamAssignmentsGroupView(
                section: item,
                openSharesView: viewModel.showAssignmentSharesInfo
            )
        }
        .padding(.horizontal)
    }

    private func bottomBar() -> some View {
        HStack {
            VStack {
                Text("Points:")
                Text("\(viewModel.points.pointsFormatted)")
                    .font(.system(size: 24, weight: .bold))
            }
            Spacer()
            CategoryAsyncImage(url: viewModel.expectedCategory?.url)
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
                backgroundColor: .secondaryColor,
                action: complete
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
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

    private func hideInfoView() {
        viewModel.showAssignmentSharesInfo(nil)
    }

    private func navigateBack() {
        dismiss()
    }
}

struct CategorizationSheetScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategorizationSheetScreen(sheet: TestData.appTeamSheet)
    }
}
