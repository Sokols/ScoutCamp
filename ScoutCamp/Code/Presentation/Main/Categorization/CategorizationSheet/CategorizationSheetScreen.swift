//
//  CategorizationSheetScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import SwiftUI

struct CategorizationSheetScreen<T: CategorizationSheetViewModel>: View {
    @StateObject private var viewModel: T

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            BaseToolbarView(backAction: viewModel.navigateBack)
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
            await viewModel.onLoad()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarHidden(true)
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
                action: completeSheet
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

    private func completeSheet() {
        Task {
            await viewModel.completeSheet()
        }
    }

    // MARK: - Navigation

    private func hideInfoView() {
        viewModel.showAssignmentSharesInfo(nil)
    }
}

struct CategorizationSheetScreen_Previews: PreviewProvider {
    class MockViewModel: CategorizationSheetViewModel {
        func onLoad() async {}
        func completeSheet() async {}
        func saveAsDraft() async {}
        func navigateBack() {}
        func showAssignmentSharesInfo(_ assignment: AppAssignment?) {}
        
        var sections: [AssignmentGroupSection] = []
        var assignmentToShowSharesInfo: AppAssignment?
        var sheet: TeamSheet = TestData.appTeamSheet
        var error: Error?
        var isLoading: Bool = false
        var appAssignments: [AppAssignment] = []
        var points: Double = 0.0
        var expectedCategory: Category?
    }

    private static var mockViewModel: MockViewModel = MockViewModel()

    static var previews: some View {
        CategorizationSheetScreen(viewModel: mockViewModel)
    }
}
