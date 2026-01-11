//
//  ExerciseClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 12.10.25.
//

import Foundation
import Dependencies

struct ExerciseClient {
    var fetchExercises: () async -> [Exercise]
    var saveExercise: (Exercise) async -> Void
    var deleteExercise: (UUID) async -> ()
}

extension TrainingService {
    func toClient() -> ExerciseClient {
        .init {
            await self.fetchExercises()
        } saveExercise: {
            await self.saveExercise($0)
        } deleteExercise: {
            await self.deleteExercise(for: $0)
        }
    }
}

extension ExerciseClient: DependencyKey {
    static let liveValue = BoulderLogbookApp.dependencies.trainingService.toClient()
    static let previewValue: Self = {
        return Self(
            fetchExercises: { [Exercise.deadHang, Exercise.pullUp, Exercise.sitUp] },
            saveExercise: { _ in },
            deleteExercise: { _ in }
        )
    }()
}
