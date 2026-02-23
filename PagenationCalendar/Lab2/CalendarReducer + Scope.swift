//
//  CalendarReducer + Scope.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import ComposableArchitecture

extension CalendarReducer {
    func scopeDietCardDelegateAction(state: inout CalendarReducer.State, action: DietCardReducer.Action.DelegateAction) -> Effect<Action> {
        switch action {
        case .swipeActiveChanged(let id):
            state.activeDietSwipeCardID = id

            for index in state.dietCards.indices {
                state.dietCards[index].activeSwipeDietFoodID = id
            }

            return .none

        case .deleteRequested(let id):
            state.dietCards.remove(id: id)

            if state.activeDietSwipeCardID == id {
                state.activeDietSwipeCardID = nil
            }

            for index in state.dietCards.indices {
                state.dietCards[index].activeSwipeDietFoodID = state.activeDietSwipeCardID
            }

            return .none
        }
    }
}
