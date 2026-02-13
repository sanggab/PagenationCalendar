import SwiftUI
import Charts

// MARK: - Models

enum NutrientType: String, CaseIterable, Identifiable, Equatable {
    case carbohydrate = "탄수화물"
    case protein = "단백질"
    case fat = "지방"
    case sodium = "나트륨"
    case sugars = "당류"
    case fiber = "식이섬유"
    case cholesterol = "콜레스테롤"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .carbohydrate:
            Color(hex: "ffb948")
        case .protein:
            Color(hex: "8c72ff")
        case .fat:
            Color(hex: "18cd8c")
        case .sodium:
            Color(hex: "699eff")
        case .sugars:
            Color(hex: "ff796c")
        case .fiber:
            Color(hex: "aab2bb")
        case .cholesterol:
            Color(hex: "ffa72c")
        }
    }
    
    @ViewBuilder
    var image: some View {
        switch self {
        case .carbohydrate:
            Image("icon-carb")
                .renderingMode(.template)
                .foregroundStyle(color)
        case .protein:
            Image("icon-pro")
                .renderingMode(.template)
                .foregroundStyle(color)
        case .fat:
            Image("icon-fat")
                .renderingMode(.template)
                .foregroundStyle(color)
        case .sodium:
            Image("icon-sodium")
        case .sugars:
            Image("icon-sugars")
        case .fiber:
            Image("icon-fiber")
        case .cholesterol:
            Image("icon-chol")
        }
    }
    
    /// 섭취량 부족
    var insufficient: Double {
        switch self {
        case .carbohydrate: 80
        case .protein: 90
        case .fat: 80
        case .sodium: 0
        case .sugars: 0
        case .fiber: 80
        case .cholesterol: 0
        }
    }
    /// 섭취량 위험
    var warning: Double {
        switch self {
        case .sodium: 120
        case .sugars: 120
        case .fiber: 0
        case .cholesterol: 120
        default: 0
        }
    }
    /// 섭취량 과다
    var excessive: Double {
        switch self {
        case .carbohydrate: 120
        case .protein: 130
        case .fat: 110
        default: 0
        }
    }
    
    var isMainNutrient: Bool {
        switch self {
        case .carbohydrate, .protein, .fat: true
        default: false
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
        default: return value
        }
    }
    
    var intakeStatus: IntakeStatus {
        evaluateNutrientStatus(type: type)
    }
    
    var intakeRatio: Double {
        value.rounded() / goal
    }
    
    func evaluateNutrientStatus(type nutrient: NutrientType) -> IntakeStatus {
        guard goal > 0 else { return .insufficient }
        
        let ratio = (value / goal) * 100
        
        switch nutrient {
        case .carbohydrate, .protein, .fat:
            if ratio < nutrient.insufficient { return .insufficient }
            if ratio <= nutrient.excessive { return .adequate }
            return .excessive
            
        case .sodium, .sugars, .cholesterol:
            if ratio <= 100 { return .adequate }
            if ratio <= nutrient.warning { return .caution }
            return .warning
            
        case .fiber:
            if ratio < nutrient.insufficient { return .insufficient }
            return .adequate
        }
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
