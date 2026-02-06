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
    var isSelected: Bool
    var isToday: Bool
    
    init(
        date: Date,
        dayString: String,
        weekday: String,
        isSelected: Bool = false,
        isToday: Bool = false
    ) {
        self.date = date
        self.dayString = dayString
        self.weekday = weekday
        self.isSelected = isSelected
        self.isToday = isToday
    }
}
