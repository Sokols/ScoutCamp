//
//  CategorizationSheetScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import SwiftUI

struct CategorizationSheetScreen: View {
    @StateObject private var viewModel: CategorizationSheetViewModel

    init(team: Team) {
        _viewModel = StateObject(
            wrappedValue: CategorizationSheetViewModel(team: team)
        )
    }

    var body: some View {
        Text("Categorization Sheet")
    }
}

struct CategorizationSheetScreen_Previews: PreviewProvider {
    private static var team = Team(
        id: "",
        userId: "",
        troopId: "",
        regimentId: "",
        name: "Test team",
        createdAt: .now
    )
    
    static var previews: some View {
        CategorizationSheetScreen(team: team)
    }
}
