///
///  UserDefaultsManager.swift
///  A small, generic wrapper around UserDefaults with typed keys
///  The topic we covered in Lesson 1
///  Coded in a way to support both Codable and PropertyList types in a type-safe manner
///  Manager is lightweight and does not cache values

import Foundation

/// Type-erased protocol to support both Codable and PropertyList representable values
protocol AnyDefaultsKey {
    var rawKey: String { get }
}

/// Strongly-typed key for Codable values
struct DefaultsCodableKey<Value: Codable>: AnyDefaultsKey {
    let rawKey: String
    let defaultValue: Value
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init(_ rawKey: String, default defaultValue: Value, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.rawKey = rawKey
        self.defaultValue = defaultValue
        self.encoder = encoder
        self.decoder = decoder
    }
}

/// Strongly-typed key for PropertyList supported values (String, Int, Bool, Data, Date, Array, Dictionary)
struct DefaultsPlistKey<Value>: AnyDefaultsKey {
    let rawKey: String
    let defaultValue: Value
    
    init(_ rawKey: String, default defaultValue: Value) {
        self.rawKey = rawKey
        self.defaultValue = defaultValue
    }
}

/// Lightweight manager responsible for reading/writing values with typed keys
/// Supports both Codable and PropertyList representable types
final class UserDefaultsManager {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // MARK: - Codable
    func setCodable<Value: Codable>(_ value: Value, forKey key: DefaultsCodableKey<Value>) throws {
        let data = try key.encoder.encode(value)
        defaults.set(data, forKey: key.rawKey)
    }
    
    func codable<Value: Codable>(forKey key: DefaultsCodableKey<Value>) -> Value {
        guard let data = defaults.data(forKey: key.rawKey) else { return key.defaultValue }
        do {
            return try key.decoder.decode(Value.self, from: data)
        } catch {
            // If decoding fails, fall back to default value
            return key.defaultValue
        }
    }
    
    // MARK: - PropertyList
    func setPlist<Value>(_ value: Value, forKey key: DefaultsPlistKey<Value>) {
        defaults.set(value, forKey: key.rawKey)
    }
    
    func plist<Value>(forKey key: DefaultsPlistKey<Value>) -> Value {
        // Use optional cast and default fallback
        if let value = defaults.object(forKey: key.rawKey) as? Value {
            return value
        }
        return key.defaultValue
    }
    
    func remove(_ key: AnyDefaultsKey) {
        defaults.removeObject(forKey: key.rawKey)
    }
}


