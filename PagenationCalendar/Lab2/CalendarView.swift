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
    
    private var cellWidth: CGFloat {
        (UIScreen.main.bounds.width - 32) / 7
    }
    
    private let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    
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
            
            let weekCount = store.model.count / 7
            let fullWeeks = Array(store.model.prefix(weekCount * 7))
            let weeks = fullWeeks.chunked(into: 7)
            
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .frame(width: cellWidth)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 0) {
                    LazyHStack(alignment: .top, spacing: 0) {
                        
                        ForEach(weeks, id: \.first?.id) { weekDays in
                            HStack(alignment: .top, spacing: 0) {
                                ForEach(weekDays) { model in
                                    weekView(for: model)
                                        .frame(width: cellWidth)
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(width: UIScreen.main.bounds.width)
                            .id(weekDays.first?.id)
                        }
                    }
                    .scrollTargetLayout()
                    .frame(height: 50)
                    .background(.orange)
                    
                }
            }
            .scrollTargetBehavior(.paging)
            .defaultScrollAnchor(.trailing)
            .scrollPosition(id: Binding(
                get: { store.currentScrollID },
                set: { store.send(.view(.scrollChanged($0))) }
            ))
            
            NutrientHalfDonutChart(
                data: DailyNutrition(
                    carbs: store.carbs,
                    protein: store.protein,
                    fat: store.fat,
                    totalCaloriesGoal: store.totalCaloriesGoal
                )
            )
            
            HStack(spacing: 30) {
                Button {
                    store.send(.view(.changeNutrient(.carbohydrate)))
                } label: {
                    Text("칼로리 변화")
                }

                Button {
                    store.send(.view(.changeNutrient(.protein)))
                } label: {
                    Text("단백질 변화")
                }
                
                Button {
                    store.send(.view(.changeNutrient(.fat)))
                } label: {
                    Text("지방 변화")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
            
            Text(model.dayString)
                .frame(width: 28, height: 28)
                .background(Circle().fill(isBackgroundColor(for: model)))
            
            if model.isSelected || model.isWritted {
                Circle()
                    .fill(model.isSelected ? .black : .red)
                    .frame(width: 4, height: 4)
                    .padding(.top, 10)
            }
        }
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

extension CalendarView {
    func isBackgroundColor(for model: DayModel) -> Color {
        if model.isFuture {
            return Color.gray
        } else {
            return model.isSelected ? Color.mint : Color.blue
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
