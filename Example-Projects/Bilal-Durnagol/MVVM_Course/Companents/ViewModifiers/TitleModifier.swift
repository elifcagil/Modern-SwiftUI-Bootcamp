//
//  TitleModifier.swift
//  MVVM_Course
//
//  Created by Bilal Durnagöl on 3.09.2025.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    // MARK: - Body
    func body(content: Content) -> some View {
        content
        // Use a light callout font style
            .font(.callout.weight(.bold))
        // padding left
            .padding(.leading, 2.0)
    }
}
