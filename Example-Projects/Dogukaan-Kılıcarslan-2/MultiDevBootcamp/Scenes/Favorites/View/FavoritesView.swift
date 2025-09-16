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
                    }),
                    isReadLater: .init(
                        get: {
                            viewModel.isReadLater(
                                article
                            )
                        },
                        set: { newValue in
                            viewModel.toggleReadLater(
                                for: article
                            )
                        })
                )
            }
        }
        .refreshable {
            Task {
                await viewModel.refresh()
            }
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                ProgressView("Loading…")
            } else if let message = viewModel.errorMessage, viewModel.favoriteArticles.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else if viewModel.favoriteArticles.isEmpty {
                ContentUnavailableView("No Articles", systemImage: "newspaper")
            }
        }
        .navigationTitle("Favorites")
        .task {
            await viewModel.refresh()
        }
    }
}

#Preview {
    let articlesManager: NewsStorageProtocol = CoreDataNewsStorage()
    let vm = FavoritesViewModel(storage: articlesManager)
    return NavigationStack { FavoritesView(viewModel: vm) }
}


