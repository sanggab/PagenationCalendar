//
//  CalendarReducer.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct CalendarReducer {
    @ObservableState
    struct State: Equatable {
//        var currentWeekDates: [CalendarItem] = []
//        var selectedDate: Date = Date()
//        var currentWeekStart: Date = Date().startOfWeek()
        
        // Scroll Paging Logic
//        var focusedWeekOffset: Int = 0 // 0 means current week, -1 means last week
//        var minWeekOffset: Int = -12 // Initial range
//        var loadedWeeks: [Int: [CalendarItem]] = [:]
        
        var calendar = Calendar.current
        
        var model: [DayModel] = []
        var currentTitle: String = ""
        var currentScrollID: DayModel.ID?
        
        var weekdays: [String] = []
        
        var carbs = NutrientData(type: .carbohydrate, value: 0, goal: 1000)
        var protein = NutrientData(type: .protein, value: 0, goal: 140)
        var fat = NutrientData(type: .fat, value: 0, goal: 60)
        var totalCaloriesGoal: Double = 2500
        
        public init() {
            self.calendar.locale = Locale(identifier: "ko_KR")
            self.calendar.firstWeekday = 2
        }
    }
    
    @CasePathable
    enum Action: Equatable {
        case view(ViewAction)
        case inner(InnerAction)
        
        @CasePathable
        enum ViewAction: Equatable {
            case onAppear
            case scrollChanged(DayModel.ID?)
            case dayTapped(DayModel)
            case weekdayHeaderTapped(Int)
            case changeNutrient(NutrientType)
            case changeList
        }
        
        @CasePathable
        enum InnerAction: Equatable {
            case on
        }
    }
    
    
    var body: some Reducer<State, Action> {
        CombineReducers {
            viewReducer
            innerReducer
        }
    }
}

extension CalendarReducer {
    var viewReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .view(viewAction) = action else { return .none }
            
            return self.handleViewAction(state: &state, action: viewAction)
        }
    }
}

extension CalendarReducer {
    var innerReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .inner(innerAction) = action else { return .none }
            
            return self.handleInnerAction(state: &state, action: innerAction)
        }
    }
}
