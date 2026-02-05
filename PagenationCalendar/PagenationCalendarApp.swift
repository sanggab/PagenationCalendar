//
//  PagenationCalendarApp.swift
//  PagenationCalendar
//
//  Created by Gab on 2/5/26.
//

import SwiftUI

import ComposableArchitecture

@main
struct PagenationCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: MainReducer.State(),
                    reducer: { MainReducer() }
                )
            )
        }
    }
}
