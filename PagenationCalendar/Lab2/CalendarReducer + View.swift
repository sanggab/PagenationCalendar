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
            return viewScrollChangedAction(&state, id: id)
            
        case .todayTapped:
            return viewTodayTappedAction(&state)
            
        case .dayTapped(let dayModel):
            return viewDayTappedAction(&state, model: dayModel)
            
        case .weekdayHeaderTapped(let index):
            return viewWeekdayHeaderTappedAction(&state, index: index)
            
        case .changeNutrient(let type):
            return viewChangeNutrientAction(&state, type: type)

        case .dashboardPageChanged(let page):
            return viewDashboardPageChangedAction(&state, page: page)
            
        case .increaseWaterIntake:
            return viewIncreaseWaterIntakeAction(&state)
            
        case .decreaseWaterIntake:
            return viewDecreaseWaterIntakeAction(&state)
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
    func viewScrollChangedAction(_ state: inout CalendarReducer.State, id: DayModel.ID?) -> Effect<Action> {
        state.currentScrollID = id
        return .none
    }
}

extension CalendarReducer {
    func viewTodayTappedAction(_ state: inout CalendarReducer.State) -> Effect<Action> {
        let calendar = state.calendar
        let now = Date()

        // 오늘 버튼: 오늘이 포함된 주(월~일) 데이터를 먼저 보강한다.
        ensureCurrentWeekModels(&state, containing: now, now: now, calendar: calendar)
        
        // 날짜 플래그는 현재 시각 기준으로 동기화한다.
        refreshDayFlags(&state, now: now, calendar: calendar)

        guard let todayModel = state.model.first(where: { calendar.isDate($0.date, inSameDayAs: now) }) else {
            return .none
        }

        return viewDayTappedAction(&state, model: todayModel)
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
    func viewWeekdayHeaderTappedAction(_ state: inout CalendarReducer.State, index: Int) -> Effect<Action> {
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
    func viewChangeNutrientAction(_ state: inout CalendarReducer.State, type nutrientType: NutrientType) -> Effect<Action> {
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

extension CalendarReducer {
    func viewDashboardPageChangedAction(_ state: inout CalendarReducer.State, page: Int?) -> Effect<Action> {
        state.currentDashboardPage = page
        return .none
    }
}

extension CalendarReducer {
    func viewIncreaseWaterIntakeAction(_ state: inout CalendarReducer.State) -> Effect<Action> {
        state.currentWaterIntake += state.waterIntakeStep
        
        return .send(.inner(.determineWaterIntakeGuildText))
    }
    
    func viewDecreaseWaterIntakeAction(_ state: inout CalendarReducer.State) -> Effect<Action> {
        guard state.currentWaterIntake > 0.0 else {
            return .none
        }
        
        state.currentWaterIntake -= state.waterIntakeStep
        
        return .send(.inner(.determineWaterIntakeGuildText))
    }
}
// MARK: ViewAction의 Utils 모음
extension CalendarReducer {
    private func formatTitle(date: Date, calendar: Calendar) -> String {
        let currentYear = calendar.component(.year, from: Date())
        let targetYear = calendar.component(.year, from: date)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        if currentYear == targetYear {
            formatter.dateFormat = "M. d E"
        } else {
            formatter.dateFormat = "yy. M. d E"
        }
        
        return formatter.string(from: date)
    }

    private func refreshDayFlags(_ state: inout CalendarReducer.State, now: Date, calendar: Calendar) {
        for index in state.model.indices {
            let dayDate = state.model[index].date

            let isToday = calendar.isDate(dayDate, inSameDayAs: now)
            let isFuture = calendar.compare(dayDate, to: now, toGranularity: .day) == .orderedDescending

            if state.model[index].isToday != isToday {
                state.model[index].isToday = isToday
            }

            if state.model[index].isFuture != isFuture {
                state.model[index].isFuture = isFuture
            }
        }
    }

    private func ensureCurrentWeekModels(
        _ state: inout CalendarReducer.State,
        containing date: Date,
        now: Date,
        calendar: Calendar
    ) {
        let weekStart = date.startOfWeek(using: calendar)

        // 주 범위는 월요일 시작 ~ 일요일 종료로 고정한다.
        guard let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) else {
            return
        }

        var currentDate = weekStart
        var didAppend = false

        while calendar.compare(currentDate, to: weekEnd, toGranularity: .day) != .orderedDescending {
            let isAlreadyExist = state.model.contains { dayModel in
                calendar.isDate(dayModel.date, inSameDayAs: currentDate)
            }

            // 모델에 없는 날짜만 채운다.
            if !isAlreadyExist {
                state.model.append(makeDayModel(date: currentDate, now: now, calendar: calendar))
                didAppend = true
            }

            guard let movedDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }

            currentDate = movedDate
        }

        // 데이터 추가하는 경우에만 정렬한다.
        if didAppend {
            state.model.sort { $0.date < $1.date }
        }
    }

    private func makeDayModel(date: Date, now: Date, calendar: Calendar) -> DayModel {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"

        let isFuture = calendar.compare(date, to: now, toGranularity: .day) == .orderedDescending

        return DayModel(
            date: date,
            dayString: calendar.component(.day, from: date).description,
            weekday: formatter.string(from: date),
            isToday: calendar.isDate(date, inSameDayAs: now),
            isSelected: false,
            isFuture: isFuture,
            isWritted: isFuture ? false : Bool.random()
        )
    }
}
