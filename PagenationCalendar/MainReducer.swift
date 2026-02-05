//
//  MainReducer.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import SwiftUI

import ComposableArchitecture



@Reducer
struct MainReducer {
    @ObservableState
    struct State: Equatable {
        var currentWeekDates: [CalendarItem] = []
        var selectedDate: Date = Date()
        var currentWeekStart: Date = Date().startOfWeek()
        
        // Scroll Paging Logic
        var focusedWeekOffset: Int = 0 // 0 means current week, -1 means last week
        var minWeekOffset: Int = -12 // Initial range
        var loadedWeeks: [Int: [CalendarItem]] = [:] 
        
        var calendar = Calendar.current
        
        public init() {
            self.calendar.locale = Locale(identifier: "ko_KR")
            // Initialize with default range
            self.ensureWeeksLoaded(from: minWeekOffset, to: 0)
            self.currentWeekDates = self.loadedWeeks[0] ?? []
//            print("상갑 logEvent \(#function) currentWeekDates \(currentWeekDates)")
            print("상갑 logEvent \(#function) loadedWeeks \(loadedWeeks)")
        }
        
        mutating func updateCurrentWeekDates() {
            if let weeks = loadedWeeks[focusedWeekOffset] {
                self.currentWeekDates = weeks
                if let firstDate = weeks.first?.date {
                     self.currentWeekStart = firstDate
                }
            } else {
                if let newStart = calendar.date(byAdding: .weekOfYear, value: focusedWeekOffset, to: Date().startOfWeek()) {
                    self.currentWeekStart = newStart
                    self.currentWeekDates = generateWeekDates(for: newStart)
                }
            }
        }
        
        mutating func ensureWeeksLoaded(from min: Int, to max: Int) {
            for offset in min...max {
                if loadedWeeks[offset] == nil {
                     if let start = calendar.date(byAdding: .weekOfYear, value: offset, to: Date().startOfWeek()) {
                         loadedWeeks[offset] = generateWeekDates(for: start)
                         
                     }
                }
            }
        }
        
        func generateWeekDates(for start: Date) -> [CalendarItem] {
            let dates = start.datesOfWeek(using: calendar)
            return dates.map { date in
                CalendarItem(
                    date: date,
                    day: calendar.component(.day, from: date),
                    isToday: calendar.isDateInToday(date),
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                    isFuture: date.isFuture
                )
            }
        }
        
        // Helper to get week items for a specific offset (used in LazyHStack)
        func weekDates(for offset: Int) -> [CalendarItem] {
            return loadedWeeks[offset] ?? []
        }
    }
    
    @CasePathable
    enum Action: Equatable {
        case view(ViewAction)
        case inner(InnerAction)
        
        @CasePathable
        enum ViewAction: Equatable {
            case onAppear
            case dayTapped(CalendarItem)
            case weekScrollChanged(Int?)
        }
        
        @CasePathable
        enum InnerAction: Equatable {
            case updateSelectedDate(Date)
        }
    }
    
    
    var body: some Reducer<State, Action> {
        CombineReducers {
            viewReducer
            innerReducer
        }
    }
}

extension MainReducer {
    var viewReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .view(viewAction) = action else { return .none }
            
            switch viewAction {
            case .onAppear:
                return .none
                
            case let .weekScrollChanged(offset):
                guard let offset = offset else { return .none }
                print("상갑 logEvent \(#function) offset \(offset)")
                state.focusedWeekOffset = offset
                state.updateCurrentWeekDates()
                
                // Infinite Scroll: Load more past weeks if close to the edge
                if offset < state.minWeekOffset + 5 {
                    let newMin = state.minWeekOffset - 52
                    state.ensureWeeksLoaded(from: newMin, to: state.minWeekOffset - 1)
                    state.minWeekOffset = newMin
                }
                
                return .none
                
            case let .dayTapped(item):
                if item.isFuture { return .none }
                return .send(.inner(.updateSelectedDate(item.date)))
            }
        }
    }
}

extension MainReducer {
    var innerReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .inner(innerAction) = action else { return .none }
            
            return self.handleInnerAction(state: &state, action: innerAction)
        }
    }
}
