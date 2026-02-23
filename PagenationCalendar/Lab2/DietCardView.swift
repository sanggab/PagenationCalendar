//
//  DietCardView.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import Kingfisher

struct DietCardView: View {
    
    let dietFood: DietFood
    
    static let initialDragOffset: CGFloat = -1234567
    @GestureState var dragOffset: CGFloat = initialDragOffset
    @State var anchor: CGFloat   = 0
    @State var hoffset: CGFloat  = 0
    var anchorWidth: CGFloat     = 80
    var swipeTreshold: CGFloat   = 25
    
    var cellWidth: CGFloat {
        (UIScreen.main.bounds.width - 32)
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                HStack(spacing: 12) {
                    dietCardLeftView(for: dietFood)
                    dietCardRightView(for: dietFood)
                }
                .padding(.all, 16)
                .frame(width: proxy.size.width)
                .background(.white)
                
                Button {
                    
                } label: {
                    VStack(spacing: 4) {
                        Image("icon-delete-fill")
                            .renderingMode(.template)
                            .foregroundStyle(.white)
                        
                        Text("삭제")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 80)
                .frame(height: 112)
                .background(Color(hex: "ff604b"))
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .offset(x: hoffset)
            .simultaneousGesture(
                DragGesture(minimumDistance: 20)
                    .updating($dragOffset) { value, state, _ in
                        if abs(value.translation.width) > abs(value.translation.height) {
                            state = value.translation.width
                        }
                    }
            )
        }
        .frame(height: 112)
        .padding(.horizontal, 16)
        .mask(alignment: .leading) {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width - 16, height: 112)
                .clipShape(.rect(bottomTrailingRadius: 16, topTrailingRadius: 16))
        }
        .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
        .onChange(of: dragOffset) { oldValue, newValue in
            onGesture(newValue)
        }
    }
}

extension DietCardView {
    @ViewBuilder
    func dietCardRow(for model: DietFood) -> some View {
        HStack(spacing: 12) {
            dietCardLeftView(for: model)
            dietCardRightView(for: model)
        }
        .padding(.all, 16)
        .frame(height: 112)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(hex: "14121416"), radius: 10, x: 0, y: 1)
//        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func dietCardLeftView(for model: DietFood) -> some View {
        dietCardImageView(for: model.dietImageName)
    }
    
    @ViewBuilder
    func dietCardRightView(for model: DietFood) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            dietCardFoodInfoView(
                name: model.dietHeaderName,
                date: model.dietDateValue
            )
            
            dietCardCaloriesView(calorie: model.nutrition.energyKcal)
            
            dietCardNutrientRowView(
                carb: model.nutrition.carbohydratesG,
                protein: model.nutrition.proteinG,
                fat: model.nutrition.fatG
            )
        }
    }
    
    @ViewBuilder
    func dietCardImageView(for url: String?) -> some View {
        Group {
            if let url {
                KFImage(URL(string: url))
                    .resizable()
            } else {
                Rectangle()
                    .fill(Color(hex: "eff1f4"))
                    .overlay {
                        Image("img-default")
                            .resizable()
                    }
            }
        }
        .frame(width: 80, height: 80)
//        .border(Color(hex: "eff1f4"), width: 1.2)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    @ViewBuilder
    func dietCardFoodInfoView(
        name: String?,
        date: Date?
    ) -> some View {
        if let name, let date {
            HStack(spacing: 12) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(hex: "121416"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(date.toKoreanTime)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "6e7881"))
            }
            .frame(height: 22)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func dietCardCaloriesView(
        calorie: Double
    ) -> some View {
        Text(dietCardCaloriesAttributedText(calorie: calorie))
            .monospacedDigit()
            .contentTransition(.numericText(value: calorie))
            .animation(.snappy, value: calorie)
            .frame(height: 34)
    }
    
    @ViewBuilder
    func dietCardNutrientRowView(
        carb: Double,
        protein: Double,
        fat: Double
    ) -> some View {
        HStack(spacing: 8) {
            dietCardNutrientTypeStatusView(type: .carbohydrate, gram: carb)
            dietCardNutrientTypeStatusView(type: .protein, gram: protein)
            dietCardNutrientTypeStatusView(type: .fat, gram: fat)
        }
        .frame(height: 20)
    }
    
    @ViewBuilder
    func dietCardNutrientTypeStatusView(type: NutrientType, gram: Double) -> some View {
        Group {
            HStack(spacing: 4) {
                type.image
                
                Text("\(gram.rounded(), format: .number.precision(.fractionLength(0)))g")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "2d3238"))
            }
        }
    }
    
    func onGesture(_ value: CGFloat) {
        if dragOffset != Self.initialDragOffset {
            print("상갑 logEvent \(#function) value \(value)")
            
            withAnimation(.linear(duration: 0.1)) {
                hoffset = anchor + value
                
                if hoffset > 0 {
                    hoffset = 0
                }
                
                if -hoffset > anchorWidth {
                    hoffset = -anchorWidth
//                    if rightPast {
//                        hoffset = -anchorWidth
//                    }
                }
                
                if anchor < 0 {
//                    rightPast = hoffset < -anchorWidth + swipeTreshold
                } else {
//                    rightPast = hoffset < -swipeTreshold
                }
            }
            
        } else { // 오류나 이것저것 기타등등으로 인해 onEnded가 실행되지 않았을 때 처리
//            onEndGesture()
        }
    }
    
    func leftAnimation() -> Animation {
        Animation.timingCurve(0, 0, 0.58, 1, duration: 0.3)
    }
    
    func rightAnimation() -> Animation {
        Animation.timingCurve(0, 0, 0.58, 1, duration: 0.5)
    }
}

extension DietCardView {
    
}


extension DietCardView {
    private var dietCardCaloriesNumberFormat: FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(0))
    }

    private func dietCardCaloriesAttributedText(calorie: Double) -> AttributedString {
        var current = AttributedString(calorie.rounded().formatted(dietCardCaloriesNumberFormat))
        current.font = .system(size: 24, weight: .bold)
        current.foregroundColor = Color(hex: "121416")

        var goal = AttributedString("kcal")
        goal.font = .system(size: 16, weight: .medium)
        goal.foregroundColor = Color(hex: "525960")

        current += goal
        return current
    }
}

#Preview {
    DietCardView(dietFood: DietFood.samples.randomElement()!)
    DietCardView(dietFood: DietFood.samples.randomElement()!)
}
