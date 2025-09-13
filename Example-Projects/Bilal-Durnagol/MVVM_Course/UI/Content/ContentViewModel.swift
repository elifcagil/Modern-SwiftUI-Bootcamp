//
//  ContentViewModel.swift
//  MVVM_Course
//
//  Created by Bilal Durnagöl on 3.09.2025.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    // MARK: - Properties
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
    /// A list of all wishes
    @Published var wishes: [Wish] = []
    /// Controls whether an alert should be displayed
    @Published var isAlertShowing: Bool = false
    /// Hold wish content
    @Published var newWishText: String = ""
    
    // MARK: - Methods
    
    
    /// Adds a new wish
    /// - Parameter text: The wish text entered by the user
    func addWish(_ text: String) {
        // Prevent adding empty wish
        guard !text.isEmpty else { return }
        // Create new wish
        let wish = Wish(text: text)
        // Append it to the wish list
        wishes.append(wish)
        // Reset the wish text
        newWishText = ""
    }
    
    /// Removes an wish
    /// - Parameter wish: The wish objexct to remove
    func removeWish(with wish: Wish) {
        // find the index of first wish in list
        if let index = wishes.firstIndex(of: wish) {
            // Remove it
            wishes.remove(at: index)
        }
    }
    
}
