//
//  Model.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import Foundation

struct CalendarItem: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var date: Date
    var day: Int
    var isToday: Bool
    var isSelected: Bool
    var isFuture: Bool = false
}

extension Date {

    func startOfWeek(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func datesOfWeek(using calendar: Calendar = .current) -> [Date] {
        let start = self.startOfWeek(using: calendar)
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: start)
        }
    }
    
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isFuture: Bool {
        self > Date()
    }
}
