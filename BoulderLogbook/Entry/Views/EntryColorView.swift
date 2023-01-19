//
//  EntryColorView.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.08.22.
//

import SwiftUI

struct EntryColorView: View {
    let entry: Logbook.Entry
    
    var body: some View {
        GeometryReader { reader in
            HStack(spacing: 0) {
                ForEach(BoulderGrade.allCases.reversed(), id: \.self) { grade in
                    colorSegment(for: grade, and: reader.size.width)
                }
            }
        }
        .cornerRadius(8)
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

struct EntryColorView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EntryColorView(
                entry: Logbook.Entry.sampleEntries[0]
            )
        }
    }
}
