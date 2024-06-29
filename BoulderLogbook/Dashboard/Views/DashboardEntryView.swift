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
            EntryColorView(
                tops: entry.tops,
                gradeSystem: gradeSystem
            )
            .frame(minHeight: 18)
            Text(entry.date, format: .dateTime.year().month().day().hour().minute())
                .font(.footnote)
                .foregroundStyle(.primaryText)
                .padding(.leading, 2)
        }
        .padding(.vertical, 8)
        .listRowBackground(Color.rowBackground)
    }
}

#Preview {
    PlainList {
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
