//
//  Lab2Model.swift
//  PagenationCalendar
//
//  Created by Gab on 2/6/26.
//

import Foundation
import SwiftUI

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

enum IntakeStatus: String, Equatable, Identifiable {
    case insufficient = "부족"
    case adequate = "적정"
    case caution = "주의"
    case warning = "위험"
    case excessive = "과다"
    
    var id: String { self.rawValue }
}

extension IntakeStatus {
    var color: Color {
        switch self {
        case .insufficient:
            Color(hex: "525960")
        case .adequate:
            Color(hex: "197dc4")
        case .caution:
            Color(hex: "ffb948")
        case .warning:
            Color(hex: "ff5741")
        case .excessive:
            Color(hex: "ee6300")
        }
    }
}

enum WaterIntakeGuildText: String, Equatable, Identifiable {
    case emptyRecord = "지금 물 한 모금 어때요?"
    case inProgress  = "조금만 더 마셔도 좋아요 💧"
    case goalAchieved = "오늘 필요한 물을 충분히 마셨어요"
    
    var id: String { self.rawValue }
}

/// 메인 page dashboard
enum DashboardSection: Int, Equatable, Identifiable, CaseIterable {
    /// 탄/단/지 영양소 dashboard
    case nutrient = 0
    /// 부가영양소 dashboard
    case nutrientDetail = 1
    /// 음수량 dashboard
    case waterIntake = 2
    
    var id: Int { self.rawValue }
}
