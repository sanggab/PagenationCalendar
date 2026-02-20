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
