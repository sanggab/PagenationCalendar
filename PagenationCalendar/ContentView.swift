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
