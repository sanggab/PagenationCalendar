//import SwiftUI
//import Charts
//
//struct TDEEResult: Equatable {
//    static let `default` = TDEEResult(
//        carbohydrates: 0,
//        protein: 0,
//        fat: 0,
//        sodium: 0,
//        water: 0,
//        sugars: 0,
//        dietaryFiber: 0,
//        cholesterol: 0
//    )
//    var carbohydrates: Int
//    var protein: Int
//    var fat: Int
//    var sodium: Int
//    var water: Int
//    var sugars: Int
//    var dietaryFiber: Int
//    var cholesterol: Int
//}
//
//struct HalfCircleChartConfiguration {
//    var size: CGSize = CGSize(width: 0, height: 200)
//    
//    var innerRadius: CGFloat? = nil
//    var outerRadius: CGFloat? = nil
//    var textPadding: CGFloat? = nil
//    var emptyColor: Color? = nil
//}
//
//struct HalfCircleChart: View {
//    let dailyNutrition: DailyNutrition
//    private let configuration: HalfCircleChartConfiguration
//    
//    init(
//        dailyNutrition: DailyNutrition,
//        configuration: HalfCircleChartConfiguration = HalfCircleChartConfiguration()
//    ) {
//        self.dailyNutrition = dailyNutrition
//        self.configuration = configuration
//    }
//    
//    private struct HalfCircleChartSegment: Identifiable {
//        let id = UUID()
//        let type: NutrientType?
//        let value: Double
//        let color: Color
//    }
//    
//    var chartData: [HalfCircleChartSegment] {
//        var segments: [HalfCircleChartSegment] = []
//        
//        // Add nutrient segments
//        // Using colors from NutrientType definition or custom if needed. 
//        // NutrientType.carbohydrate.color is .blue
//        // NutrientType.protein.color is .purple
//        // NutrientType.fat.color is .orange
//        
//        segments.append(HalfCircleChartSegment(type: .carbohydrate, value: dailyNutrition.carbs.calories, color: .blue))
//        segments.append(HalfCircleChartSegment(type: .protein, value: dailyNutrition.protein.calories, color: .purple))
//        segments.append(HalfCircleChartSegment(type: .fat, value: dailyNutrition.fat.calories, color: .orange))
//        
//        let currentTotal = dailyNutrition.totalCaloriesConsumed
//        let targetTotal = dailyNutrition.totalCaloriesGoal
//        
//        // Add remaining segment (gray)
//        let remaining = max(0, targetTotal - currentTotal)
//        segments.append(HalfCircleChartSegment(type: nil, value: remaining, color: configuration.emptyColor ?? .gray.opacity(0.1)))
//        
//        // Add bottom dummy segment (clear) to make it a half circle
//        let bottomDummy = max(targetTotal, currentTotal)
//        segments.append(HalfCircleChartSegment(type: nil, value: bottomDummy, color: .clear))
//        
//        return segments
//    }
//    
//    var width: CGFloat {
//        return configuration.size.width
//    }
//    var height: CGFloat {
//        return configuration.size.height
//    }
//    
//    var innerRadius: CGFloat {
//        return configuration.innerRadius ?? 0.6
//    }
//    var outerRadius: CGFloat {
//        return configuration.outerRadius ?? 1.0
//    }
//    
//    var textPadding: CGFloat {
//        return configuration.textPadding ?? height / 4
//    }
//    
//    var body: some View {
//        Chart(chartData) { item in
//            SectorMark(
//                angle: .value(item.type?.rawValue ?? "Value", item.value),
//                innerRadius: .ratio(innerRadius),
//                outerRadius: .ratio(outerRadius),
//            )
//            .foregroundStyle(item.color)
//        }
//        .animation(.easeOut(duration: 0.5).delay(0.3), value: dailyNutrition)
//        .rotationEffect(.degrees(-90))
//        .aspectRatio(1.0, contentMode: .fill)
//        .frame(
//            width: width == 0 ? nil : width,
//            height: height == 0 ? nil : height,
//            alignment: .top
//        )
//        .overlay(alignment: .bottom) {
//            Text("\(Int(dailyNutrition.totalCaloriesGoal))")
//                .foregroundStyle(Color(hex: "121416"))
//                .padding(.bottom, textPadding)
//        }
//        .clipped()
//    }
//}
//
//// MARK: - 사용 예시 뷰
//struct TDEEResultView: View {
//    // 예시 데이터
//    @State var data = TDEEResult(
//        carbohydrates: 0,
//        protein: 0,
//        fat: 0,
//        sodium: 0,
//        water: 0,
//        sugars: 0,
//        dietaryFiber: 0,
//        cholesterol: 0
//    )
//    
//    func randomize() {
//        data = .init(
//            carbohydrates: Int.random(in: 300...1000),
//            protein: Int.random(in: 200...500),
//            fat: Int.random(in: 100...500),
//            sodium: 10,
//            water: Int.random(in: 50...300),
//            sugars: 10,
//            dietaryFiber: 10,
//            cholesterol: 10
//        )
//    }
//    
//    func reset() {
//        data = TDEEResult(
//            carbohydrates: 0,
//            protein: 0,
//            fat: 0,
//            sodium: 0,
//            water: 0,
//            sugars: 0,
//            dietaryFiber: 0,
//            cholesterol: 0
//        )
//    }
//    
//    // 목표치 (예: 2500)
//    let maxTarget = 2500
//    
//    var dailyNutrition: DailyNutrition {
//        DailyNutrition(
//            carbs: NutrientData(type: .carbohydrate, value: Double(data.carbohydrates), goal: 0),
//            protein: NutrientData(type: .protein, value: Double(data.protein), goal: 0),
//            fat: NutrientData(type: .fat, value: Double(data.fat), goal: 0),
//            totalCaloriesGoal: Double(maxTarget)
//        )
//    }
//    
//    var body: some View {
//        VStack {
//            Text("목표: \(maxTarget) / 현재: \(data.carbohydrates + data.protein + data.fat)")
//                .font(.headline)
//                .padding(12)
//                .background(.gray.opacity(0.3))
//                .contentShape(.rect)
//                .onTapGesture {
//                    randomize()
//                }
//            
//            Text("리셋")
//                .font(.headline)
//                .padding(12)
//                .background(.gray.opacity(0.3))
//                .contentShape(.rect)
//                .onTapGesture {
//                    reset()
//                }
//            
//            HalfCircleChart(
//                dailyNutrition: dailyNutrition
//            )
//            
//            HalfCircleChart(
//                dailyNutrition: dailyNutrition
//            )
//            
//            
//            HalfCircleChart(
//                dailyNutrition: dailyNutrition,
//                configuration: HalfCircleChartConfiguration(
//                    size: CGSize(width: 240, height: 120),
//                    innerRadius: 0.65,
//                    outerRadius: 1,
//                    textPadding: 24
//                )
//            )
//            
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    TDEEResultView()
//}
