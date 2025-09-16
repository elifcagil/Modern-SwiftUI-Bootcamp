//
//  ArticleRowView.swift
//

import SwiftUI

struct ArticleRowView: View {
    let article: NewsArticle
    @Binding var isFavorite: Bool
    @Binding var isReadLater: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: article.imageUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                case .failure(_):
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                case .empty:
                    Image(systemName: "photo")
                        .resizable()
                @unknown default:
                    Image(systemName: "photo")
                        .resizable()
                }
            }
            .scaledToFill()
            .frame(width: 48, height: 48)
            // create a rounded rectangle clip
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            VStack(alignment: .leading, spacing: 6) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                if let source = article.sourceName {
                    Text(source)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing) {
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundStyle(isFavorite ? .yellow : .gray)
                }
                .buttonStyle(.plain)
                
                Button {
                    // read later flag
                    isReadLater.toggle()
                } label: {
                    Image(systemName: "bookmark")
                        .foregroundStyle(isReadLater ? .blue : .gray)
                }
                .buttonStyle(.plain)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    ArticleRowView(article: .placeholder, isFavorite: .constant(true), isReadLater: .constant(true))
        .padding()
}


