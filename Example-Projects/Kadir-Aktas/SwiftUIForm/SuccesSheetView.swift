//
//  SuccesSheetView.swift
//  SwiftUIForm
//
//  Created by Kadir Aktaş on 8.09.2025.
//

import SwiftUI

struct SuccesSheetView: View {
    let user: User
    var onDetailsTapped: () -> Void = {}

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)

            Text("Kayıt Başarılı!")
                .font(.title)
                .fontWeight(.bold)

            Text("Hoş geldin \(user.name)")
                .font(.title2)

            VStack(alignment: .leading, spacing: 10) {
                Label(user.email, systemImage: "envelope")
                Label(user.city.displayName, systemImage: "location")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Button(action: {
                onDetailsTapped()
            }) {
                Text("Detaya Git")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
        .presentationDetents([.medium])
    }}

#Preview {
    SuccesSheetView(user: User(name: "Kadir"))
}
