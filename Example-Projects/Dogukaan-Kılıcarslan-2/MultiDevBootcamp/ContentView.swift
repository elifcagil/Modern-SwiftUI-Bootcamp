//
//  ContentView.swift
//  MultiDevBootcamp
//
//  Created by dogukaan on 13.09.2025.
//

import SwiftUI
import SwiftData

// TODO: - Add a keychain manager to project and keep the NEWS_API_KEY inside the keychain.
// Bonus: get the key from the user on app startup

struct ContentView: View {
    // Simple dependency setup with unified CoreData storage
    private let service = BasicNewsService()
    private let storage = CoreDataNewsStorage()
    
    var body: some View {
        TabView {
            NavigationStack {
                NewsListView(
                    viewModel: NewsListViewModel(
                        service: service,
                        storage: storage
                    )
                )
            }
            .tabItem { Label("News", systemImage: "newspaper")  }
            
            NavigationStack {
                FavoritesView(
                    viewModel: FavoritesViewModel(storage: storage)
                )
            }
            .tabItem { Label("Favorites", systemImage: "star") }
            
            NavigationStack {
                let vm = ReadLaterViewModel(
                    service: service,
                    storage: storage
                )
                
                ReadLaterView(
                    viewModel: vm
                )
            }
            .tabItem { Label("Read Later", systemImage: "book.pages") }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
