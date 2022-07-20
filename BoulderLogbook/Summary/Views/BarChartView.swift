//
//  BarChartView.swift
//  BoulderLogbook
//
//  Created by Martin List on 19.07.22.
//

import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct BarChartView: View {
    let logbook: Logbook
    
    var body: some View {
#if canImport(Charts)
        if #available(iOS 16.0, *) {
            Chart(logbook.chartSections) { section in
                BarMark(
                    x: .value("Date", section.date),
                    y: .value("Total Tops", section.count)
                )
                .foregroundStyle(by: .value("Grade", section.grade.gradeDescription))
            }
            .chartXScale(domain: .automatic(reversed: true))
            .chartForegroundStyleScale(BoulderGrade.chartForegroundStyleScale)
            .chartLegend(.hidden)
        }
#else
        EmptyView()
#endif
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(logbook: exampleLogbook)
            .frame(maxHeight: 200)
            .padding()
    }
}
