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
    // MARK: nutrientDashboardCard
    @ViewBuilder
    var nutrientDashboardCard: some View {
        VStack(spacing: 12) {
            
            nutrientInsightView
            
            nutrientAnalysisView
        }
        .frame(height: 360)
        .containerRelativeFrame(.horizontal)
        .background(.blue)
    }
}

extension CalendarView {
    // MARK: nutrientInsightView
    @ViewBuilder
    var nutrientInsightView: some View {
        VStack(spacing: 20) {
            dailyCalorieGoal
            
            chartView
            
            nutrientGuidanceView
        }
        .background(.mint)
        .padding(.all, 16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

extension CalendarView {
    // MARK: dailyCalorieGoal
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
    // MARK: chartView
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
    // MARK: nutrientGuidanceView
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
    // MARK: nutrientAnalysisView
    @ViewBuilder
    var nutrientAnalysisView: some View {
        HStack(spacing: 0) {
            ForEach(Array(NutrientType.allCases.enumerated()), id: \.element) { (index, nutrient) in
                nutrientEvaluationCell(type: nutrient)
                
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
        .padding(.horizontal, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
    }
}

extension CalendarView {
    // MARK: nutrientEvaluationCell
    @ViewBuilder
    func nutrientEvaluationCell(type nutrient: NutrientType) -> some View{
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                nutrient.image
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "eff1f4"))
                    .frame(width: 29, height: 20)
                    .overlay {
                        nutrientIntakeStatusText(type: nutrient)
                    }
            }
            
            nutrientStatusView(type: nutrient)
                .frame(height: 25)
        }
        .containerRelativeFrame(.horizontal) { length, axis in
            switch axis {
            case .horizontal:
                // 32는 safeArea에서 horizontal 16 패딩 값
                // 24는 nutrientAnalysisView horizontal 좌우 12 패딩 값
                // width 1인 Divider 2개 값
                return (length - 24 - 32 - 2) / 3
            case .vertical:
                return 53
            }
        }
        .onTapGesture {
            store.send(.view(.changeNutrient(nutrient)))
        }
    }
}

extension CalendarView {
    // MARK: nutrientStatusView
    @ViewBuilder
    func nutrientStatusView(type nutrient: NutrientType) -> some View {
        HStack(spacing: 4) {
            targetNutrientView(type: nutrient)
            goalNutrientView(type: nutrient)
        }
    }
    // MARK: targetNutrientView
    @ViewBuilder
    func targetNutrientView(type nutrient: NutrientType) -> some View {
        Group {
            switch nutrient {
            case .carbohydrate:
                Text("\(Int(store.carbs.value.rounded()))")
                    .contentTransition(.numericText(value: store.carbs.value))
                    .animation(.linear, value: store.carbs.value)
            case .protein:
                Text("\(Int(store.protein.value.rounded()))")
                    .contentTransition(.numericText(value: store.protein.value))
                    .animation(.linear, value: store.protein.value)
            case .fat:
                Text("\(Int(store.fat.value.rounded()))")
                    .contentTransition(.numericText(value: store.fat.value))
                    .animation(.linear, value: store.fat.value)
            }
        }
        .font(.system(size: 18, weight: .bold))
        .foregroundStyle(Color(hex: "2d3238"))
    }
    // MARK: goalNutrientView
    @ViewBuilder
    func goalNutrientView(type nutrient: NutrientType) -> some View {
        Group {
            switch nutrient {
            case .carbohydrate:
                Text("/ \(Int(store.carbs.goal))")
                    .contentTransition(.numericText(value: store.carbs.goal))
                    .animation(.linear, value: store.carbs.goal)
            case .protein:
                Text("/ \(Int(store.protein.goal))")
                    .contentTransition(.numericText(value: store.protein.goal))
                    .animation(.linear, value: store.protein.goal)
            case .fat:
                Text("/ \(Int(store.fat.goal))")
                    .contentTransition(.numericText(value: store.fat.goal))
                    .animation(.linear, value: store.fat.goal)
            }
        }
        .font(.system(size: 13, weight: .medium))
        .foregroundStyle(Color(hex: "6e7881"))
    }
}

// MARK: nutrientIntakeStatusText
extension CalendarView {
    @ViewBuilder
    func nutrientIntakeStatusText(type nutrient: NutrientType) -> some View {
        let model = evaluateNutrientStatus(type: nutrient)
        
        Text(model.text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(model.color)
    }
    
    // MARK: evaluateNutrientStatus
    func evaluateNutrientStatus(type nutrient: NutrientType) -> (text: String, color: Color) {
        switch nutrient {
        case .carbohydrate:
            let carbs = store.carbs
            return (text: carbs.intakeStatus.id, color: carbs.intakeStatus.color)
            
        case .protein:
            let carbs = store.protein
            return (text: carbs.intakeStatus.id, color: carbs.intakeStatus.color)
            
        case .fat:
            let carbs = store.fat
            return (text: carbs.intakeStatus.id, color: carbs.intakeStatus.color)
        }
    }
}
