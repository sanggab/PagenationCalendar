//
//  ContentView.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import SwiftUI

import ComposableArchitecture

struct ContentView: View {
    var store: StoreOf<MainReducer>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                Text("Dashboard")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                calendarListView
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.gray.opacity(0.1))
        .task {
            store.send(.view(.onAppear))
        }
    }
}

extension ContentView {
    @ViewBuilder
    var calendarListView: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Month Year Title
            Text(store.currentWeekStart.format("MMM yyyy"))
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(-12...0, id: \.self) { offset in
                        weekView(for: offset)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollBounceBehavior(.basedOnSize)
            .scrollPosition(id: Binding(
                get: { store.focusedWeekOffset },
                set: { store.send(.view(.weekScrollChanged($0))) }
            ))
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .frame(height: 150)
    }
    
    @ViewBuilder
    func weekView(for offset: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(store.state.weekDates(for: offset)) { item in
                VStack(spacing: 8) {
                    Text(item.date.format("EEE"))
                        .font(.caption)
                        .foregroundStyle(item.isFuture ? .gray.opacity(0.3) : .gray)
                    
                    Text("\(item.day)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(item.isSelected ? .white : (item.isFuture ? .gray.opacity(0.3) : .black))
                        .frame(width: 36, height: 36)
                        .background {
                            if item.isSelected {
                                Circle()
                                    .fill(.black)
                            } else if item.isToday {
                                Circle()
                                    .strokeBorder(.gray, lineWidth: 1)
                            }
                        }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    if !item.isFuture {
                        store.send(.view(.dayTapped(item)))
                    }
                }
            }
        }
    }
}

extension ContentView {
    @ViewBuilder
    var test: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) { // HStack으로 감싸는 것이 핵심!
                ForEach(0..<10) { index in
                    Rectangle()
                        .fill(.blue.opacity(Double(index) / 10.0)) // opacity 값 조절 (0~1 사이)
                        // 1. 가로로 꽉 채우고 싶다면 .horizontal, 세로로 꽉 채우고 싶다면 .vertical
                        .containerRelativeFrame(.vertical)
                        .containerRelativeFrame(.horizontal) // 한 페이지씩 보고 싶을 때
                }
            }
        }
        // 2. ScrollView 자체는 일반 프레임으로 잡아주세요.
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    ContentView(
        store: Store(
            initialState: MainReducer.State(),
            reducer: { MainReducer() }
        )
    )
}
