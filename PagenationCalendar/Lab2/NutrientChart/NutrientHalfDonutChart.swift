import SwiftUI
import Charts

// MARK: - Models

enum NutrientType: String, CaseIterable, Identifiable, Equatable {
    case carbohydrate = "탄수화물"
    case protein = "단백질"
    case fat = "지방"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .carbohydrate: return Color.blue
        case .protein: return Color.purple
        case .fat: return Color.orange
        }
    }
}

struct NutrientData: Identifiable, Equatable {
    let id = UUID()
    let type: NutrientType
    var value: Double // current intake in grams
    let goal: Double // goal in grams
    
    // Helper for calories (approximate: C=4, P=4, F=9)
    var calories: Double {
        switch type {
        case .carbohydrate, .protein: return value * 4
        case .fat: return value * 9
        }
    }
}

struct DailyNutrition {
    var carbs: NutrientData
    var protein: NutrientData
    var fat: NutrientData
    var totalCaloriesGoal: Double
    
    var totalCaloriesConsumed: Double {
        carbs.calories + protein.calories + fat.calories
    }
}

struct NutrientHalfDonutChart: View {
    // MARK: - Properties
    let data: DailyNutrition
    
    @State private var isVisible = false
    
    private var chartData: [ChartSegment] {
        var segments: [ChartSegment] = []
        
        segments.append(ChartSegment(type: .carbohydrate, value: data.carbs.calories))
        segments.append(ChartSegment(type: .protein, value: data.protein.calories))
        segments.append(ChartSegment(type: .fat, value: data.fat.calories))
        
        let totalConsumed = data.totalCaloriesConsumed
        let goal = data.totalCaloriesGoal
        
        if totalConsumed < goal {
            let remaining = goal - totalConsumed
            segments.append(ChartSegment(type: nil, value: remaining, isSpacer: false, isBackground: true))
        }
        
        let maxScale = max(totalConsumed, goal)
        segments.append(ChartSegment(type: nil, value: maxScale, isSpacer: true))
        
        return segments
    }
    
    private struct ChartSegment: Identifiable {
        let id = UUID()
        let type: NutrientType?
        let value: Double
        var isSpacer: Bool = false
        var isBackground: Bool = false
        
        var color: Color {
            if isSpacer { return .clear }
            if isBackground { return .clear } // 배경은 별도 레이어로 처리하므로 투명
            return type?.color ?? .gray
        }
        
        var label: String {
            return type?.rawValue ?? ""
        }
    }
    
    var body: some View {
        VStack(spacing: 50) {
            ZStack {
                Chart {
                    SectorMark(
                        angle: .value("Full", 0.5),
                        innerRadius: .ratio(0.6),
                        outerRadius: .ratio(1.0),
                        angularInset: 0
                    )
                    .foregroundStyle(Color.gray.opacity(0.2))
                    
                    SectorMark(
                        angle: .value("Hidden", 0.5),
                        innerRadius: .ratio(0.6),
                        outerRadius: .ratio(1.0),
                        angularInset: 0
                    )
                    .foregroundStyle(.clear)
                }
                .rotationEffect(.degrees(-90))
                .frame(height: 200)

                Chart(chartData) { segment in
                    SectorMark(
                        angle: .value("Calories", segment.value),
                        innerRadius: .ratio(0.6),
                        outerRadius: .ratio(1.0),
                        angularInset: 0
                    )
                    .foregroundStyle(segment.isBackground ? .clear : segment.color)
                }
                .rotationEffect(.degrees(-90))
                .frame(height: 200)
                .mask {
                    Circle()
                        .trim(from: 0, to: isVisible ? 0.5 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 200, lineCap: .butt))
                        .rotationEffect(.degrees(-180))
                }
                
                VStack(spacing: 4) {
                    Text("오늘의 섭취량")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(data.totalCaloriesConsumed))")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    
                    if data.totalCaloriesConsumed > data.totalCaloriesGoal {
                        Text("목표 초과!")
                            .font(.caption2)
                            .foregroundColor(.red)
                            .padding(.top, 2)
                    } else {
                        Text("목표까지 \(Int(data.totalCaloriesGoal - data.totalCaloriesConsumed)) kcal")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .offset(y: 40)
            }
            .frame(height: 200)
        }
        .onAppear {
            withAnimation(.timingCurve(0.2, 0.8, 0.2, 1.0, duration: 2)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Preview
struct NutrientHalfDonutChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = DailyNutrition(
            carbs: NutrientData(type: .carbohydrate, value: 150, goal: 200),
            protein: NutrientData(type: .protein, value: 80, goal: 100),
            fat: NutrientData(type: .fat, value: 40, goal: 60),
            totalCaloriesGoal: 2000
        )
        
        NutrientHalfDonutChart(data: sampleData)
    }
}
