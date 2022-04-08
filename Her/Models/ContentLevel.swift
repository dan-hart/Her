//
//  ContentLevel.swift
//  Her
//
//  Created by Dan Hart on 4/7/22.
//

import Foundation

enum ContentLevel: String, CaseIterable {
    case `safe`
    /// This means that the text could be talking about a sensitive topic, something political, religious, or talking about a protected class such as race or nationality.
    case sensitive
    /// This means that the text contains profane language, prejudiced or hateful language, something that could be NSFW, or text that portrays certain groups/people in a harmful manner.
    case `unsafe`
    case unexpected
    
    var meaning: String? {
        switch self {
        case .safe:
            return "Content is suitable for all audiences."
        case .sensitive:
            return "This means that the text could be talking about a sensitive topic, something political, religious, or talking about a protected class such as race or nationality."
        case .unsafe:
            return "This means that the text contains profane language, prejudiced or hateful language, something that could be NSFW, or text that portrays certain groups/people in a harmful manner."
        case .unexpected:
            return "The content level is unknown."
        }
    }
    
    public init(from value: Int) {
        switch value {
        case 0:
            self = .safe
        case 1:
            self = .sensitive
        case 2:
            self = .unsafe
        default:
            self = .unexpected
        }
    }
}
