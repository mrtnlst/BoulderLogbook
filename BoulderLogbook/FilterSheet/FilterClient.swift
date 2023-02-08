import Foundation
import Dependencies

struct FilterClient {
    var fetchFilterSystem: () -> UUID?
    var fetchFilters: () -> [Filter]?
    var saveFilterSystem: (UUID?) -> Void
    var saveFilters: ([Filter]?) -> Void
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
            fetchFilters: {
                guard let encodedData = defaults.object(forKey: filtersKey) as? Data,
                      let decodedData = try? JSONDecoder().decode([Filter].self, from: encodedData)
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
            },
            saveFilters: { filters in
                if let data = try? JSONEncoder().encode(filters) {
                    defaults.set(data, forKey: filtersKey)
                } else {
                    defaults.set(nil, forKey: filtersKey)
                }
            }
        )
    }()
    
    static let previewValue: Self = {
        return Self(
            fetchFilterSystem: { GradeSystem.mandala.id },
            fetchFilters: { Filter.samples },
            saveFilterSystem: { _ in },
            saveFilters: { _ in }
        )
    }()
}

