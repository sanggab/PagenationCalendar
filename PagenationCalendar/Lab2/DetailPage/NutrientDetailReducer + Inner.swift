//
//  NutrientDetailReducer + Inner.swift
//  PagenationCalendar
//
//  Created by Gab on 2/24/26.
//

import SwiftUI

import ComposableArchitecture

extension NutrientDetailReducer {
    func handleInnerAction(state: inout NutrientDetailReducer.State, action innerAction: NutrientDetailReducer.Action.InnerAction) -> Effect<Action> {
        switch innerAction {
        case .prepareDisplayData:
            return innerPrepareDisplayDataAction(&state)
        }
    }
}

extension NutrientDetailReducer {
    func innerPrepareDisplayDataAction(_ state: inout NutrientDetailReducer.State) -> Effect<Action> {
        state.detailUIModel = makeDetailUIModel(
            nutrientType: state.nutrientType,
            nutrientData: state.nutrientData
        )
        state.foodRows = makeFoodRows(
            nutrientType: state.nutrientType,
            dietFoods: state.dietFoods
        )

        return .none
    }

    private func makeDetailUIModel(
        nutrientType: NutrientType,
        nutrientData: NutrientData
    ) -> NutrientDetailReducer.State.NutrientDetailUIModel {
        let goal = max(nutrientData.goal, 0)
        let intake = max(nutrientData.value, 0)

        let isOverGoal = intake > goal
        let comparisonAmount = isOverGoal ? (intake - goal) : max(goal - intake, 0)
        let progressRatio: CGFloat = goal > 0 ? CGFloat(intake / goal) : 0

        return .init(
            recommendedIntakeText: nutrientValueText(goal, nutrientType: nutrientType),
            actualIntakeText: nutrientValueText(intake, nutrientType: nutrientType),
            comparisonAmountText: nutrientValueText(comparisonAmount, nutrientType: nutrientType),
            comparisonLabelText: isOverGoal ? "초과량" : "남은 양",
            progressRatio: min(max(progressRatio, 0), 1)
        )
    }

    private func makeFoodRows(
        nutrientType: NutrientType,
        dietFoods: [DietFood]
    ) -> [NutrientDetailReducer.State.NutrientDetailFoodRow] {
        dietFoods.map { dietFood in
            .init(
                id: dietFood.id,
                foodName: dietFood.foodName,
                servingDescriptionText: servingDescriptionText(for: dietFood),
                nutrientAmountText: nutrientValueText(
                    nutrientAmount(for: nutrientType, in: dietFood),
                    nutrientType: nutrientType
                )
            )
        }
    }

    private func nutrientAmount(for nutrientType: NutrientType, in dietFood: DietFood) -> Double {
        switch nutrientType {
        case .carbohydrate:
            return dietFood.nutrition.carbohydratesG
        case .protein:
            return dietFood.nutrition.proteinG
        case .fat:
            return dietFood.nutrition.fatG
        case .sodium:
            return dietFood.nutrition.sodiumMg
        case .sugars:
            return dietFood.nutrition.sugarG
        case .fiber:
            return dietFood.nutrition.fiberG
        case .cholesterol:
            return dietFood.nutrition.cholesterolMg
        }
    }

    private func servingDescriptionText(for dietFood: DietFood) -> String {
        guard let servingSize = dietFood.servingSize else {
            return "총 내용량 정보 없음"
        }

        let unit = dietFood.servingUnit ?? ""
        let formattedSize = servingSize.formatted(.number.precision(.fractionLength(0...1)))

        return "총 내용량 \(formattedSize)\(unit)"
    }

    private func nutrientValueText(_ value: Double, nutrientType: NutrientType) -> String {
        let formattedValue = value.formatted(.number.precision(.fractionLength(0...1)))

        return "\(formattedValue) \(nutrientUnit(for: nutrientType))"
    }

    private func nutrientUnit(for nutrientType: NutrientType) -> String {
        switch nutrientType {
        case .sodium, .cholesterol:
            return "mg"
        default:
            return "g"
        }
    }
}
