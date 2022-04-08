//
//  Constants.swift
//  Fragment
//
//  Created by Dan Hart on 3/26/22.
//

import Foundation
#if canImport(UIKit)
    import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

// swiftlint:disable line_length
enum Constants {
    static let appName = "Her"
    static let buyMeACoffeeUsername = "codedbydan"

    enum URL: String {
        case repositoryOnGitHub = "https://github.com/dan-hart/Her"
        case buyMeACoffee = "https://www.buymeacoffee.com/codedbydan"
    }

    enum Feature {
    }
    
    class Colors {
        static let secondary = Color("SecondaryColor")
    }

    /// Is the current device running macOS or is it an iPad
    static func isMacOrPad() -> Bool {
        #if os(macOS)
            return true
        #endif

        #if canImport(UIKit)
            if UIDevice.current.userInterfaceIdiom == .pad {
                return true
            } else {
                return false
            }
        #endif
    }
    
    enum ManualEngine: String, CaseIterable {
        case text_davinci_002 = "text-davinci-002"
    }
    
    // MARK: - Presets
    class Presets {
        static var all: [HerPreset] = [essayOutline, interviewQuestions]
        
        static var essayOutline = HerPreset(name: "Essay Outline",engine: ManualEngine.text_davinci_002.rawValue, temperature: 0, maxTokens: 150, topP: 1, frequencyPenalty: 0, presencePenalty: 0)
        static var interviewQuestions = HerPreset(name: "Interview Questions", engine: ManualEngine.text_davinci_002.rawValue, temperature: 0, maxTokens: 150, topP: 1, frequencyPenalty: 0, presencePenalty: 0)
        
        static func get(byName: String) -> HerPreset? {
            for preset in Presets.all {
                if preset.name == byName {
                    return preset
                }
            }
            
            return nil
        }
    }
}

// swiftlint:enable line_length
