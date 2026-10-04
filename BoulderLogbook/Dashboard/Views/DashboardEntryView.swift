//
//  DashboardEntryView.swift
//  BoulderLogbook
//
//  Created by martin on 07.08.22.
//

import SwiftUI

struct DashboardEntryView: View {
    let entry: Logbook.Section.Entry
    let gradeSystem: GradeSystem
    let focusGrade: Grade?
    
    var focusGradeText: String {
        if let focusGrade {
            "\(entry.tops.count(for: focusGrade))⨉"
        } else {
            "-"
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(minimum: 50, maximum: .infinity), alignment: .leading),
                        GridItem(.flexible(minimum: 50, maximum: .infinity), alignment: .leading),
                        GridItem(.flexible(minimum: 50, maximum: .infinity), alignment: .leading)
                    ],
                    spacing: 32
                ) {
                    VStack(alignment: .center) {
                        Text("Total Ascends")
                            .font(.caption2)
                            .fontWeight(.semibold)
                        Text("\(entry.tops.count)⨉")
                            .font(.title)
                            .foregroundStyle(Color.araLightYellow)
                    }
                    VStack {
                        Text("Highest Grade")
                            .font(.caption2)
                            .fontWeight(.semibold)
                        Text("\(entry.tops.highestGrade(for: gradeSystem)?.name ?? "-")")
                            .font(.title)
                            .foregroundStyle(Color.araBlue)
                    }
                    VStack {
                        Text("Focus Grade")
                            .font(.caption2)
                            .fontWeight(.semibold)
                        Text(focusGradeText)
                            .font(.title)
                            .foregroundStyle(Color.araPurple)
                    }
                }
                .frame(maxWidth: .infinity)
                PlainChevron()
            }
            Text(entry.date, format: .dateTime.year().month().day().hour().minute())
                .font(.footnote)
                .foregroundStyle(.primaryText)
                .padding(.leading, 2)
        }
        .padding(.vertical, verticalPadding)
    }
}

extension DashboardEntryView {
    var verticalPadding: CGFloat {
        if #available(iOS 26, *) {
            return 0
        } else {
            return 8
        }
    }
}

#Preview {
    PlainList {
        DashboardEntryView(
            entry: .init(
                date: .now,
                tops: [
                    .top1, .top1, .top2, .top4, .top5, .top6, .top8
                ],
                gradeSystem: GradeSystem.mandala2.id
            ),
            gradeSystem: .mandala2,
            focusGrade: .mandala7
        )
        DashboardEntryView(
            entry: .init(
                date: Date.now.addingTimeInterval(-3600),
                tops: [
                    .top1, .top3, .top3, .top4, .top5, .top6, .top7, .top7
                ],
                gradeSystem: GradeSystem.mandala2.id
            ),
            gradeSystem: .mandala2,
            focusGrade: nil
        )
    }
}
