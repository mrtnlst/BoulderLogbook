//
//  URL+FileStorageKeys.swift
//  BoulderLogbook
//
//  Created by Martin List on 20.09.26.
//

import Foundation

extension URL {
    static let focusGrade = Self.documentsDirectory.appending(component: "focus-grade.json")
    static let diagramTab = Self.documentsDirectory.appending(component: "diagram-tab")
    static let defaultGradeSystem = Self.documentsDirectory.appending(component: "default-grade-system")
}

