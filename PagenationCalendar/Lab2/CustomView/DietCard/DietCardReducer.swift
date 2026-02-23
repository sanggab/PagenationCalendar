//
//  DietCardReducer.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct DietCardReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        let dietFood: DietFood

        var activeSwipeDietFoodID: DietFood.ID?
        var anchor: CGFloat = 0
        var hoffset: CGFloat = 0
        var rightPast = false

        let anchorWidth: CGFloat = 80
        let swipeTreshold: CGFloat = 25

        var id: DietFood.ID {
            dietFood.id
        }
        
        init(dietFood: DietFood) {
            self.dietFood = dietFood
            self.activeSwipeDietFoodID = nil
        }
    }
    
    @CasePathable
    enum Action: Equatable {
        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        
        @CasePathable
        enum ViewAction: Equatable {
            case horizontalDragChanged(CGFloat)
            case dragEnded
            case syncActiveSwipeCardID(DietFood.ID?)
            case deleteTapped
        }
        
        @CasePathable
        enum InnerAction: Equatable {
            case none
        }

        @CasePathable
        enum DelegateAction: Equatable {
            case swipeActiveChanged(DietFood.ID?)
            case deleteRequested(DietFood.ID)
        }
    }
    
    var body: some Reducer<State, Action> {
        CombineReducers {
            viewReducer
            innerReducer
        }
    }
}

extension DietCardReducer {
    var viewReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .view(viewAction) = action else { return .none }
            
            return self.handleViewAction(state: &state, action: viewAction)
        }
    }
}

extension DietCardReducer {
    var innerReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .inner(innerAction) = action else { return .none }
            
            return self.handleInnerAction(state: &state, action: innerAction)
        }
    }
}
