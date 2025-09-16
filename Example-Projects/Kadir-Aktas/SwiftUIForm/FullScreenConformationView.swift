//
//  FullScreenConformationView.swift
//  SwiftUIForm
//
//  Created by Kadir Aktaş on 8.09.2025.
//

import SwiftUI

struct FullScreenConformationView: View {
    let user: User
    var onContinue: () -> Void = {}  // Callback
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                .padding()
            }

            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                VStack(spacing: 16) {
                    Text("Hoş Geldin!")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(user.name)
                        .font(.title2)
                        .foregroundColor(.primary)

                    Text("Kaydınız başarıyla tamamlandı")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                VStack(spacing: 16) {
                    Button(action: {
                        onContinue()
                    }) {
                        Label("Detaylara Git", systemImage: "arrow.right.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .background(Color.blue)
                    .cornerRadius(12)

                    Button(action: { dismiss() }) {
                        Text("Kapat")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    FullScreenConformationView(user: User(name: "Kadir"))
}
