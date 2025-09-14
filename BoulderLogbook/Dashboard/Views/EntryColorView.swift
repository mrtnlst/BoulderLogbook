//
//  EntryColorView.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.08.22.
//

import SwiftUI

struct EntryColorView: View {
    let grades: [Grade]
    let gradeSystem: GradeSystem

    init(tops: [Top], gradeSystem: GradeSystem) {
        self.gradeSystem = gradeSystem
        self.grades = tops.successful().grades(for: gradeSystem)
    }
    
    var body: some View {
        GeometryReader { reader in
            HStack(spacing: 0) {
                ForEach(gradeSystem.grades) { grade in
                    colorSegment(for: grade, and: reader.size.width)
                }
            }
        }
        .cornerRadius(8)
        .frame(minHeight: minHeight)
    }
    
    @ViewBuilder func colorSegment(for grade: Grade, and width: CGFloat) -> some View {
        let numberOfTops = grades.filter { $0 == grade }.count
        if numberOfTops > 0 {
            ZStack {
                grade.color.frame(
                    width: width / CGFloat(grades.count) * CGFloat(numberOfTops)
                )
                Text("\(numberOfTops)")
                    .font(.caption.weight(.regular))
                    .foregroundStyle(grade.color.isBright ? Color.black : Color.white)
            }
        }
    }
}

private extension EntryColorView {
    var minHeight: CGFloat {
        if #available(iOS 26, *) {
            return 36
        } else {
            return 18
        }
    }
}

#Preview {
    List {
        EntryColorView(
            tops: [
                .sample1,
                .sample2,
                .sample2,
                .sample3,
                .sample4,
                .sample5,
                .sample6,
                .sample7,
                .sample7,
                .sample7
            ],
            gradeSystem: .mandala
        )
    }
}
