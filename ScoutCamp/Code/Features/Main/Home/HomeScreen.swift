//
//  HomeScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/06/2023.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel: HomeViewModel

    init() {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel()
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
        HomeScreen()
    }
}
