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
    
    
    // MARK: - View
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            Rectangle()
                .fill(.mint)
                .frame(height: 4)
            
            calendarView
            
//            Rectangle()
//                .fill(.mint)
//                .frame(height: 16)
            
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
                .font(.title2)
                .fontWeight(.bold)
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
            
            weeksView
        }
        .frame(height: 64)
    }
    
    @ViewBuilder
    var weekDaysView: some View {
        HStack(spacing: 0) {
            ForEach(store.weekdays.indices, id: \.self) { index in
                Text(store.weekdays[index])
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color(hex: "6e7881"))
                    .frame(width: cellWidth)
                    .onTapGesture {
                        store.send(.view(.weekdayHeaderTapped(index)))
                    }
            }
        }
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
                                    .frame(width: cellWidth)
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
        .background(.orange)
    }
}

extension CalendarView {
    @ViewBuilder
    var dailyHealthDashBoard: some View {
        VStack(spacing: 0) {
            infinityScrollView
            
            pageNationView
        }
        .frame(height: 360)
        .background(.blue)
    }
}

extension CalendarView {
    @ViewBuilder
    var infinityScrollView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                chartView
                
//                nutrientDetailView
//                
//                hydrationTrackerView
            }
        }
        .scrollTargetBehavior(.paging)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "ffffff"))
    }
    
    @ViewBuilder
    var pageNationView: some View {
        Rectangle()
            .fill(.mint)
            .frame(width: 30, height: 6)
    }
}

extension CalendarView {
    @ViewBuilder
    var chartView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(hex: "ffb948"))
            .shadow(color: Color(hex: "2d3238"), radius: 10, x: 0, y: 1)
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("일일 권장 칼로리")
                        .foregroundStyle(Color(hex: "41474e"))
                    
                    
                    HStack(spacing: 0) {
                        Text("어떤 음식을 드셨나요?")
                            .padding(.leading, 16)
                        
                        Spacer()
                        
                        Rectangle()
                            .fill(Color(hex: "c6ccd2"))
                            .aspectRatio(contentMode: .fit)
                            .padding(.vertical, 2)
                            .padding(.trailing, 12)
                    }
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "f8f9fa"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "eff1f4")))

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 16)
            }
            .padding(.horizontal, 16)
            .containerRelativeFrame(.horizontal)
    }
}

extension CalendarView {
    @ViewBuilder
    var nutrientDetailView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(hex: "8c72ff"))
            .padding(.horizontal, 16)
            .shadow(color: Color(hex: "2d3238"), radius: 10, x: 0, y: 1)
            .containerRelativeFrame(.horizontal)
    }
}

extension CalendarView {
    @ViewBuilder
    var hydrationTrackerView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(hex: "18cd8c"))
            .padding(.horizontal, 16)
            .shadow(color: Color(hex: "2d3238"), radius: 10, x: 0, y: 1)
            .containerRelativeFrame(.horizontal)
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
    func isForegrounsStyleColor(for model: DayModel) -> Color {
        if model.isSelected {
            return Color(hex: "ffffff")
        } else if model.isWritted {
            return Color(hex: "2d3238")
        } else {
            return Color(hex: "6e7881")
        }
    }
    
    func isBackgroundColor(for model: DayModel) -> Color {
        if model.isFuture {
            return Color(hex: "eff1f4")
        } else {
            return model.isSelected ? Color(hex: "2d3238") : Color(hex: "eff1f4")
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
