//
//  AscendType.swift
//  BoulderLogbook
//
//  Created by Martin List on 10.10.26.
//

import Foundation

enum AscendType: CaseIterable {
    case redPoint
    case flash
    case onsight
    case attempt
}

extension AscendType: HorizontalSelectionElement {
    var name: String {
        switch self {
        case .redPoint:
            "Redpoint"
        case .flash:
            "Flash"
        case .onsight:
            "Onsight"
        case .attempt:
            "Attempt"
        }
    }
    
    var id: UUID {
        switch self {
        case .redPoint:
            UUID(uuidString: "D311F691-88C8-42CC-BA08-594B11EAB0D6")!
        case .flash:
            UUID(uuidString: "EE97942E-A8BB-4351-92E3-FE2A9D98D6DB")!
        case .onsight:
            UUID(uuidString: "91AB177A-05FA-4D93-B9C4-9FE2D47E7547")!
        case .attempt:
            UUID(uuidString: "51B5AA5B-D6AC-4955-8202-8772561D0432")!
        }
    }
}
