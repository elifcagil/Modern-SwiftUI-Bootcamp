//
//  AppSettings.swift
//  Example of UserDefaults usage for app settings
//

import Foundation
import SwiftUI

@MainActor
final class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    private let defaultsManager: UserDefaultsManager
    
    // Keys for settings
    private let hasSeenOnboardingKey = DefaultsCodableKey("hasSeenOnboarding", default: false)
    private let preferredPageSizeKey = DefaultsCodableKey<Int>("preferredPageSize", default: 10)
    private let enableNotificationsKey = DefaultsCodableKey("enableNotifications", default: true)
    private let lastRefreshDateKey = DefaultsCodableKey("lastRefreshDate", default: Date.distantPast)
    private let selectedThemeKey = DefaultsCodableKey<AppSettings.Theme>(
        "selectedTheme",
        default: AppSettings.Theme.system
    )
    
    // Published properties for SwiftUI binding
    @Published var hasSeenOnboarding: Bool {
        didSet {
            try? defaultsManager.setCodable(hasSeenOnboarding, forKey: hasSeenOnboardingKey)
        }
    }
    
    @Published var preferredPageSize: Int {
        didSet {
            try? defaultsManager.setCodable(preferredPageSize, forKey: preferredPageSizeKey)
        }
    }
    
    @Published var enableNotifications: Bool {
        didSet {
            try? defaultsManager.setCodable(enableNotifications, forKey: enableNotificationsKey)
        }
    }
    
    @Published var selectedTheme: AppSettings.Theme {
        didSet {
            try? defaultsManager.setCodable(selectedTheme, forKey: selectedThemeKey)
        }
    }
    
    var lastRefreshDate: Date {
        get {
            defaultsManager.codable(forKey: lastRefreshDateKey)
        }
        set {
            try? defaultsManager.setCodable(newValue, forKey: lastRefreshDateKey)
        }
    }
    
    private init(defaults: UserDefaults = .standard) {
        self.defaultsManager = UserDefaultsManager(defaults: defaults)
        
        // Load initial values
        self.hasSeenOnboarding = defaultsManager.codable(forKey: hasSeenOnboardingKey)
        self.preferredPageSize = defaultsManager.codable(forKey: preferredPageSizeKey)
        self.enableNotifications = defaultsManager.codable(forKey: enableNotificationsKey)
        self.selectedTheme = defaultsManager.codable(forKey: selectedThemeKey)
    }
    
    // Convenience methods
    func markOnboardingComplete() {
        hasSeenOnboarding = true
    }
    
    func resetSettings() {
        hasSeenOnboarding = false
        preferredPageSize = 10
        enableNotifications = true
        selectedTheme = .system
        lastRefreshDate = Date.distantPast
    }
    
    func updateLastRefreshDate() {
        lastRefreshDate = Date()
    }
}

// MARK: - Theme Options
extension AppSettings {
    enum Theme: String, Codable, CaseIterable {
        case system = "system"
        case light = "light"
        case dark = "dark"
        
        var displayName: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        }
    }
    
    var theme: Theme {
        Theme(rawValue: selectedTheme.rawValue) ?? .system
    }
}
