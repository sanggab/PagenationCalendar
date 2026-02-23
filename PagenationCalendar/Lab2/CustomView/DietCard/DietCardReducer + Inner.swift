//
//  DietCardReducer + Inner.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import ComposableArchitecture

extension DietCardReducer {
    func handleInnerAction(state: inout DietCardReducer.State, action innerAction: DietCardReducer.Action.InnerAction) -> Effect<Action> {
        switch innerAction {
        case .none:
            return .none
        }
    }
}
