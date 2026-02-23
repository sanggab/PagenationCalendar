//
//  NutrientDetailReducer.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import SwiftUI

import ComposableArchitecture

@Reducer
struct NutrientDetailReducer {
    @ObservableState
    struct State: Equatable {
        
        init() {

        }
    }
    
    @CasePathable
    enum Action: Equatable {
        case view(ViewAction)
        case inner(InnerAction)
        
        @CasePathable
        enum ViewAction: Equatable {
            case view
        }
        
        @CasePathable
        enum InnerAction: Equatable {
            case inner
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
