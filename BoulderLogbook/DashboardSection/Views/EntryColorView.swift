//
//  EntryColorView.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.08.22.
//

import SwiftUI

struct EntryColorView: View {
    let entry: Logbook.Section.Entry
    
    var body: some View {
        GeometryReader { reader in
            HStack(spacing: 0) {
                ForEach(LegacyBoulderGrade.allCases.reversed(), id: \.self) { grade in
                    colorSegment(for: grade, and: reader.size.width)
                }
            }
        }
        .cornerRadius(8)
    }
    
    @ViewBuilder func colorSegment(for grade: LegacyBoulderGrade, and width: CGFloat) -> some View {
        let numberOfTops = entry.tops.numberOfGrades(for: grade)
        if numberOfTops > 0 {
            ZStack {
                grade.color.frame(
                    width: width / CGFloat(entry.tops.count) * CGFloat(numberOfTops)
                )
                Text("\(numberOfTops)")
                    .font(.caption2.weight(.light))
                    .foregroundColor(grade == LegacyBoulderGrade.white ? Color.black : Color.white)
            }
        }
    }
}

struct EntryColorView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EntryColorView(
                entry: .samples[0]
            )
        }
    }
}
