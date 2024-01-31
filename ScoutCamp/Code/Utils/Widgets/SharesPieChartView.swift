//
//  SharesPieChartView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 11/12/2023.
//

import SwiftUI
import DGCharts

struct SharesPieChartView: UIViewRepresentable {
    let entries: [PieChartDataEntry]

    func makeUIView(context: Context) -> PieChartView {
        return PieChartView()
    }

    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries)
        let isPercent = (entries.first?.data as? Bool) ?? false
        uiView.data = PieChartData(dataSet: dataSet)
        uiView.legend.enabled = false
        formatDataSet(dataSet, isPercent: isPercent)
    }

    private func formatDataSet(_ dataSet: PieChartDataSet, isPercent: Bool) {
        let formatter = NumberFormatter()
        formatter.numberStyle = isPercent ? .percent : .decimal
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        dataSet.sliceSpace = 5
        dataSet.valueColors = [.black]
        dataSet.colors = [
            .red.withAlphaComponent(0.7),
            .blue.withAlphaComponent(0.7),
            .green.withAlphaComponent(0.7),
            .brown.withAlphaComponent(0.7),
            .yellow.withAlphaComponent(0.7)
        ]
    }
}

#Preview {
    SharesPieChartView(
        entries: TestData.numericAppAssignment.dataEntries()
    )
}
