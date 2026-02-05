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
        
        var calendar = Calendar.current
        
        public init() {
            self.calendar.locale = Locale(identifier: "ko_KR")
            self.currentWeekDates = self.generateWeekDates(for: self.currentWeekStart)
        }
        
        func generateWeekDates(for start: Date) -> [CalendarItem] {
            let dates = start.datesOfWeek(using: calendar)
            return dates.map { date in
                CalendarItem(
                    date: date,
                    day: calendar.component(.day, from: date),
                    isToday: calendar.isDateInToday(date),
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
                )
            }
        }
    }
    
    @CasePathable
    enum Action: Equatable {
        case view(ViewAction)
        case inner(InnerAction)
        
        @CasePathable
        enum ViewAction: Equatable {
            case onAppear
            case dragGestureEnded(translation: CGFloat)
            case dayTapped(CalendarItem)
        }
        
        @CasePathable
        enum InnerAction: Equatable {
            case updateWeek(by: Int)
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
                
            case let .dragGestureEnded(translation):
                let threshold: CGFloat = 50
                if translation < -threshold {
                    return .send(.inner(.updateWeek(by: 1)))
                } else if translation > threshold {
                    return .send(.inner(.updateWeek(by: -1)))
                }
                return .none
                
            case let .dayTapped(item):
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
