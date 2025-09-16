//
//  EndpointManager.swift
//  Simplified endpoint constants for Lesson 2
//

import Foundation

enum EndpointManager {
    enum BaseURL: String {
        case main = "https://newsapi.org/v2"
    }
    
    enum Path: String {
        case everything = "everything"
        case topHeadlines = "top-headlines"
    }
}



