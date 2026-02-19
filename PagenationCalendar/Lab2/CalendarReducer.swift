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
        
        // 실제 콘텐츠 페이지 수(대시보드/부가영앙소/음수량)
        var totalDashboardPage: Int = 3
        // 페이지네이션 표시용 인덱스(항상 0...totalDashboardPage-1)
        var currentDashboardPage: Int = 0
        // ScrollView가 현재 보고 있는 "반복 리스트"의 실제 인덱스
        var currentDashboardScrollPosition: Int?
        // 무한처럼 보이게 만들기 위해 실제 페이지를 몇 번 반복해서 렌더할지
        // 값이 클수록 끝에 도달하기 전까지 더 오래 스크롤 가능
        var dashboardInfiniteCycleCount: Int = 120

        // ScrollView에 그릴 전체 아이템 수(페이지 3개 * 반복 횟수)
        var totalDashboardScrollableItemCount: Int {
            totalDashboardPage * dashboardInfiniteCycleCount
        }

        // 초기 진입/재센터링 기준 인덱스
        // 가운데 사이클의 첫 페이지를 기준으로 잡아 양쪽으로 충분한 여유를 둔다.
        var dashboardCenterScrollPosition: Int {
            (dashboardInfiniteCycleCount / 2) * totalDashboardPage
        }
        
        var weekdays: [String] = []
        
        var carbs = NutrientData(type: .carbohydrate, value: 0, goal: 300)
        var protein = NutrientData(type: .protein, value: 0, goal: 120)
        var fat = NutrientData(type: .fat, value: 0, goal: 50)
        var sodium = NutrientData(type: .sodium, value: 0, goal: 50)
        var sugars = NutrientData(type: .sugars, value: 0, goal: 50)
        var fiber = NutrientData(type: .fiber, value: 0, goal: 50)
        var chol = NutrientData(type: .cholesterol, value: 0, goal: 50)
        
        
        var totalCaloriesGoal: Double = 2500
        var currentCalories: Double = 0
        // 캘린더 작성 됬는 지
        var isWrite: Bool = false
        
        var totalWaterIntakeGoal: Double = 3.5
        var currentWaterIntake: Double = 0.0
        var waterIntakeStep: Double = 0.25
        
        var waterIntakeGuideText: WaterIntakeGuildText = .emptyRecord
        
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
            case todayTapped
            case dayTapped(DayModel)
            case weekdayHeaderTapped(Int)
            case changeNutrient(NutrientType)
            case dashboardPageChanged(Int?)
            case increaseWaterIntake
            case decreaseWaterIntake
        }
        
        @CasePathable
        enum InnerAction: Equatable {
            case determineWaterIntakeGuildText
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
