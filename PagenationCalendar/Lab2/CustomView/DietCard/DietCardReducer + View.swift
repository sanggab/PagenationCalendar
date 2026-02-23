//
//  DietCardReducer + View.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import ComposableArchitecture

extension DietCardReducer {
    func handleViewAction(state: inout DietCardReducer.State, action viewAction: DietCardReducer.Action.ViewAction) -> Effect<Action> {
        switch viewAction {
        case .horizontalDragChanged(let value):
            return viewHorizontalDragChangedAction(&state, value: value)

        case .dragEnded:
            return viewDragEndedAction(&state)

        case .syncActiveSwipeCardID(let id):
            return viewSyncActiveSwipeCardIDAction(&state, id: id)

        case .deleteTapped:
            return .send(.delegate(.deleteRequested(state.id)))
        }
    }
}

extension DietCardReducer {
    func viewHorizontalDragChangedAction(_ state: inout DietCardReducer.State, value: CGFloat) -> Effect<Action> {
        let shouldBecomeActive = value < 0 && state.activeSwipeDietFoodID != state.id

        state.hoffset = state.anchor + value

        if state.hoffset > 0 {
            state.hoffset = 0
        }

        if -state.hoffset > state.anchorWidth {
            state.hoffset = -state.anchorWidth

            if state.rightPast {
                state.hoffset = -state.anchorWidth
            }
        }

        if state.anchor < 0 {
            state.rightPast = state.hoffset < -state.anchorWidth + state.swipeTreshold
        } else {
            state.rightPast = state.hoffset < -state.swipeTreshold
        }

        if shouldBecomeActive {
            return .send(.delegate(.swipeActiveChanged(state.id)))
        }

        return .none
    }
}

extension DietCardReducer {
    func viewDragEndedAction(_ state: inout DietCardReducer.State) -> Effect<Action> {
        let targetAnchor: CGFloat = state.rightPast ? -state.anchorWidth : 0

        state.anchor = targetAnchor
        state.hoffset = targetAnchor

        if targetAnchor < 0 {
            if state.activeSwipeDietFoodID != state.id {
                return .send(.delegate(.swipeActiveChanged(state.id)))
            }
        } else if state.activeSwipeDietFoodID == state.id {
            return .send(.delegate(.swipeActiveChanged(nil)))
        }

        return .none
    }
}

extension DietCardReducer {
    func viewSyncActiveSwipeCardIDAction(_ state: inout DietCardReducer.State, id: DietFood.ID?) -> Effect<Action> {
        state.activeSwipeDietFoodID = id

        guard id != state.id else {
            return .none
        }

        guard state.anchor < 0 || state.rightPast else {
            return .none
        }

        state.rightPast = false
        state.anchor = 0
        state.hoffset = 0

        return .none
    }
}
