//
//  DiagramPageClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.23.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct DiagramPageClient {
    var fetchSelectedDiagram: @Sendable () -> (Int?) = { nil }
    var saveSelectedDiagram: @Sendable (Int) -> () = { _ in }
}

extension DiagramPageClient: DependencyKey {
    static let liveValue: Self = {
        let selectedDiagramKey = "diagram-page-selected"
        return Self(
            fetchSelectedDiagram: {
                guard let encodedData = UserDefaults.standard.object(forKey: selectedDiagramKey) as? Data,
                      let decodedData = try? JSONDecoder().decode(Int.self, from: encodedData)
                else {
                    return nil
                }
                return decodedData
            },
            saveSelectedDiagram: { id in
                if let data = try? JSONEncoder().encode(id) {
                    UserDefaults.standard.set(data, forKey: selectedDiagramKey)
                } else {
                    UserDefaults.standard.set(nil, forKey: selectedDiagramKey)
                }
            }
        )
    }()
}

extension DependencyValues {
    var diagramPageClient: DiagramPageClient {
        get { self[DiagramPageClient.self] }
        set { self[DiagramPageClient.self] = newValue }
    }
}
