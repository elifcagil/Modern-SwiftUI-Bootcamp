//
//  MVVM_CourseApp.swift
//  MVVM_Course
//
//  Created by Bilal Durnagöl on 3.09.2025.
//

import SwiftUI

@main
struct MVVM_CourseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(title: Localizations.ContentView.title))
        }
    }
}
