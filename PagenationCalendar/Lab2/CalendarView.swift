//
//  CalendarView.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import SwiftUI

import ComposableArchitecture

struct CalendarView: View {
    var store: StoreOf<CalendarReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            // Title
            Text(store.currentTitle)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(.mint)
                .padding(.horizontal)
                .padding(.vertical, 8)
//                .background(.blue)
            
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack(alignment: .top) {
                    LazyHStack(alignment: .top, spacing: 0) {
                        ForEach(store.model) { model in
                            weekView(for: model)
                        }
                    }
                    .scrollTargetLayout()
                }
            }
            .scrollTargetBehavior(.paging)
            .defaultScrollAnchor(.trailing)
            .scrollPosition(id: Binding(
                get: { store.currentScrollID },
                set: { store.send(.view(.scrollChanged($0))) }
            ))
//            .background(.orange.opacity(0.2))
        }
//        .padding(.horizontal, 16)
        .background(.gray.opacity(0.4))
        .task {
            store.send(.view(.onAppear))
        }
    }
}

extension CalendarView {
    @ViewBuilder
    func weekView(for model: DayModel) -> some View {
        VStack(spacing: 2) {
            Text(model.weekday)
            
            Text(model.dayString)
                .frame(width: 28, height: 28)
                .background(Circle().fill(.gray.opacity(0.5)))
            
            Circle()
                .fill(.black)
                .frame(width: 4, height: 4)
                .padding(.top, 10)
        }
        .containerRelativeFrame(.horizontal, count: 7, spacing: 0)
        .id(model.id)
        .onTapGesture {
            if !model.isFuture {
                store.send(.view(.dayTapped(model)))
            }
        }
    }
}

#Preview {
    CalendarView(
        store: Store(
            initialState: CalendarReducer.State(),
            reducer: { CalendarReducer() }
        )
    )
}
