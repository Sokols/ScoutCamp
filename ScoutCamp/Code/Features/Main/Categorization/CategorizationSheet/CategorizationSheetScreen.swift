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
            BaseToolbarView()
            List {
                Text("\(viewModel.sheet.sheet.sheetType.name)")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.vertical)
                ForEach($viewModel.sections, id: \.group) { item in
                    TeamAssignmentsGroupView(
                        section: item,
                        openSharesView: viewModel.showAssignmentSharesInfo
                    )
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
        .sheet(
            isPresented: .constant(viewModel.assignmentToShowSharesInfo != nil),
            onDismiss: hideInfoView,
            content: {
                AssignmentGroupsChartView(assignment: viewModel.assignmentToShowSharesInfo!)
            }
        )
    }

    private func bottomBar() -> some View {
        HStack {
            VStack {
                Text("Points:")
                Text("\(viewModel.points.pointsFormatted)")
                    .font(.system(size: 24, weight: .bold))
            }
            Spacer()
            CategoryAsyncImage(url: viewModel.sheet.category.url)
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

    private func hideInfoView() {
        viewModel.showAssignmentSharesInfo(nil)
    }

    private func navigateBack() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct CategorizationSheetScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategorizationSheetScreen(sheet: TestData.appTeamSheet)
    }
}
