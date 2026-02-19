//
//  PageControl.swift
//  PagenationCalendar
//
//  Created by Gab on 2/19/26.
//

import SwiftUI

struct PageControl: View {
    let numberOfPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                let isSelected = index == selectedPage

                RoundedRectangle(cornerRadius: 3)
                    .fill(isSelected ? Color(hex: "2d3238") : Color(hex: "e2e5e9"))
                    .frame(width: isSelected ? 12 : 6, height: 6)
            }
        }
        .animation(.snappy, value: selectedPage)
    }

    private var selectedPage: Int {
        guard numberOfPages > 0 else { return 0 }
        return min(max(currentPage, 0), numberOfPages - 1)
    }
}

#Preview {
    PageControl(numberOfPages: 10, currentPage: 1)
}
