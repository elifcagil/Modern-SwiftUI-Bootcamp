//
//  WishCell.swift
//  MVVM_Course
//
//  Created by Bilal Durnagöl on 3.09.2025.
//

import SwiftUI

// A resuable cell view for displaying a Wish item.
struct WishCell: View {
    
    // Properties
    
    var title: String
    
    // MARK: - Body
    var body: some View {
        Text(title)
            .modifier(TitleModifier())
    }
}
