//
//  CalendarReducer + Inner.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import Foundation

import ComposableArchitecture

extension CalendarReducer {
    func handleInnerAction(state: inout CalendarReducer.State, action innerAction: CalendarReducer.Action.InnerAction) -> Effect<Action> {
        switch innerAction {
        case .on:
            return .none
        }
    }
}

// MARK:
extension CalendarReducer {
    func innerSetAction(_ state: inout CalendarReducer.State) -> Effect<Action> {
        return .none
    }
}
