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
        HStack {
            iconView()
            VStack(alignment: .leading) {
                HStack {
                    EntryColorView(
                        tops: entry.tops,
                        gradeSystem: gradeSystem
                    )
                    HStack(spacing: 2) {
                        Text("×")
                            .font(.footnote.weight(.medium))
                        Text("\(entry.tops.filter { !$0.isAttempt }.count)")
                            .font(.footnote.weight(.medium))
                    }
                }
                Text(entry.date, format: .dateTime.year().month().day().hour().minute())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.leading, 2)
            }
        }
        .padding(.vertical, 8)
    }
}

extension DashboardEntryView {
    @ViewBuilder func iconView() -> some View {
        ZStack {
            Image(systemName: "figure.climbing")
                .foregroundColor(.accentColor)
            Color.accentColor.opacity(0.15)
                .cornerRadius(8)
        }
        .frame(maxWidth: 48)
    }
}


struct DashboardEntryView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DashboardEntryView(
                entry: .samples[0],
                gradeSystem: .mandala
            )
        }
    }
}
