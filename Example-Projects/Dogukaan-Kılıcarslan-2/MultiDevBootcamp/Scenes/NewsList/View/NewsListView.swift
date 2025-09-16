//
//  NewsListView.swift
//

import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel: NewsListViewModel
    
    init(viewModel: NewsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.articles) { article in
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
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                ProgressView("Loading…")
            } else if let message = viewModel.errorMessage, viewModel.articles.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else if viewModel.articles.isEmpty {
                ContentUnavailableView("No Articles", systemImage: "newspaper")
            }
        }
        .navigationTitle("News")
        .task {
            await viewModel.refresh()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

#Preview {
    let articlesManager: NewsStorageProtocol = CoreDataNewsStorage()
    let vm = NewsListViewModel(
        service: BasicNewsService(),
        storage: articlesManager
    )
    return NavigationStack {
        NewsListView(viewModel: vm)
    }
}


