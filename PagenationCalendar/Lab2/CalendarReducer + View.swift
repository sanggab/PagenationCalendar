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
            
        case .scrollChanged(let id):
            return viewScrollChanged(&state, id: id)
            
        case .dayTapped(let dayModel):
            return viewDayTappedAction(&state, model: dayModel)
            
        case .weekdayHeaderTapped(let index):
            return viewWeekdayHeaderTapped(&state, index: index)
            
        case .changeNutrient(let type):
            return viewChangeNutrient(&state, type: type)
        }
    }
}

// MARK:
extension CalendarReducer {
    func viewOnAppearAction(_ state: inout CalendarReducer.State) -> Effect<Action> {
        let calendar = state.calendar
        
        // 요일 심볼 설정 (예: "일", "월", "화" ...)
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1 // 1-based to 0-based
        let shiftedSymbols = Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
        state.weekdays = shiftedSymbols
        
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
                    weekday: weekday,
                    isToday: calendar.isDateInToday(date),
                    isSelected: calendar.isDate(date, inSameDayAs: now),
                    isFuture: date.isFuture,
                    isWritted: date.isFuture ? false : Bool.random()
                )
                allDates.append(model)
                
                // 오늘 날짜인 경우 ScrollID 저장
                if calendar.isDateInToday(date) {
                    state.currentScrollID = model.id
                }
            }
        }
//        print("상갑 logEvent Generated dates from \(gridStartDate) to \(gridEndDate), total: \(allDates.count)")
        state.model = allDates
        
        // 타이틀 설정 (오늘 날짜 기준)
        state.currentTitle = formatTitle(date: now, calendar: calendar)
        
        return .none
    }
}

extension CalendarReducer {
    func viewWeekdayHeaderTapped(_ state: inout CalendarReducer.State, index: Int) -> Effect<Action> {
        // 1. 현재 보이는 주의 시작 날짜(ID)를 찾는다.
        guard let currentScrollID = state.currentScrollID,
              let weekStartIndex = state.model.firstIndex(where: { $0.id == currentScrollID }) else {
            return .none
        }
        
        // 2. 해당 주의 시작 인덱스 + 탭한 요일 인덱스(0...6)를 더해 타겟 날짜를 찾는다.
        let targetIndex = weekStartIndex + index
        
        // 3. 인덱스가 유효한지 확인한다.
        guard state.model.indices.contains(targetIndex) else {
            return .none
        }
        
        let targetModel = state.model[targetIndex]
        
        // 4. 해당 날짜를 탭한 것과 동일한 로직을 수행한다.
        return viewDayTappedAction(&state, model: targetModel)
    }
}

extension CalendarReducer {
    func viewScrollChanged(_ state: inout CalendarReducer.State, id: DayModel.ID?) -> Effect<Action> {
        state.currentScrollID = id
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
            formatter.dateFormat = "M. d (E)"
        } else {
            formatter.dateFormat = "yy. M. d (E)"
        }
        
        return formatter.string(from: date)
    }
}

extension CalendarReducer {
    func viewDayTappedAction(_ state: inout CalendarReducer.State, model dayModel: DayModel) -> Effect<Action> {
        if dayModel.isFuture { return .none }
        
        if let prevIndex = state.model.firstIndex(where: { $0.isSelected }) {
            state.model[prevIndex].isSelected = false
        }
        
        if let newIndex = state.model.firstIndex(where: { $0.id == dayModel.id }) {
            state.model[newIndex].isSelected = true
        }
        
        state.currentTitle = formatTitle(date: dayModel.date, calendar: state.calendar)
        
        let startOfWeek = dayModel.date.startOfWeek(using: state.calendar)
        
        if let startDayModel = state.model.first(where: { state.calendar.isDate($0.date, inSameDayAs: startOfWeek) }) {
            state.currentScrollID = startDayModel.id
        }
        
        return .none
    }
}

extension CalendarReducer {
    func viewChangeNutrient(_ state: inout CalendarReducer.State, type nutrientType: NutrientType) -> Effect<Action> {
        switch nutrientType {
        case .carbohydrate:
            state.carbs.value += 20.4
        case .protein:
            state.protein.value += 5
        case .fat:
            state.fat.value += 5
        case .sodium:
            state.sodium.value += 5
        case .sugars:
            state.sugars.value += 4
        case .fiber:
            state.fiber.value += 3
        case .cholesterol:
            state.chol.value += 2
        }
        
        if !state.isWrite {
            state.isWrite = true
        }
        
        state.currentCalories = state.carbs.calories.rounded() + state.protein.calories.rounded() + state.fat.calories.rounded()
        
        return .none
    }
}
