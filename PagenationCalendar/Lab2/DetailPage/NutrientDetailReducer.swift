import SwiftUI

import ComposableArchitecture

@Reducer
struct NutrientDetailReducer {
    @ObservableState
    struct State: Equatable {
        struct NutrientDetailUIModel: Equatable {
            let recommendedIntakeText: String
            let actualIntakeText: String
            let comparisonAmountText: String
            let comparisonLabelText: String
            let progressRatio: CGFloat

            static let empty = NutrientDetailUIModel(
                recommendedIntakeText: "0g",
                actualIntakeText: "0g",
                comparisonAmountText: "0g",
                comparisonLabelText: "남은 양",
                progressRatio: 0
            )
        }

        struct NutrientDetailFoodRow: Equatable, Identifiable {
            let id: DietFood.ID
            let foodName: String
            let servingDescriptionText: String
            let nutrientAmountText: String
        }

        let nutrientType: NutrientType
        let nutrientData: NutrientData
        let dietFoods: [DietFood]

        var detailUIModel: NutrientDetailUIModel = .empty
        var foodRows: [NutrientDetailFoodRow] = []
    }

    @CasePathable
    enum Action: Equatable {
        case view(ViewAction)
        case inner(InnerAction)
        
        @CasePathable
        enum ViewAction: Equatable {
            case onAppear
        }
        
        @CasePathable
        enum InnerAction: Equatable {
            case prepareDisplayData
        }
    }

    var body: some Reducer<State, Action> {
        CombineReducers {
            viewReducer
            innerReducer
        }
    }
}

extension NutrientDetailReducer {
    var viewReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .view(viewAction) = action else { return .none }
            
            return self.handleViewAction(state: &state, action: viewAction)
        }
    }
}

extension NutrientDetailReducer {
    var innerReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .inner(innerAction) = action else { return .none }
            
            return self.handleInnerAction(state: &state, action: innerAction)
        }
    }
}
