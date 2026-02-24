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

        case .prepareNutrientDetailPayload(let nutrientType):
            return innerPrepareNutrientDetailPayloadAction(&state, nutrientType: nutrientType)
        }
    }
}

// MARK:
extension CalendarReducer {
    func innerPrepareNutrientDetailPayloadAction(
        _ state: inout CalendarReducer.State,
        nutrientType: NutrientType
    ) -> Effect<Action> {
        let nutrientData: NutrientData
        switch nutrientType {
        case .carbohydrate:
            nutrientData = state.carbs
        case .protein:
            nutrientData = state.protein
        case .fat:
            nutrientData = state.fat
        case .sodium:
            nutrientData = state.sodium
        case .sugars:
            nutrientData = state.sugars
        case .fiber:
            nutrientData = state.fiber
        case .cholesterol:
            nutrientData = state.chol
        }

        let dietFoods: [DietFood] = state.dietCards
            .map(\.dietFood)
            .filter { dietFood in
                switch nutrientType {
                case .carbohydrate:
                    return dietFood.nutrition.carbohydratesG > 0
                case .protein:
                    return dietFood.nutrition.proteinG > 0
                case .fat:
                    return dietFood.nutrition.fatG > 0
                case .sodium:
                    return dietFood.nutrition.sodiumMg > 0
                case .sugars:
                    return dietFood.nutrition.sugarG > 0
                case .fiber:
                    return dietFood.nutrition.fiberG > 0
                case .cholesterol:
                    return dietFood.nutrition.cholesterolMg > 0
                }
            }

        state.selectedNutrientPayload = .init(
            nutrientType: nutrientType,
            nutrientData: nutrientData,
            dietFoods: dietFoods
        )
        state.isNutrientDetailPresented = true

        return .none
    }

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
