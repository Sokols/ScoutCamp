//
//  HomeScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/06/2023.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel: HomeViewModel

    init(
        sheetTypesService: SheetTypesServiceProtocol,
        categoriesService: CategoriesServiceProtocol,
        categorizationPeriodsService: CategorizationPeriodsServiceProtocol,
        categorizationSheetsService: CategorizationSheetsServiceProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(
                sheetTypesService: sheetTypesService,
                categoriesService: categoriesService,
                categorizationPeriodsService: categorizationPeriodsService,
                categorizationSheetsService: categorizationSheetsService
            )
        )
    }

    var body: some View {
        ZStack {
            Text("Home.Name".localized)
        }
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .onLoad {
            Task {
                await viewModel.fetchStaticData()
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(
            sheetTypesService: SheetTypesService(),
            categoriesService: CategoriesService(),
            categorizationPeriodsService: CategorizationPeriodsService(),
            categorizationSheetsService: CategorizationSheetsService()
        )
    }
}
