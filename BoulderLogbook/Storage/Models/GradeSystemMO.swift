//
//  GradeSystemMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.02.24.
//

import CoreData
import SwiftUI

@objc(GradeSystemMO)
class GradeSystemMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var grades: Set<GradeMO>
}

extension GradeSystemMO {
    func toGradeSystem(
        with decoder: JSONDecoder
    ) -> GradeSystem {
        GradeSystem(
            id: id,
            name: name,
            grades: grades
                .compactMap { grade in
                    guard let color = try? decoder.decode(Color.self, from: grade.color) else {
                        return nil
                    }
                    return grade.toGrade(with: color)
                }
                .sorted { $0.difficulty < $1.difficulty }
        )
    }
}
