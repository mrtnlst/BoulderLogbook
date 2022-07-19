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

// TODO: Refactor
extension LogbookEntry {
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return dateFormatter.string(from: sectionDate)
    }
}

// TODO: Refactor
extension Logbook {
    var chartSections: [ChartSection] {
        var sections: [ChartSection] = []
        for entry in logbookEntries {
            for grade in BoulderGrade.allCases {
                sections.append(
                    ChartSection(
                        id: UUID(),
                        grade: grade,
                        date: entry.dateString,
                        count: entry.numberOfGrades(for: grade)
                    )
                )
            }
        }
        return sections
    }
}

// TODO: Refactor
struct ChartSection: Identifiable {
    var id: UUID
    var grade: BoulderGrade
    var date: String
    var count: Int
}

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
            .chartForegroundStyleScale([
                BoulderGrade.purple.gradeDescription: BoulderGrade.purple.color,
                BoulderGrade.yellow.gradeDescription: BoulderGrade.yellow.color,
                BoulderGrade.white.gradeDescription: BoulderGrade.white.color,
                BoulderGrade.black.gradeDescription: BoulderGrade.black.color,
                BoulderGrade.orange.gradeDescription: BoulderGrade.orange.color,
                BoulderGrade.red.gradeDescription: BoulderGrade.red.color,
                BoulderGrade.blue.gradeDescription: BoulderGrade.blue.color
            ])
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
