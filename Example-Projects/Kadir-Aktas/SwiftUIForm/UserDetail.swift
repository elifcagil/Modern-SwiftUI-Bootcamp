//
//  UserDetail.swift
//  SwiftUIForm
//
//  Created by Kadir Aktaş on 8.09.2025.
//

import SwiftUI

struct UserDetail: View {
    let user: User

    var body: some View {
        List {
            Section("Kişisel Bilgiler") {
                LabeledContent("Ad Soyad", value: user.name)
                LabeledContent("E-posta", value: user.email)
                LabeledContent("Yaş", value: "\(user.age)")
                LabeledContent("Şehir", value: user.city.displayName)
            }

            Section("Tercihler") {
                HStack {
                    Text("Bülten Aboneliği")
                    Spacer()
                    Image(systemName: user.wantsNewsletter ? "checkmark.circle.fill" : "xmark.circle")
                        .foregroundColor(user.wantsNewsletter ? .green : .gray)
                }
            }
        }
        .navigationTitle("Kullanıcı Detayları")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserDetail(user: User(name: "Test User"))
}
