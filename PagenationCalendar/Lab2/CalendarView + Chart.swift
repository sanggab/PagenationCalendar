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
        NutrientHalfDonutChart(
            data: DailyNutrition(
                carbs: store.carbs,
                protein: store.protein,
                fat: store.fat,
                totalCaloriesGoal: store.totalCaloriesGoal
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
            ForEach(NutrientType.allCases, id: \.self) { nutrient in
                // TODO: Replace with actual nutrient analysis content
                // Placeholder content to avoid empty closure warnings
                
                
            }
        }
        .frame(maxWidth: .infinity)
        .background(.mint)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
    }
}
