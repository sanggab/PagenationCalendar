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
        HStack(spacing: 6) {
            currentTitle
            
            todayBtn
            
            Spacer()
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    var currentTitle: some View {
        Text(store.currentTitle)
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(Color(hex: "222529"))
            .padding(.leading, 20)
    }
    
    @ViewBuilder
    var todayBtn: some View {
        Button {
            store.send(.view(.todayTapped))
        } label: {
            HStack(spacing: 4) {
                Group {
                    Image("icon-reset")
                        .renderingMode(.template)
                    
                    Text("오늘")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(Color(hex: "41474e"))
            }
            .transaction { transaction in transaction.animation = nil }
        }
        .frame(width: 65, height: 28)
        .background(Color(hex: "eff1f4"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
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
    }
}

extension CalendarView {
    @ViewBuilder
    var dailyHealthDashBoard: some View {
        VStack(spacing: 20) {
            infinityScrollView
            
            pageNationView
        }
        .frame(height: 386)
        .padding(.top, 16)
    }
}

extension CalendarView {
    @ViewBuilder
    var infinityScrollView: some View {
        // 핵심 원리:
        // 1) 실제 3페이지를 여러 사이클로 반복 렌더한다.
        // 2) 사용자가 넘길 때마다 "스크롤 인덱스"는 계속 증가/감소한다.
        // 3) 리듀서에서 가장자리 접근 시 중앙으로 재배치해 끝이 없는 것처럼 유지한다.
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(0..<store.totalDashboardScrollableItemCount, id: \.self) { index in
                    dashboardCardView(for: dashboardPageIndex(forInfiniteIndex: index))
                        .id(index)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: Binding(
            get: { store.currentDashboardScrollPosition },
            set: { store.send(.view(.dashboardPageChanged($0))) }
        ))
        .frame(height: 360)
    }
    
    @ViewBuilder
    var pageNationView: some View {
        PageControl(
            numberOfPages: store.totalDashboardPage,
            currentPage: store.currentDashboardPage
        )
    }

    private func dashboardPageIndex(forInfiniteIndex index: Int) -> Int {
        guard store.totalDashboardPage > 0 else {
            return 0
        }

        // 반복 리스트 인덱스를 실제 페이지 인덱스(0...2)로 매핑한다.
        // 예: 0,3,6... -> 0 / 1,4,7... -> 1 / 2,5,8... -> 2
        return index % store.totalDashboardPage
    }

    @ViewBuilder
    private func dashboardCardView(for page: Int) -> some View {
        switch page {
        case 0:
            nutrientDashboardCard

        case 1:
            otherNutrientIntakeSummary

        default:
            hydrationTrackerView
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
