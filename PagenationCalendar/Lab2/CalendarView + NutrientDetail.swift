//
//  CalendarView + NutrientDetail.swift
//  PagenationCalendar
//
//  Created by Gab on 2/12/26.
//

import SwiftUI

import ComposableArchitecture

extension CalendarView {
    @ViewBuilder
    var otherNutrientIntakeSummary: some View {
        ZStack {
            additionalNutritionView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
                .padding(.horizontal, 16)
        }
        .containerRelativeFrame(.horizontal)
    }
}

extension CalendarView {
    @ViewBuilder
    var additionalNutritionView: some View {
        VStack(spacing: 16) {
            ohterNutrientTitle
            
            otherNutrientList
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
        .padding(.horizontal, 16)
    }
}

extension CalendarView {
    @ViewBuilder
    var ohterNutrientTitle: some View {
        Text("부가 영양소")
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Color(hex: "121416"))
            .frame(height: 25)
            .frame(maxWidth: .infinity)
    }
}

extension CalendarView {
    @ViewBuilder
    var otherNutrientList: some View {
        let list: [NutrientType] = [.sodium, .sugars, .fiber, .cholesterol]
        
        VStack(spacing: 6.3) {
            ForEach(Array(list.enumerated()), id: \.element.id) { index, nutrient in
                VStack(spacing: 10) {
                    HStack(spacing: 4) {
                        nutrient.image
                        
                        Text(nutrient.id)
                        
                        nutrientStatusView(type: nutrient)
                        
                        Image("icon-arrow-right-3-px")
                            .renderingMode(.template)
                            .foregroundStyle(Color(hex: "aab2bb"))
                        
                        Spacer()
                        
                        nutrientIntakeStatusText(type: nutrient)
                    }
                    .onTapGesture {
                        store.send(.view(.nutrientDetailTapped(nutrient)))
                    }
                    
                    intakeProgressBar(type: nutrient)
                    
                    intakeNurientGoalText(type: nutrient)
                }
                .frame(height: 65)
            }
        }
    }
    
    @ViewBuilder
    func intakeProgressBar(type nutrient: NutrientType) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: "eff1f4"))
            .frame(height: 12)
            .overlay(alignment: .leading) {
                intakeProgresssingBar(type: nutrient)
            }
            .overlay(alignment: .trailing) {
                // 채움 진행이 닿으면 흰색으로 바뀌는 33%/66% 임계 마커
                intakeDashLine(type: nutrient)
            }
            .clipped()
    }
    
    @ViewBuilder
    func intakeProgresssingBar(type nutrient: NutrientType) -> some View {
        GeometryReader { proxy in
            switch nutrient {
            case .sodium:
                let sodium = store.sodium
                let calWidth = (proxy.size.width - 66.5) * CGFloat(sodium.intakeRatio)
                let width = min(proxy.size.width, calWidth)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(nutrient.color)
                    .frame(width: width)
                    .animation(.timingCurve(0, 0, 0.58, 1, duration: 0.6).delay(0.2), value: width)
                
            case .sugars:
                let sugars = store.sugars
                let calWidth = (proxy.size.width - 66.5) * CGFloat(sugars.intakeRatio)
                let width = min(proxy.size.width, calWidth)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(nutrient.color)
                    .frame(width: width)
                    .animation(.timingCurve(0, 0, 0.58, 1, duration: 0.6).delay(0.2), value: width)
                
            case .fiber:
                let fiber = store.fiber
                let calWidth = (proxy.size.width - 66.5) * CGFloat(fiber.intakeRatio)
                let width = min(proxy.size.width, calWidth)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(nutrient.color)
                    .frame(width: width)
                    .animation(.timingCurve(0, 0, 0.58, 1, duration: 0.6).delay(0.2), value: width)
                
            case .cholesterol:
                let cholesterol = store.chol
                let calWidth = (proxy.size.width - 66.5) * CGFloat(cholesterol.intakeRatio)
                let width = min(proxy.size.width, calWidth)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(nutrient.color)
                    .frame(width: width)
                    .animation(.timingCurve(0, 0, 0.58, 1, duration: 0.6).delay(0.2), value: width)
                
            default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func intakeDashLine(type nutrient: NutrientType) -> some View {
        GeometryReader { proxy in
            // 회색/흰색 마커 레이어의 대시 스타일을 동일하게 유지
            let strokeStyle = StrokeStyle(
                lineWidth: 1,
                lineCap: .round,
                lineJoin: .round,
                dash: [3, 3]
            )
            
            ZStack {
                // 기본 마커(항상 노출)
                VerticalLineShape()
                    .stroke(Color(hex: "c6ccd2"), style: strokeStyle)
                    .frame(width: 1)
                    .frame(height: 15)
                    // 바 높이가 12라서 y=6이 중앙(클립 적용됨)
                    .position(x: proxy.size.width - 66.5, y: 6)
            }
        }
    }
    
    @ViewBuilder
    func intakeNurientGoalText(type nutrient: NutrientType) -> some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(.clear)
                .frame(height: 17)
                .overlay {
                    Text("\(getNurientGoal(type: nutrient))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color(hex: "aab2bb"))
                        .position(x: proxy.size.width - 66.5)
                }
        }
    }
    
    func getNurientGoal(type nutrient: NutrientType) -> Int {
        switch nutrient {
        case .carbohydrate:
            return Int(store.carbs.goal.rounded())
        case .protein:
            return Int(store.protein.goal.rounded())
        case .fat:
            return Int(store.fat.goal.rounded())
        case .sodium:
            return Int(store.sodium.goal.rounded())
        case .sugars:
            return Int(store.sugars.goal.rounded())
        case .fiber:
            return Int(store.fiber.goal.rounded())
        case .cholesterol:
            return Int(store.chol.goal.rounded())
        }
    }
}
