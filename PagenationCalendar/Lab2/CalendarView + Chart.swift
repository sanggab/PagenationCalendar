//
//  CalendarView + Chart.swift
//  PagenationCalendar
//
//  Created by Gab on 2/11/26.
//

import SwiftUI

import ComposableArchitecture

extension CalendarView {
    @ViewBuilder
    var nutrientDashboardCard: some View {
        VStack(spacing: 12) {
            VStack(spacing: 20) {
                dailyCalorieGoal
                
                chartView
                
                nutrientGuidanceView
            }
            .padding(.all, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            .containerRelativeFrame(.horizontal)
            .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
            
            nutrientAnalysisView
        }
    }
}

extension CalendarView {
    @ViewBuilder
    var dailyCalorieGoal: some View {
        HStack(spacing: 0) {
            Text("일일 권장 kcal")
                .foregroundStyle(Color(hex: "41474e"))
            
            Spacer()
        }
    }
}

extension CalendarView {
    @ViewBuilder
    var chartView: some View {
        HalfCircleChart(
            [
                NutrientChartData(
                    type: .carbohydrate,
                    value: store.data.carbohydrates,
                    color: Color(hex: "ffb948")
                ),
                
                NutrientChartData(
                    type: .protein,
                    value: store.data.protein,
                    color: Color(hex: "8c72ff")
                ),
                
                NutrientChartData(
                    type: .fat,
                    value: store.data.fat,
                    color: Color(hex: "18cd8c")
                )
            ],
            total: 2500,
            configuration: .init(
                size: CGSize(
                    width: 240,
                    height: 120
                ),
                innerRadius: 0.65,
                outerRadius: 1.0,
                textPadding: 24, // 선 두께가 48이라 그 절반만큼 민다
                emptyColor: Color(hex: "eff1f4")
            )
        )
    }
}

extension CalendarView {
    @ViewBuilder
    var nutrientGuidanceView: some View {
        HStack(spacing: 0) {
            Text("어떤 음식을 드셨나요?")
                .padding(.leading, 16)
            
            Spacer()
            
            Rectangle()
                .fill(Color(hex: "c6ccd2"))
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, 2)
                .padding(.trailing, 12)
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "f8f9fa"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "eff1f4")))
    }
}

extension CalendarView {
    @ViewBuilder
    var nutrientAnalysisView: some View {
        HStack(spacing: 0) {
            ForEach(HalfCircleNutrientType.allCases, id: \.self) { nutrient in
                // TODO: Replace with actual nutrient analysis content
                // Placeholder content to avoid empty closure warnings
                
            }
        }
    }
}
