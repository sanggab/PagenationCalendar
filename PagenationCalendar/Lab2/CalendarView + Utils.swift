//
//  CalendarView + Utils.swift
//  PagenationCalendar
//
//  Created by Gab on 2/13/26.
//

import SwiftUI

import ComposableArchitecture

extension CalendarView {
    func getIntakeRatio(type nutrient: NutrientType) -> CGFloat {
        switch nutrient {
        case .sodium:
            return CGFloat(store.sodium.intakeRatio)
        case .sugars:
            return CGFloat(store.sugars.intakeRatio)
        case .fiber:
            return CGFloat(store.fiber.intakeRatio)
        case .cholesterol:
            return CGFloat(store.chol.intakeRatio)
        default:
            return 0
        }
    }
}

extension CalendarView {
    func isForegrounsStyleColor(for model: DayModel) -> Color {
        if model.isSelected {
            return Color(hex: "ffffff")
        } else if model.isWritted {
            return Color(hex: "2d3238")
        } else {
            return Color(hex: "6e7881")
        }
    }
    
    func isBackgroundColor(for model: DayModel) -> Color {
        if model.isFuture {
            return Color(hex: "eff1f4")
        } else {
            return model.isSelected ? Color(hex: "2d3238") : Color(hex: "eff1f4")
        }
    }

    var dottedSeparatorStrokeStyle: StrokeStyle {
        StrokeStyle(lineWidth: 1.8, lineCap: .round, dash: [3, 4])
    }

    var dottedSeparatorColor: Color {
        Color(hex: "cbd5e1")
    }
}


struct VerticalLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Date {
    var toKoreanTime: String {
        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "ko_KR")
        displayFormatter.dateFormat = "a h:mm"

        return displayFormatter.string(from: self)
    }
}
