//
//  NutrientDetailReducer + View.swift
//  PagenationCalendar
//
//  Created by Gab on 2/24/26.
//

import SwiftUI

import ComposableArchitecture

extension NutrientDetailReducer {
    func handleViewAction(state: inout NutrientDetailReducer.State, action viewAction: NutrientDetailReducer.Action.ViewAction) -> Effect<Action> {
        switch viewAction {
        case .onAppear:
            return .send(.inner(.prepareDisplayData))
        }
    }
}
