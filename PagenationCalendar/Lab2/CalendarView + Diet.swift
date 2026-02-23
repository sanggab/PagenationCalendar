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
            dietCardList
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
    var dietCardList: some View {
        LazyVStack(spacing: 12) {
            ForEach(store.scope(state: \.dietCards, action: \.scope.dietCards)) { cardStore in
                DietCardView(store: cardStore)
            }
        }
    }
}
