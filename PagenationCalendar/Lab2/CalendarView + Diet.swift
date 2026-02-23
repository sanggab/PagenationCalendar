//
//  CalendarView + Diet.swift
//  PagenationCalendar
//
//  Created by Gab on 2/20/26.
//

import SwiftUI

import ComposableArchitecture

extension CalendarView {
    @ViewBuilder
    var dietHistoryList: some View {
        VStack(spacing: 12) {
            dietHistoryTitle
            dietCardAddBtn
//            dietCardList
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension CalendarView {
    @ViewBuilder
    var dietHistoryTitle: some View {
        HStack(spacing: 0) {
            Text("식단")
                .font(.system(size: 20, weight: .bold))
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

extension CalendarView {
    @ViewBuilder
    var dietCardAddBtn: some View {
        Button {
            
        } label: {
            VStack(spacing: 10) {
                Text("오늘 먹은 음식을 기록해 보세요")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(hex: "6e7881"))
                    .multilineTextAlignment(.center)
                
                Image("img-add-empty")
            }
            .frame(height: 112)
            .frame(maxWidth: .infinity)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

extension CalendarView {
    @ViewBuilder
    var dietCardList: some View {
        LazyVStack(spacing: 12) {
            ForEach(store.scope(state: \.dietCards, action: \.scope.dietCards)) { cardStore in
                DietCardView(store: cardStore)
            }
        }
    }
}
