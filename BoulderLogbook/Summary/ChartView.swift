//
//  ChartView.swift
//  BoulderLogbook
//
//  Created by martin on 26.06.22.
//

import SwiftUI
#if swift(>=5.7)
import Charts

extension Logbook {
    var chartSections: [ChartSection] {
        var sections: [ChartSection] = []
        for entry in logbookEntries {
            for grade in BoulderGrade.allCases {
                sections.append(
                    ChartSection(
                        id: UUID(),
                        grade: grade,
                        date: entry.date,
                        count: entry.numberOfGrades(for: grade)
                    )
                )
            }
        }
        return sections
    }
}

struct ChartSection: Identifiable {
    var id: UUID
    var grade: BoulderGrade
    var date: Date
    var count: Int
}

struct ChartView: View {
    var body: some View {
        if #available(iOS 16.0, *) {
            Chart(exampleLogbook.chartSections) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Boulders", $0.count),
                    series: .value("Grades", $0.grade.gradeDescription)
                )
                .foregroundStyle(by: .value("Grades", $0.grade.gradeDescription))
            }
            .chartForegroundStyleScale([
                "Red": .red,
                "Blue": .blue,
                "Orange": .orange,
                "Black": .black,
                "White": .gray,
                "Yellow": .yellow
            ])
        } else {
            // Fallback on earlier versions
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .frame(maxHeight: 200)
            .padding(.horizontal)
    }
}
#endif
