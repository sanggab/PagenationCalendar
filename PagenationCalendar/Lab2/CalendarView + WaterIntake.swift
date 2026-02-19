//
//  CalendarView + WaterIntake.swift
//  PagenationCalendar
//
//  Created by Gab on 2/13/26.
//

import SwiftUI

import SwiftUIToolTip
import ComposableArchitecture

extension CalendarView {
    @ViewBuilder
    var hydrationTrackerView: some View {
        ZStack {
            waterIntakeView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
                .padding(.horizontal, 16)
        }
        .frame(height: 360)
        .containerRelativeFrame(.horizontal)
        .background(.purple)
        .padding(.bottom ,4)
    }
}


extension CalendarView {
    @ViewBuilder
    var waterIntakeView: some View {
        VStack(spacing: 4) {
            waterToolTip
            
            waterAnimationView
            
            waterIntakeStatusView
        }
    }
    
    @ViewBuilder
    var waterToolTip: some View {
        Text(store.waterIntakeGuideText.rawValue)
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(Color(hex: "121416"))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .toolTip {
                ToolTipModel(
                    style: .fillWithStrokeBorder,
                    mode: .flexible,
                    tailSize: CGSize(
                        width: 16,
                        height: 8
                    ),
                    tailPosition: .bottom,
                    tailAlignment: .center,
                    movePoint: .zero,
                    cornerRadius: 18,
                    fillColor: Color(hex: "eff1f4"),
                    strokeColor: Color(hex: "eff1f4"),
                    strokeStyle: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }
    }
    
    @ViewBuilder
    var waterAnimationView: some View {
        HStack(spacing: 4) {
            Button {
                store.send(.view(.decreaseWaterIntake))
            } label: {
                Image("icon-minus")
            }
            .frame(width: 36, height: 36)
            .background(Color(hex: "f8f9fa"))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            Image("img-water-cup")
                .padding(.vertical, 20)
                .padding(.horizontal, 36)
                .background(.pink)
            
            Button {
                store.send(.view(.increaseWaterIntake))
            } label: {
                Image("icon-plus")
            }
            .frame(width: 36, height: 36)
            .background(Color(hex: "f8f9fa"))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(.top, 4)
    }
    
    @ViewBuilder
    var waterIntakeStatusView: some View {
        Text(waterIntakeStatusAttributedText)
            .monospacedDigit()
            .contentTransition(.numericText(value: store.currentWaterIntake))
            .animation(.snappy, value: store.currentWaterIntake)
            .animation(.snappy, value: store.totalWaterIntakeGoal)
        .frame(height: 36)
    }
}

extension CalendarView {
    private var waterIntakeNumberFormat: FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(1...2))
    }

    private var waterIntakeStatusAttributedText: AttributedString {
        let currentColor = store.currentWaterIntake >= store.totalWaterIntakeGoal ? Color(hex: "0d90fb")
                                                                                  : Color(hex: "121416")
        
        var current = AttributedString("\(store.currentWaterIntake.formatted(waterIntakeNumberFormat))L")
        current.font = .system(size: 26, weight: .bold)
        current.foregroundColor = currentColor

        var goal = AttributedString(" / \(store.totalWaterIntakeGoal.formatted(waterIntakeNumberFormat))L")
        goal.font = .system(size: 18, weight: .medium)
        goal.foregroundColor = Color(hex: "6e7881")

        current += goal
        return current
    }
}
