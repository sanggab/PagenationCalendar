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
    
}
