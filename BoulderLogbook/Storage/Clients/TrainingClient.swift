//
//  TrainingClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 19.10.25.
//

import Foundation
import Dependencies

struct TrainingClient {
    var fetchTrainings: () async -> [Training]
    var saveTraining: (Training) async -> Void
    var deleteTraining: (UUID) async -> ()
}

extension TrainingService {
    func toTrainingClient() -> TrainingClient {
        .init {
            await self.fetchTrainings()
        } saveTraining: {
            await self.saveTraining($0)
        } deleteTraining: {
            await self.deleteTraining(for: $0)
        }
    }
}

extension TrainingClient: DependencyKey {
    static let liveValue = BoulderLogbookApp.dependencies.trainingService.toTrainingClient()
    static let previewValue: Self = {
        return Self(
            fetchTrainings: {
                [
                    Training(
                        id: UUID(),
                        date: Date.now.addingTimeInterval(-86400),
                        exercise: .pullUp,
                        result: .repititions(12)
                    ),
                    Training(
                        id: UUID(),
                        date: Date.now.addingTimeInterval(-86400 * 2),
                        exercise: .sitUp,
                        result: .repititions(32)
                    ),
                    Training(
                        id: UUID(),
                        date: .now,
                        exercise: .pullUp,
                        result: .repititions(6)
                    )
                ]
            },
            saveTraining: { _ in },
            deleteTraining: { _ in }
        )
    }()
}

