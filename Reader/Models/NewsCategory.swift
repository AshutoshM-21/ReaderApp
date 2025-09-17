//
//  NewsCategory.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 16/09/25.
//

import Foundation

enum NewsCategory: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health

    var displayName: String {
        switch self {
        case .general: return "General"
        case .business: return "Business"
        case .technology: return "Technology"
        case .entertainment: return "Entertainment"
        case .sports: return "Sports"
        case .science: return "Science"
        case .health: return "Health"
        }
    }
}
