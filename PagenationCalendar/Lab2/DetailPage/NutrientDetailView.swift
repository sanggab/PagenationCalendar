//
//  NutrientDetailView.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

struct NutrientDetailView: View {
    var body: some View {
        VStack(spacing: 0) {
            header
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension NutrientDetailView {
    @ViewBuilder
    var header: some View {
        HStack(spacing: 4) {
            Button {
                
            } label: {
                Image("icon-arrow-left")
                    .padding(.all, 8)
                    .background(.mint)
            }
            
            Text("탄수화물")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: "222529"))
            
            Spacer()
        }
        .frame(height: 40)
        .padding(.vertical, 8)
        .background(.blue)
        .padding(.leading, 8)
        .padding(.trailing ,12)
    }
}

#Preview {
    NutrientDetailView()
}
