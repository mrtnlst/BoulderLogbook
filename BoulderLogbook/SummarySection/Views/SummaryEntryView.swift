//
//  SummaryEntryView.swift
//  BoulderLogbook
//
//  Created by martin on 07.08.22.
//

import SwiftUI

struct SummaryEntryView: View {
    let entry: LogbookData.Entry
    
    var body: some View {
        HStack {
            iconView()
            VStack(alignment: .leading) {
                HStack {
                    EntryColorView(entry: entry)
                    HStack(spacing: 2) {
                        Image(systemName: "arrowtriangle.up.circle")
                            .font(.footnote.weight(.bold))
                        Text("×")
                            .font(.footnote.weight(.medium))
                        Text("\(entry.tops.count)")
                            .font(.footnote.weight(.medium))
                    }
                }
                HStack {
                    Text(entry.date, format: .dateTime.year().month().day().hour().minute())
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 2)
            }
        }
        .padding(.vertical, 8)
    }
}

extension SummaryEntryView {
    @ViewBuilder func iconView() -> some View {
        if #available(iOS 16, *) {
            Image(systemName: "figure.climbing")
        } else {
            Image("figure.climbing")
                .foregroundColor(.accentColor)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.accentColor.opacity(0.15))

                }
        }
    }
}


struct SummaryEntryView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SummaryEntryView(
                entry: LogbookData.Entry.sampleEntries[0]
            )
        }
    }
}
