//
//  NutrientDetailView.swift
//  PagenationCalendar
//
//  Created by Gab on 2/23/26.
//

import SwiftUI

import ComposableArchitecture

struct NutrientDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let store: StoreOf<NutrientDetailReducer>

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                header
                
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        nutrientIntakeSummary
                        
                        boundray
                        
                        foodList(proxy)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            store.send(.view(.onAppear))
        }
    }
}

extension NutrientDetailView {
    @ViewBuilder
    var header: some View {
        HStack(spacing: 4) {
            Button {
                dismiss()
            } label: {
                Image("icon-arrow-left")
                    .padding(.all, 8)
            }

            Text(store.nutrientType.rawValue)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: "222529"))
            
            Spacer()
        }
        .frame(height: 40)
        .padding(.vertical, 8)
        .padding(.leading, 8)
        .padding(.trailing ,12)
    }
}

extension NutrientDetailView {
    @ViewBuilder
    var nutrientIntakeSummary: some View {
        VStack(spacing: 16) {
            NutrientDetailProgressBar(
                progress: store.detailUIModel.progressRatio,
                remainingAmountText: store.detailUIModel.comparisonAmountText,
                comparisonLabelText: store.detailUIModel.comparisonLabelText
            )
                .frame(width: 120, height: 120)
            
            nutrientIntakeStatus
            
            Spacer()
                .frame(height: 8)
        }
    }
    
    @ViewBuilder
    var nutrientIntakeStatus: some View {
        HStack(spacing: 8) {
            VStack(spacing: 2) {
                Text("권장 섭취량")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "2d3238"))
                    .frame(height: 20)
                
                Text(store.detailUIModel.recommendedIntakeText)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(hex: "121416"))
                    .frame(height: 22)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(hex: "e2e5e9"), lineWidth: 1)
            }
            
            VStack(spacing: 2) {
                Text("내 섭취량")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "2d3238"))
                    .frame(height: 20)
                
                Text(store.detailUIModel.actualIntakeText)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(hex: "121416"))
                    .frame(height: 22)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(hex: "e2e5e9"), lineWidth: 1)
            }
        }
        .padding(.horizontal, 16)
    }
}

extension NutrientDetailView {
    @ViewBuilder
    var boundray: some View {
        Rectangle()
            .fill(Color(hex: "eff1f4"))
            .frame(height: 8)
    }
}

extension NutrientDetailView {
    @ViewBuilder
    func foodList(_ proxy: GeometryProxy) -> some View {
        VStack(spacing: 8) {
            foodListTitle

            if store.foodRows.isEmpty {
                noFoodHistory(proxy)
            } else {
                foodHistory
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var foodListTitle: some View {
        HStack(spacing: 0) {
            Text("음식 목록")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color(hex: "121416"))
            
            Spacer()
        }
        .frame(height: 25)
    }
    
    @ViewBuilder
    var foodHistory: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(store.foodRows.indices, id: \.self) { index in
                let foodRow = store.foodRows[index]

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(foodRow.foodName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color(hex: "2d3238"))
                            .multilineTextAlignment(.leading)
                        
                        Text(foodRow.servingDescriptionText)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color(hex: "525960"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(foodRow.nutrientAmountText)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(hex: "121416"))
                        .frame(width: 76, alignment: .trailing)
                }
                .padding(.vertical, 12)
                
                if index != (store.foodRows.count - 1) {
                    Rectangle()
                        .fill(Color(hex: "e2e5e9"))
                        .frame(height: 1)
                }
            }
        }
    }
    
    @ViewBuilder
    func noFoodHistory(_ proxy: GeometryProxy) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(height: proxy.size.height - 345)
            .overlay {
                Text("해당 영양소가 포함된 음식 기록이 없어요")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "aab2bb"))
        }
    }
}

#Preview {
    NutrientDetailView(
        store: Store(
            initialState: NutrientDetailReducer.State(
                nutrientType: .sodium,
                nutrientData: NutrientData(type: .sodium, value: 120, goal: 80),
                dietFoods: DietFood.samples.filter { $0.nutrition.sodiumMg > 0 }
            )
        ) {
            NutrientDetailReducer()
        }
    )
}
