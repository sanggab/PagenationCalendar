//
//  CalendarReducer + View.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import Foundation

import ComposableArchitecture

extension CalendarReducer {
    func handleViewAction(state: inout CalendarReducer.State, action viewAction: CalendarReducer.Action.ViewAction) -> Effect<Action> {
        switch viewAction {
        case .onAppear:
            return viewOnAppearAction(&state)
            
        case let .scrollChanged(id):
            state.currentScrollID = id
            if let id = id, let dayModel = state.model.first(where: { $0.id == id }) {
                // 해당 날짜를 기준으로 년월 타이틀 업데이트
                state.currentTitle = formatTitle(date: dayModel.date, calendar: state.calendar)
            }
            return .none
        }
    }
}

// MARK:
extension CalendarReducer {
    func viewOnAppearAction(_ state: inout CalendarReducer.State) -> Effect<Action> {
        var calendar = state.calendar
        calendar.firstWeekday = 2 // 1: Sunday, 2: Monday
        
        let startDateComponents = DateComponents(year: 2025, month: 1, day: 1)
        guard let startOf2025 = calendar.date(from: startDateComponents) else { return .none }
        
        // End Date: Today
        let now = Date()
        
        // Align Start Date to the beginning of the week (Monday)
        let gridStartDate: Date
        let startWeekday = calendar.component(.weekday, from: startOf2025)
        let startOffset = (startWeekday - calendar.firstWeekday + 7) % 7
        gridStartDate = calendar.date(byAdding: .day, value: -startOffset, to: startOf2025) ?? startOf2025
        
        // Align End Date to the end of the week (Sunday)
        // 오늘이 포함된 주의 일요일까지 구함
        let gridEndDate: Date
        let endWeekday = calendar.component(.weekday, from: now)
        // Sun(1) -> 0, Mon(2) -> 6
        let daysToAdd = (1 - endWeekday + 7) % 7
        gridEndDate = calendar.date(byAdding: .day, value: daysToAdd, to: now) ?? now
        
        var allDates: [DayModel] = []
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        
        let totalDays = calendar.dateComponents([.day], from: gridStartDate, to: gridEndDate).day ?? 0
        
        for i in 0...totalDays {
            if let date = calendar.date(byAdding: .day, value: i, to: gridStartDate) {
                let dayString = calendar.component(.day, from: date).description
                let weekday = formatter.string(from: date)
                
                let model = DayModel(
                    date: date,
                    dayString: dayString,
                    weekday: weekday
                )
                allDates.append(model)
                
                // 오늘 날짜인 경우 ScrollID 저장
                if calendar.isDateInToday(date) {
                    state.currentScrollID = model.id
                }
            }
        }
        
        print("상갑 logEvent Generated dates from \(gridStartDate) to \(gridEndDate), total: \(allDates.count)")
        
        state.model = allDates
        
        // 타이틀 설정 (오늘 날짜 기준)
        state.currentTitle = formatTitle(date: now, calendar: calendar)
        
        return .none
    }
}

extension CalendarReducer {
    private func formatTitle(date: Date, calendar: Calendar) -> String {
        let currentYear = calendar.component(.year, from: Date())
        let targetYear = calendar.component(.year, from: date)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        if currentYear == targetYear {
            formatter.dateFormat = "M. d"
        } else {
            formatter.dateFormat = "yyyy년 M. d"
        }
        
        return formatter.string(from: date)
    }
}
