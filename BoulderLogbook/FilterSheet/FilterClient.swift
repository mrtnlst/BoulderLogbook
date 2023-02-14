import Foundation
import Dependencies

struct FilterClient {
    var fetchFilterSystem: () -> UUID?
    var saveFilterSystem: (UUID?) -> Void
}

extension DependencyValues {
    var filterClient: FilterClient {
        get { self[FilterClient.self] }
        set { self[FilterClient.self] = newValue }
    }
}

extension FilterClient: DependencyKey {
    static let liveValue: Self = {
        let defaults = UserDefaults.standard
        let filtersKey = "filters"
        let filterSystemKey = "filter-system"
        return Self(
            fetchFilterSystem: {
                guard let encodedData = defaults.object(forKey: filterSystemKey) as? Data,
                      let decodedData = try? JSONDecoder().decode(UUID.self, from: encodedData)
                else {
                    return nil
                }
                return decodedData
            },
            saveFilterSystem: { newValue in
                if let data = try? JSONEncoder().encode(newValue) {
                    defaults.set(data, forKey: filterSystemKey)
                } else {
                    defaults.set(nil, forKey: filterSystemKey)
                }
            }
        )
    }()
    
    static let previewValue: Self = {
        return Self(
            fetchFilterSystem: { GradeSystem.mandala.id },
            saveFilterSystem: { _ in }
        )
    }()
}

