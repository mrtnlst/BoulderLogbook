//
//  DiagramPageClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.23.
//

import Foundation
import Dependencies

struct DiagramPageClient {
    var fetchSelectedDiagram: () -> (Int?)
    var saveSelectedDiagram: (Int) -> ()
}

extension DependencyValues {
    var diagramPageClient: DiagramPageClient {
        get { self[DiagramPageClient.self] }
        set { self[DiagramPageClient.self] = newValue }
    }
}

extension DiagramPageClient: DependencyKey {
    static let liveValue: Self = {
        let defaults = UserDefaults.standard
        let selectedDiagramKey = "diagram-page-selected"
        return Self(
            fetchSelectedDiagram: {
                guard let encodedData = defaults.object(forKey: selectedDiagramKey) as? Data,
                      let decodedData = try? JSONDecoder().decode(Int.self, from: encodedData)
                else {
                    return nil
                }
                return decodedData
            },
            saveSelectedDiagram: { id in
                if let data = try? JSONEncoder().encode(id) {
                    defaults.set(data, forKey: selectedDiagramKey)
                } else {
                    defaults.set(nil, forKey: selectedDiagramKey)
                }
            }
        )
    }()
}
