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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                EntryColorView(
                    tops: entry.tops,
                    gradeSystem: gradeSystem
                )
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondaryText)
            }
            Text(entry.date, format: .dateTime.year().month().day().hour().minute())
                .font(.footnote)
                .foregroundStyle(.primaryText)
                .padding(.leading, 2)
        }
        .padding(.vertical, verticalPadding)
        .listRowBackground(Color.rowBackground)
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
    PlainList(hideSeperator: false) {
        DashboardEntryView(
            entry: [Logbook.Section.Entry].samples[0],
            gradeSystem: .mandala
        )
        DashboardEntryView(
            entry: [Logbook.Section.Entry].samples[3],
            gradeSystem: .mandala
        )
    }
}
