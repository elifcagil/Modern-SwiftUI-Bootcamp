//
//  AccessProvider.swift
//

import Foundation

protocol AccessProviderProtocol {
    func apiKey() -> String?
}

final class AccessProvider: AccessProviderProtocol {
    func apiKey() -> String? {
        ProcessInfo.processInfo.environment["NEWS_API_KEY"]
    }
}



