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
        case let .updateSelectedDate(date):
            state.selectedDate = date
            state.updateCurrentWeekDates()
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
