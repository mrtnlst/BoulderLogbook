//
//  TimeSegment.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.26.
//

import Foundation

enum TimeSegment: String, Hashable, CaseIterable {
    case month = "Month"
    case year = "Year"
    case all = "All time"
}

extension TimeSegment {
    var calendarComponent: Calendar.Component? {
        switch self {
        case .month:
            return .month
        case .year:
            return .year
        case .all:
            return nil
        }
    }
    
    var description: String {
        switch self {
        case .month:
            return "this month"
        case .year:
            return "this year"
        case .all:
            return "of all time"
        }
    }
}
