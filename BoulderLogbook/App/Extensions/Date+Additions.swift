//
//  Date+Additions.swift
//  BoulderLogbook
//
//  Created by martin on 13.08.22.
//

import Foundation

extension Date {
    var yearMonthDate: Date? {
        Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: self)
        )
    }
    
    var yearMonthDayDate: Date? {
        Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month, .day], from: self)
        )
    }
    
    var dayMonthDateString: String? {
        guard let yearMonthDayDate = yearMonthDayDate else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.setLocalizedDateFormatFromTemplate("ddMM")
        return dateFormatter.string(from: yearMonthDayDate)
    }
}
