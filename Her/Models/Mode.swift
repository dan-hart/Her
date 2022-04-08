//
//  Mode.swift
//  Her
//
//  Created by Dan Hart on 4/7/22.
//

import Foundation
import OpenAI

enum Mode: String, CaseIterable {
    case complete
    case codex
    case instruct
    case filter
    case preset
}
