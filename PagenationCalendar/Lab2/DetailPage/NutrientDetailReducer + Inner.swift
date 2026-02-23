//
//  NutrientDetailReducer + Inner.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import ComposableArchitecture

extension NutrientDetailReducer {
    func handleInnerAction(state: inout NutrientDetailReducer.State, action innerAction: NutrientDetailReducer.Action.InnerAction) -> Effect<Action> {
        switch innerAction {
        case .inner:
            return .none
        }
    }
}

