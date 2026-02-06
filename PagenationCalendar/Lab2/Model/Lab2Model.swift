//
//  Lab2Model.swift
//  PagenationCalendar
//
//  Created by Gab on 2/6/26.
//

import Foundation

struct DayModel: Identifiable, Equatable {
    let id = UUID()
    let date: Date        // 전체 날짜 정보
    let dayString: String // "1", "2", "3" ...
    let weekday: String   // "월", "화", "수" ...
    var isToday: Bool
    var isSelected: Bool
    var isFuture: Bool
    var isWritted: Bool
    
    init(
        date: Date,
        dayString: String,
        weekday: String,
        isToday: Bool = false,
        isSelected: Bool = false,
        isFuture: Bool = false,
        isWritted: Bool = false
    ) {
        self.date = date
        self.dayString = dayString
        self.weekday = weekday
        self.isToday = isToday
        self.isSelected = isSelected
        self.isFuture = isFuture
        self.isWritted = isWritted
    }
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
