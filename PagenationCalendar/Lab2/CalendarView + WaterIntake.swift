//
//  CalendarView + WaterIntake.swift
//  PagenationCalendar
//
//  Created by Gab on 2/13/26.
//

import SwiftUI

import Lottie
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
            
            waterIntakeControlView
            
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
    var waterIntakeControlView: some View {
        HStack(spacing: 4) {
            decreaseWaterIntakeBtn
            
            waterWaveLottieView
            
            increaseWaterIntakeBtn
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
// MARK: 음수량 증가 / 감소 버튼
extension CalendarView {
    @ViewBuilder
    var decreaseWaterIntakeBtn: some View {
        Button {
            store.send(.view(.decreaseWaterIntake))
        } label: {
            Image("icon-minus")
        }
        .frame(width: 36, height: 36)
        .background(Color(hex: "f8f9fa"))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    @ViewBuilder
    var increaseWaterIntakeBtn: some View {
        Button {
            store.send(.view(.increaseWaterIntake))
        } label: {
            Image("icon-plus")
        }
        .frame(width: 36, height: 36)
        .background(Color(hex: "f8f9fa"))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

extension CalendarView {
    @ViewBuilder
    var waterWaveLottieView: some View {
        ZStack {
            cupImage
            
            LottieView(animation: .named("water_wave"))
                .resizable()
                .configure(\.contentMode, to: .scaleToFill)
                .looping()
                .frame(width: 128, height: 160)
                .offset(y: waveVerticalOffset)
                .mask {
                    cupImage
                }
                .animation(
                    .timingCurve(
                        0.0,
                        0.0,
                        0.58,
                        1.0,
                        duration: 0.3
                    ),
                    value: waveVerticalOffset
                )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 36)
    }
    
    private var cupImage: some View {
        Image("img-water-cup")
            .resizable()
            .scaledToFit()
            .frame(width: cupFrameSize.width, height: cupFrameSize.height)
    }
}
// MARK: WaterIntake Utils 모음
extension CalendarView {
    private var cupFrameSize: CGSize {
        CGSize(width: 128, height: 160)
    }
    
    private var waveVerticalOffset: CGFloat {
        (1.0 - waterFillRatio) * cupFrameSize.height
    }

    private var waterFillRatio: CGFloat {
        guard store.totalWaterIntakeGoal > 0 else { return 0 }

        let ratio = store.currentWaterIntake / store.totalWaterIntakeGoal
        return CGFloat(max(0, min(1, ratio)))
    }

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
