//
//  ContentView.swift
//  SwiftUIForm
//
//  Created by Kadir Aktaş on 8.09.2025.
//

import SwiftUI

struct RegistrationFlowView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var age = 18
    @State private var isAgreed: Bool = false
    @State private var wantsNewsletter: Bool = false
    @State private var selectedCity = City.istanbul

    @State private var sheetUser: User?
    @State private var fullScreenUser: User?
    @State private var showFullScreen = false

    @State private var showValidationError: Bool = false

    @State private var navigationPath = NavigationPath()

    var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && isAgreed
    }

    var isPasswordValid: Bool {
        password.count >= 6
    }
    var isnameValid: Bool {
        name.count >= 3 && !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section {
                    TextField("Ad Soyad:", text: $name)
                    if showValidationError && !isnameValid {
                        Text("Adınız 3 karekterden fazla olmalıdır.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    TextField("E-posta:", text: $email)
                        .keyboardType(.emailAddress)

                    if showValidationError && !isEmailValid {
                        Text("Geçerli bir e-posta adresi giriniz.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }


                    Stepper(value: $age, in: 18...100) {
                        HStack {
                            Text("Yaş:")
                            Text("\(age)")
                                .foregroundColor(.black)
                        }
                    }

                    Picker (selection: $selectedCity) {
                        ForEach(City.allCases) { city in
                            Text(city.displayName).tag(city)
                        }
                    } label: {
                         Text("Şehir:")
                    }


                } header: {
                    Text("Kişisel Bilgiler")
                }

                Section {
                    SecureField("Şifre:", text: $password)
                } header: {
                    Text("Şifre")
                }

                if !isPasswordValid && showValidationError {
                    Text("Şifreniz en az 6 karakterli olmalıdır.")
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                Section {
                    Toggle(isOn: $wantsNewsletter) {
                        Label("Bülten Üyeliği", systemImage: "envelope")
                    }

                    Toggle(isOn: $isAgreed) {
                        Label("Genel şartları kabul ediyorum.", systemImage: "doc.text")
                    }
                    .tint(.blue)
                } header: {
                    Text("Kullanıcı Sözleşmesi")
                }

                Section {
                    Toggle("FullScreenCover Kullan", isOn: $showFullScreen)
                        .tint(.blue)
                } header: {
                    Text("Modal Türü")
                } footer: {
                    Text(showFullScreen ?
                         "FullScreenCover: Tam ekran modal, kaydırarak kapatılamaz" :
                         "Sheet: Yarım veya tam ekran, kaydırarak kapatılabilir")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section {
                    Button {
                        submitForm()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Kayıt ol", systemImage: "checkmark.circle.fill")
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                }
                .listRowBackground(
                    isFormValid ? Color.blue : Color.orange
                )


            }
            .navigationTitle("Kayıt ol")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: User.self) { user in
                UserDetail(user: user)
            }

        }
        .sheet(item:$sheetUser) { user in
            SuccesSheetView(user: user) {
                sheetUser = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigationPath.append(user)
                }
            }
        }
        .fullScreenCover(item:$fullScreenUser) { user in
            FullScreenConformationView(user: user) {
                fullScreenUser = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigationPath.append(user)
                }
            }

        }
    }

    func submitForm() {
        if !isFormValid {
            showValidationError = true
        }

       let newUser = User(
        name: name,
        email: email,
        password: password,
        age: age,
        city: selectedCity,
        agreeToTerms: isAgreed,
        wantsNewsletter: wantsNewsletter )

        print("Yeni kullanıcı oluşturuldu: \(newUser.name)")

        if showFullScreen {
            fullScreenUser = newUser
        } else {
            sheetUser = newUser
        }

    }


}

#Preview {
    RegistrationFlowView()
}
