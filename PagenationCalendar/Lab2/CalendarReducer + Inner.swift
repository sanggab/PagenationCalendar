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
        case .determineWaterIntakeGuildText:
            return innerDetermineWaterIntakeGuildText(&state)
        }
    }
}

// MARK:
extension CalendarReducer {
    func innerDetermineWaterIntakeGuildText(_ state: inout CalendarReducer.State) -> Effect<Action> {
        switch state.currentWaterIntake {
        case 0.0:
            state.waterIntakeGuideText = .emptyRecord
        case ..<state.totalWaterIntakeGoal:
            state.waterIntakeGuideText = .inProgress
        default:
            state.waterIntakeGuideText = .goalAchieved
        }
        
        return .none
    }
}
