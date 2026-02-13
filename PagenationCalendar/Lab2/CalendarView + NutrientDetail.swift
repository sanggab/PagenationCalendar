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
        .frame(height: 360)
        .containerRelativeFrame(.horizontal)
        .background(.purple)
        .padding(.bottom ,4)
    }
}

extension CalendarView {
    @ViewBuilder
    var additionalNutritionView: some View {
        VStack(spacing: 12) {
            ohterNutrientTitle
            
            otherNutrientList
        }
//        .background(.mint)
        .padding(.top, 20)
        .padding(.bottom, 24)
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
        
        VStack(spacing: 34) {
            ForEach(Array(list.enumerated()), id: \.element.id) { index, nutrient in
                VStack(spacing: 10) {
                    HStack(spacing: 4) {
                        nutrient.image
                        
                        Text(nutrient.id)
                        
                        nutrientStatusView(type: nutrient)
                        
                        Spacer()
                        
                        nutrientIntakeStatusText(type: nutrient)
                    }
                    .onTapGesture {
                        store.send(.view(.changeNutrient(nutrient)))
                    }
                    
                    intakeProgressBar(type: nutrient)
                }
                
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
            .overlay(alignment: .leading) {
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
                let calWidth = proxy.size.width * CGFloat(sodium.intakeRatio)
                let width = min(proxy.size.width, calWidth)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(nutrient.color)
                    .frame(width: width)
                    .animation(.timingCurve(0, 0, 0.58, 1, duration: 0.6).delay(0.2), value: width)
                
            case .sugars:
                let sodium = store.sugars
                let calWidth = proxy.size.width * CGFloat(sodium.intakeRatio)
                let width = min(proxy.size.width, calWidth)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(nutrient.color)
                    .frame(width: width)
                    .animation(.timingCurve(0, 0, 0.58, 1, duration: 0.6).delay(0.2), value: width)
                
            case .fiber:
                let sodium = store.fiber
                let calWidth = proxy.size.width * CGFloat(sodium.intakeRatio)
                let width = min(proxy.size.width, calWidth)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(nutrient.color)
                    .frame(width: width)
                    .animation(.timingCurve(0, 0, 0.58, 1, duration: 0.6).delay(0.2), value: width)
                
            case .cholesterol:
                let sodium = store.chol
                let calWidth = proxy.size.width * CGFloat(sodium.intakeRatio)
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
            let strokeStyle = StrokeStyle(
                lineWidth: 1.8,
                lineCap: .round,
                lineJoin: .round,
                dash: [3, 3]
            )
            
            let calWidth = proxy.size.width * getIntakeRatio(type: nutrient)
            let fillWidth = min(proxy.size.width, calWidth)
            let animation = Animation.timingCurve(0, 0, 0.58, 1, duration: 0.6).delay(0.2)

            ZStack {
                VerticalLineShape()
                    .stroke(Color(hex: "c6ccd2"), style: strokeStyle)
                    .frame(width: 3.6)
                    .frame(height: 15)
                    .position(x: proxy.size.width * 0.33, y: 6)

                VerticalLineShape()
                    .stroke(Color(hex: "c6ccd2"), style: strokeStyle)
                    .frame(width: 3.6)
                    .frame(height: 15)
                    .position(x: proxy.size.width * 0.66, y: 6)

                ZStack {
                    VerticalLineShape()
                        .stroke(Color.white, style: strokeStyle)
                        .frame(width: 3.6)
                        .frame(height: 15)
                        .position(x: proxy.size.width * 0.33, y: 6)

                    VerticalLineShape()
                        .stroke(Color.white, style: strokeStyle)
                        .frame(width: 3.6)
                        .frame(height: 15)
                        .position(x: proxy.size.width * 0.66, y: 6)
                }
                .mask(alignment: .leading) {
                    Rectangle()
                        .frame(width: fillWidth, height: proxy.size.height)
                        .animation(animation, value: fillWidth)
                }
            }
        }
    }
}

struct HorizontalLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
