//
//  MainReducer.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import SwiftUI

import ComposableArchitecture



@Reducer
struct MainReducer {
    @ObservableState
    struct State: Equatable {
//        var calenderList:
    }
    
    @CasePathable
    enum Action: Equatable {
        case view(ViewAction)
        case inner(InnerAction)
        
        
        @CasePathable
        enum ViewAction: Equatable {
            case on
        }
        
        @CasePathable
        enum InnerAction: Equatable {
            case on
        }
    }
    
    
    var body: some Reducer<State, Action> {
        CombineReducers {
            viewReducer
            innerReducer
        }
    }
}

extension MainReducer {
    var viewReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .view(viewAction) = action else { return .none }
            
            switch viewAction {
            case .on:
                return .none
            }
        }
    }
}

extension MainReducer {
    var innerReducer: some ReducerOf<Self> {
        Reduce { state, action in
            guard case let .inner(innerAction) = action else { return .none }
            
            switch innerAction {
            case .on:
                return .none
            }
        }
    }
}
