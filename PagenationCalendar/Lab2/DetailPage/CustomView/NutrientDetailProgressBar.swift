//
//  NutrientDetailProgressBar.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

struct NutrientDetailProgressBar: View {
    let progress: CGFloat
    let remainingAmountText: String
    let comparisonLabelText: String

    @State private var animatedProgress: CGFloat = 0

    private var clampedProgress: CGFloat {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color(hex: "eff1f4"), lineWidth: 10)
            
            VStack(spacing: 2) {
                Text(remainingAmountText)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(hex: "121416"))
                
                Text(comparisonLabelText)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color(hex: "2d3238"))
            }
            
            Circle()
                .inset(by: 5)
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    .mint,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(270))
                .animation(
                    .timingCurve(
                        0,
                        0,
                        0.58,
                        1,
                        duration: 0.6
                    ).delay(0.2),
                    value: animatedProgress
                )
        }
        .onAppear {
            animatedProgress = clampedProgress
        }
        .onChange(of: progress) { _, newValue in
            animatedProgress = min(max(newValue, 0), 1)
        }
    }
}

#Preview {
    NutrientDetailProgressBar(
        progress: 0.1,
        remainingAmountText: "200g",
        comparisonLabelText: "남은 양"
    )
}
