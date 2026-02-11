//
//  CalendarView + Chart.swift
//  PagenationCalendar
//
//  Created by Gab on 2/11/26.
//

import SwiftUI

import ComposableArchitecture

extension CalendarView {
    // TODO: shadow때문에 이상해지는 거 고치기
    @ViewBuilder
    var nutrientDashboardCard: some View {
        VStack(spacing: 12) {
            VStack(spacing: 20) {
                dailyCalorieGoal
                
                chartView
                
                nutrientGuidanceView
            }
            .padding(.all, 16)
            .background(.mint)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
//            .padding(.horizontal, 16)
//            .containerRelativeFrame(.horizontal)
            
            nutrientAnalysisView
        }
//        .frame(width: cellWidth)
//        .frame(maxWidth: .infinity)
        .background(.blue)
    }
}

extension CalendarView {
    @ViewBuilder
    var dailyCalorieGoal: some View {
        HStack(spacing: 0) {
            Text("일일 권장 kcal")
                .font(.system(size: 15, weight: .medium))
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
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color(hex: "121416"))
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
            HStack(spacing: 0) {
                ForEach(Array(NutrientType.allCases.enumerated()), id: \.element) { (index, nutrient) in
                    // TODO: Replace with actual nutrient analysis content
                    // Placeholder content to avoid empty closure warnings
                    
                    VStack(spacing: 2) {
                        HStack(spacing: 4) {
                            nutrient.image
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: "eff1f4"))
                                .frame(width: 29, height: 20)
                                .overlay {
                                    Text("적정")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color(hex: "197dc4"))
                                }
                        }
                        .frame(height: 26)
                        
                        nutrientStatusView(nutrient)
                            .frame(height: 25)
                    }
                    .frame(width: ((cellWidth - 2 - 24) / 3))
                    
                    let count = NutrientType.allCases.count - 1
                    
                    if index != count {
                        Rectangle()
                            .fill(Color(hex: "eff1f4"))
                            .frame(width: 1)
                            .frame(height: 53)
                    }
                }
            }
            .padding(.vertical, 16)
            //padding horizontal 12안주는 이유는 cellWidth 계산할 때 24를 뺏기 때문
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
    }
    
    @ViewBuilder
    func nutrientStatusView(_ type: NutrientType) -> some View {
        HStack(spacing: 4) {
            switch type {
            case .carbohydrate:
                Text("\(Int(store.carbs.value.rounded()))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(hex: "2d3238"))
                
                Text("/ \(Int(store.carbs.goal))")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(hex: "6e7881"))
                
            case .protein:
                Text("\(Int(store.protein.value.rounded()))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(hex: "2d3238"))
                
                Text("/ \(Int(store.protein.goal))")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(hex: "6e7881"))
                
            case .fat:
                Text("\(Int(store.fat.value.rounded()))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(hex: "2d3238"))
                
                Text("/ \(Int(store.fat.goal))")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(hex: "6e7881"))
            }
        }
    }
}
