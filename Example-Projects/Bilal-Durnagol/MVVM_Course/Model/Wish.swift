//
//  Wish.swift
//  MVVM_Course
//
//  Created by Bilal Durnagöl on 3.09.2025.
//

import Foundation

struct Wish: Identifiable, Hashable {
    var id: UUID = UUID()
    var text: String
}
