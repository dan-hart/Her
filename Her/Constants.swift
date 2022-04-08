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
}

// swiftlint:enable line_length
