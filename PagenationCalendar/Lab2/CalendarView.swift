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
    
    var cellWidth: CGFloat {
        (UIScreen.main.bounds.width - 32)
    }
    
    @Namespace var anim
    
    
    // MARK: - View
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            Rectangle()
                .fill(.clear)
                .frame(height: 4)
            
            calendarView
            
            contentView
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(hex: "f8f9fa"))
        .task {
            store.send(.view(.onAppear))
        }
    }
}

extension CalendarView {
    @ViewBuilder
    var headerView: some View {
        HStack {
            Text(store.currentTitle)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(hex: "222529"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
    }
}

extension CalendarView {
    @ViewBuilder
    var calendarView: some View {
        VStack(spacing: 2) {
            weekDaysView
                .background(.gray)
            
            weeksView
                .background(.orange)
        }
        .frame(height: 64)
    }
    
    @ViewBuilder
    var weekDaysView: some View {
        HStack(spacing: 0) {
            ForEach(store.weekdays.indices, id: \.self) { index in
                Text(store.weekdays[index])
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(hex: "6e7881"))
                    .frame(width: cellWidth / 7)
                    .onTapGesture {
                        store.send(.view(.weekdayHeaderTapped(index)))
                    }
            }
        }
        .padding(.top, 4)
    }
    
    @ViewBuilder
    var weeksView: some View {
        let weekCount = store.model.count / 7
        let fullWeeks = Array(store.model.prefix(weekCount * 7))
        let weeks = fullWeeks.chunked(into: 7)
        
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 0) {
                LazyHStack(alignment: .top, spacing: 0) {
                    
                    ForEach(weeks, id: \.first?.id) { weekDays in
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(weekDays) { model in
                                weekView(for: model)
                                    .frame(width: cellWidth / 7)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(width: UIScreen.main.bounds.width)
                        .id(weekDays.first?.id)
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
    }
}

extension CalendarView {
    @ViewBuilder
    func weekView(for model: DayModel) -> some View {
        VStack(spacing: 6) {
            Text(model.dayString)
                .font(.system(size: 13, weight: .semibold))
                .frame(width: 28, height: 28)
                .foregroundStyle(isForegrounsStyleColor(for: model))
                .background(Circle().fill(isBackgroundColor(for: model)))
            
            if model.isSelected || model.isWritted && !model.isFuture {
                Circle()
                    .fill(model.isSelected ? Color(hex: "41474e") : Color(hex: "f58a7c"))
                    .frame(width: 4, height: 4)
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

extension CalendarView {
    @ViewBuilder
    var contentView: some View {
        ScrollView(.vertical) {
            dailyHealthDashBoard
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.orange)
    }
}

extension CalendarView {
    @ViewBuilder
    var dailyHealthDashBoard: some View {
        VStack(spacing: 16) {
            infinityScrollView
            
            pageNationView
        }
        .frame(height: 386)
        .padding(.top, 20)
        .background(.pink)
    }
}

extension CalendarView {
    @ViewBuilder
    var infinityScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
//                nutrientDashboardCard
//                
//                otherNutrientIntakeSummary
//
                hydrationTrackerView
            }
        }
        .scrollTargetBehavior(.paging)
        .background(.orange)
    }
    
    @ViewBuilder
    var pageNationView: some View {
        Rectangle()
            .fill(.mint)
            .frame(width: 30, height: 6)
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
