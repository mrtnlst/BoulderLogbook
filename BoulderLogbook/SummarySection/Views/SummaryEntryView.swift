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
                    GeometryReader { reader in
                        HStack(spacing: 0) {
                            ForEach(BoulderGrade.allCases.reversed(), id: \.self) { grade in
                                colorSegment(for: grade, and: reader.size.width)
                            }
                        }
                    }
                    .cornerRadius(8)
                    
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
    
    @ViewBuilder func colorSegment(for grade: BoulderGrade, and width: CGFloat) -> some View {
        let numberOfTops = entry.numberOfGrades(for: grade)
        if numberOfTops > 0 {
            ZStack {
                grade.color.frame(
                    width: width / CGFloat(entry.tops.count) * CGFloat(numberOfTops)
                )
                Text("\(numberOfTops)")
                    .font(.caption2.weight(.light))
                    .foregroundColor(grade == BoulderGrade.white ? Color.black : Color.white)
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
