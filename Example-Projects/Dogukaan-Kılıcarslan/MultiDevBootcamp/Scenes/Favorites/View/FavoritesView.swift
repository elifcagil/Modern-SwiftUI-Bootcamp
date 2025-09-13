//
//  FavoritesView.swift
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.favoriteArticles) { article in
                ArticleRowView(
                    article: article,
                    isFavorite: .init(get: {
                        viewModel.isFavorite(article)
                    }, set: { favorited in
                        viewModel.toggleFavorite(for: article)
                    })
                )
            }
        }
        .refreshable {
            viewModel.reload()
        }
        .overlay(alignment: .center) {
            if viewModel.favoriteArticles.isEmpty {
                ContentUnavailableView("No Favorites", systemImage: "star")
            }
        }
        .navigationTitle("Favorites")
        .onAppear { viewModel.reload() }
    }
}

#Preview {
    let vm = FavoritesViewModel(storage: UserDefaultsNewsStorage())
    return NavigationStack { FavoritesView(viewModel: vm) }
}


