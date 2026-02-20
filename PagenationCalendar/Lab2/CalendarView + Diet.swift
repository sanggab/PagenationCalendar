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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.mint)
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
        .background(.orange)
        .padding(.leading, 16)
    }
}

extension CalendarView {
    
}
