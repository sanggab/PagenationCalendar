//
//  MainReducer + Inner.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import Foundation

import ComposableArchitecture

extension MainReducer {
    func handleInnerAction(state: inout MainReducer.State, action innerAction: MainReducer.Action.InnerAction) -> Effect<Action> {
        switch innerAction {
        case let .updateWeek(value):
            if let newDate = state.calendar.date(byAdding: .weekOfYear, value: value, to: state.currentWeekStart) {
                state.currentWeekStart = newDate
                state.currentWeekDates = state.generateWeekDates(for: newDate)
            }
            return .none
            
        case let .updateSelectedDate(date):
            state.selectedDate = date
            
            if !state.currentWeekDates.contains(where: { state.calendar.isDate($0.date, inSameDayAs: date) }) {
                 state.currentWeekStart = date.startOfWeek(using: state.calendar)
                 state.currentWeekDates = state.generateWeekDates(for: state.currentWeekStart)
            } else {
                 state.currentWeekDates = state.generateWeekDates(for: state.currentWeekStart)
            }
            return .none
        }
    }
}
// MARK:
extension MainReducer {
    func innerSetAction(_ state: inout MainReducer.State) -> Effect<Action> {
        return .none
    }
}
