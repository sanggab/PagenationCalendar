//
//  NutrientDetailReducer + View.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import ComposableArchitecture

extension NutrientDetailReducer {
    func handleViewAction(state: inout NutrientDetailReducer.State, action viewAction: NutrientDetailReducer.Action.ViewAction) -> Effect<Action> {
        switch viewAction {
        case .view:
            return .none
        }
    }
}
