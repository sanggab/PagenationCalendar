import SwiftUI
import Charts

enum HalfCircleNutrientType: String, CaseIterable, Identifiable, Equatable {
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

struct TDEEResult: Equatable {
    static let `default` = TDEEResult(
        carbohydrates: 0,
        protein: 0,
        fat: 0,
        sodium: 0,
        water: 0,
        sugars: 0,
        dietaryFiber: 0,
        cholesterol: 0
    )
    var carbohydrates: Int
    var protein: Int
    var fat: Int
    var sodium: Int
    var water: Int
    var sugars: Int
    var dietaryFiber: Int
    var cholesterol: Int
}

struct NutrientChartData: Identifiable, Equatable {
    let id = UUID()
    let type: HalfCircleNutrientType?
    let value: Int
    let color: Color
    
    var calories: Double {
        guard let type = type else { return Double(value) }
        switch type {
        case .carbohydrate, .protein: return Double(value * 4)
        case .fat: return Double(value * 9)
        }
    }
    
    init(
        type: HalfCircleNutrientType? = nil,
        value: Int,
        color: Color
    ) {
//        self.label = label
        self.type = type
        self.value = value
        self.color = color
    }
    
    static func == (lhs: NutrientChartData, rhs: NutrientChartData) -> Bool {
        return lhs.id == rhs.id &&
               lhs.type == rhs.type &&
               lhs.value == rhs.value
    }
}

struct HalfCircleChartConfiguration {
    var size: CGSize = CGSize(width: 0, height: 200)
    
    var innerRadius: CGFloat? = nil
    var outerRadius: CGFloat? = nil
    var textPadding: CGFloat? = nil
}

struct HalfCircleChart: View {
    var data: [NutrientChartData]
    var targetTotal: Int?
    
    private let configuration: HalfCircleChartConfiguration
    
    init(
        _ items: [NutrientChartData],
        total: Int? = nil,
        configuration: HalfCircleChartConfiguration = HalfCircleChartConfiguration()
    ) {
        self.data = items
        self.targetTotal = total
        self.configuration = configuration
    }
    
    var chartData: [NutrientChartData] {
        var copiedData = self.data
        let currentTotal = copiedData.reduce(0.0) { $0 + $1.calories }
        
        if let targetTotal {
            let remaining = max(0, Double(targetTotal) - currentTotal)
            copiedData.append(NutrientChartData(value: Int(remaining), color: .gray.opacity(0.1)))
            
            let bottomDummy = max(Double(targetTotal), currentTotal)
            copiedData.append(NutrientChartData(value: Int(bottomDummy), color: .clear))
        } else {
            copiedData.append(NutrientChartData(value: Int(currentTotal), color: .clear))
        }
        
        return copiedData
    }
    
    var width: CGFloat {
        return configuration.size.width
    }
    var height: CGFloat {
        return configuration.size.height
    }
    
    var innerRadius: CGFloat {
        return configuration.innerRadius ?? 0.6
    }
    var outerRadius: CGFloat {
        return configuration.outerRadius ?? 1.0
    }
    
    var textPadding: CGFloat {
        return configuration.textPadding ?? height / 4
    }
    
    var body: some View {
        Chart(chartData) { item in
            SectorMark(
                angle: .value(item.type?.rawValue ?? "Value", item.calories),
                innerRadius: .ratio(innerRadius),
                outerRadius: .ratio(outerRadius),
            )
            .foregroundStyle(item.color)
        }
        .animation(.easeOut(duration: 0.5).delay(0.3), value: data)
        .rotationEffect(.degrees(-90))
        .aspectRatio(1.0, contentMode: .fill)
        .frame(
            width: width == 0 ? nil : width,
            height: height == 0 ? nil : height,
            alignment: .top
        )
        .overlay(alignment: .bottom) {
            if let targetTotal {
                Text("\(targetTotal)")
                    .padding(.bottom, textPadding)
            }
        }
        .clipped()
    }
}

// MARK: - 사용 예시 뷰
struct TDEEResultView: View {
    // 예시 데이터
    @State var data = TDEEResult(
        carbohydrates: 0,
        protein: 0,
        fat: 0,
        sodium: 0,
        water: 0,
        sugars: 0,
        dietaryFiber: 0,
        cholesterol: 0
    )
    
    func randomize() {
        data = .init(
            carbohydrates: Int.random(in: 300...1000),
            protein: Int.random(in: 200...500),
            fat: Int.random(in: 100...500),
            sodium: 10,
            water: Int.random(in: 50...300),
            sugars: 10,
            dietaryFiber: 10,
            cholesterol: 10
        )
//        data = .init(
//            carbohydrates: 1000,//Int.random(in: 300...1000),
//            protein: 500,//Int.random(in: 200...500),
//            fat: 800,//Int.random(in: 100...500),
//            sodium: 10,
//            water: 200,//Int.random(in: 50...300),
//            sugars: 10,
//            dietaryFiber: 10,
//            cholesterol: 10
//        )
    }
    
    func reset() {
        data = TDEEResult(
            carbohydrates: 0,
            protein: 0,
            fat: 0,
            sodium: 0,
            water: 0,
            sugars: 0,
            dietaryFiber: 0,
            cholesterol: 0
        )
    }
    
    // 목표치 (예: 2500)
    let maxTarget = 2500
    
    var body: some View {
        VStack {
            Text("목표: \(maxTarget) / 현재: \(data.carbohydrates + data.protein + data.fat)")
                .font(.headline)
                .padding(12)
                .background(.gray.opacity(0.3))
                .contentShape(.rect)
                .onTapGesture {
                    randomize()
                }
            
            Text("리셋")
                .font(.headline)
                .padding(12)
                .background(.gray.opacity(0.3))
                .contentShape(.rect)
                .onTapGesture {
                    reset()
                }
            
            HalfCircleChart(
                [
                    NutrientChartData(type: .carbohydrate, value: data.carbohydrates, color: .blue),
                    NutrientChartData(type: .protein, value: data.protein, color: .green),
                    NutrientChartData(type: .fat, value: data.fat, color: .orange),
                    NutrientChartData(value: data.water, color: .purple),
                ],
                total: maxTarget
            )
            
            HalfCircleChart(
                [
                    NutrientChartData(type: .carbohydrate, value: data.carbohydrates, color: .blue),
                    NutrientChartData(type: .protein, value: data.protein, color: .green),
                    NutrientChartData(type: .fat, value: data.fat, color: .orange),
                    NutrientChartData(value: data.water, color: .purple),
                ],
                total: maxTarget
            )
            
            
            HalfCircleChart(
                [
                    NutrientChartData(type: .carbohydrate, value: data.carbohydrates, color: .blue),
                    NutrientChartData(type: .protein, value: data.protein, color: .green),
                    NutrientChartData(type: .fat, value: data.fat, color: .orange),
                    NutrientChartData(value: data.water, color: .purple),
                ],
                total: maxTarget,
                configuration: HalfCircleChartConfiguration(
                    size: CGSize(width: .zero, height: 150),
                    innerRadius: 0.7,
                    outerRadius: 0.8,
                    textPadding: 40
                )
            )
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TDEEResultView()
}
