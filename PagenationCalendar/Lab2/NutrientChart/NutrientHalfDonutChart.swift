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
    
    var image: Image {
        switch self {
        case .carbohydrate:
            Image("icon-carb")
        case .protein:
            Image("icon-pro")
        case .fat:
            Image("icon-fat")
        }
    }
    // 권장 섭취량 미만
    var min: Double {
        switch self {
        case .carbohydrate:
            return 80
        case .protein:
            return 90
        case .fat:
            return 80
        }
    }
    // 권장 섭취량 초과
    var max: Double {
        switch self {
        case .carbohydrate:
            return 120
        case .protein:
            return 130
        case .fat:
            return 110
        }
    }
}

struct NutrientData: Identifiable, Equatable {
    let id = UUID()
    let type: NutrientType
    var value: Double // current intake in grams
    let goal: Double // goal in grams
    
    // Helper for calories (approximate: C=4, P=4, F=9)
//    var calories: Double {
//        let roundedValue = value.rounded()
//        switch type {
//        case .carbohydrate, .protein: return roundedValue * 4
//        case .fat: return roundedValue * 9
//        }
//    }
    
    var calories: Double {
        switch type {
        case .carbohydrate, .protein: return value * 4
        case .fat: return value * 9
        }
    }
    
    var intakeStatus: IntakeStatus {
        evaluateNutrientStatus(type: type)
    }
    
    func evaluateNutrientStatus(type nutrient: NutrientType) -> IntakeStatus {
        guard goal > 0 else { return .insufficient }
        
        let ratio = (value / goal) * 100
        
        if ratio < type.min { return .insufficient }
        if ratio <= type.max { return .adequate }
        
        return .excessive
    }
}

struct DailyNutrition: Equatable {
    var carbs: NutrientData
    var protein: NutrientData
    var fat: NutrientData
    var totalCaloriesGoal: Double
    
    var totalCaloriesConsumed: Double {
        let roundedCarb = carbs.calories.rounded()
        let roundedPro = protein.calories.rounded()
        let roundedFat = fat.calories.rounded()
        
        return roundedCarb + roundedPro + roundedFat
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
        
        let remaining = max(0, goal - totalConsumed)
        segments.append(ChartSegment(type: nil, value: remaining, isSpacer: false, isBackground: true))
        
        let maxScale = max(totalConsumed, goal)
        segments.append(ChartSegment(type: nil, value: maxScale, isSpacer: true))
        
        return segments
    }
    
    private struct ChartSegment: Identifiable {
        var id: String {
            if let type = type { return type.rawValue }
            return UUID().uuidString
        }
        let type: NutrientType?
        let value: Double
        var isSpacer: Bool = false
        var isBackground: Bool = false
        
        var color: Color {
            return type?.color ?? Color(hex: "eff1f4")
        }
        
        var label: String {
            return type?.rawValue ?? ""
        }
    }
    
    private let size = CGSize(width: 240, height: 120)
    
    var body: some View {
        Chart(chartData) { segment in
            SectorMark(
                angle: .value(segment.type?.rawValue ?? "Value", segment.value),
                innerRadius: .ratio(0.65),
                outerRadius: .ratio(1),
            )
            .foregroundStyle(segment.color)
        }
        .animation(.easeOut(duration: 0.5).delay(0.3), value: data)
        .rotationEffect(.degrees(-90))
        .aspectRatio(1.0, contentMode: .fill)
        .frame(
            width: size.width == 0 ? nil : size.width,
            height: size.height == 0 ? nil : size.height,
            alignment: .top
        )
        .overlay(alignment: .bottom) {
            Text("\(Int(data.totalCaloriesGoal))")
                .font(.system(size: 34, weight: .bold))
                .frame(height: 48)
                .foregroundStyle(Color(hex: "121416"))
        }
        .clipped()
    }
}

// MARK: - Preview
struct NutrientHalfDonutChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = DailyNutrition(
            carbs: NutrientData(type: .carbohydrate, value: 150, goal: 200),
            protein: NutrientData(type: .protein, value: 80, goal: 100),
            fat: NutrientData(type: .fat, value: 40, goal: 60),
            totalCaloriesGoal: 2500
        )
        
        NutrientHalfDonutChart(data: sampleData)
    }
}
