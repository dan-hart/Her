//
//  HerHelper.swift
//  Her
//
//  Created by Dan Hart on 4/7/22.
//

import Foundation
import KeychainAccess
import OpenAI
import SwiftUI
import LoremSwiftum

class HerHelper: ObservableObject {
    var keychainKeyIdentifier = "OPENAI_API_KEY"
    
    var isUIEnabled: Binding<Bool>?
    
    // MARK: - App Storage
    @AppStorage("selectedMode") public var selectedMode: String = Mode.complete.rawValue
    @AppStorage("selectedEngine") public var selectedEngine: String = Engine.ID.ada.description
    @AppStorage("maxTokens") public var maxTokens: Double = 100.0
    @AppStorage("numberOfCompletions") public var numberOfCompletions = 1
    
    // MARK: - Publishable data
    @Published public var randomString = ""
    @Published public var isAuthenticated = false
        
    @Published public var selectableModes: [Mode] = Mode.allCases
    @Published public var selectableEngines: [Engine.ID] = [.ada, .babbage, .curie, .davinci]
    @Published public var engines: [Engine] = []
    
    private var client: Client?
    
    // MARK: - Computed
    
    var bundleID: String {
        Bundle.main.bundleIdentifier ?? ""
    }
    
    private var keychain: Keychain {
        Keychain(service: bundleID)
    }
    
    var key: String? {
        keychain[keychainKeyIdentifier]
    }
    
    // MARK: - Alerts
    
    @Published var alert: Alert? {
        didSet { isShowingAlert = alert != nil }
    }
    
    @Published var isShowingAlert = false
    
    // MARK: - Initialization
    
    init() {
    }
    
    // MARK: - Methods
    
    func invalidateSession() {
        keychain[keychainKeyIdentifier] = nil
        isAuthenticated = false
    }
    
    func startSession(with optionalKey: String? = nil) async throws {
        if let key = optionalKey {
            // Continue existing session
            client = try await authenticate(using: key)
            keychain[keychainKeyIdentifier] = key
        } else {
            // No token. Start a new session by providing one.
        }
    }
    
    // MARK: - Authentication
    
    private func getKey() throws -> String {
        guard let key = keychain[keychainKeyIdentifier] else {
            throw HerError.nilKey
        }
        
        return key
    }
    
    @MainActor
    private func authenticate(using key: String?) async throws -> Client {
        guard let key = key, !key.isEmpty else {
            throw HerError.nilKey
        }
        
        let client = Client(apiKey: key)
        let result = await withCheckedContinuation { continuation in
            client.engines { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case .success(let engines):
            self.isAuthenticated = true
            self.engines = engines
            return client
        case let .failure(error):
            throw error
        }
    }
    
    // MARK: - Operations
    func operate(using mode: Mode, from prompt: String) async throws -> String? {
        switch mode {
        case .complete:
            return try await complete(from: prompt)
        case .codex:
            return try await codex(from: prompt)
        case .instruct:
            return try await instruct(from: prompt)
        case .filter:
            return try await filter(from: prompt).rawValue
        }
    }
    
    func complete(from prompt: String) async throws -> String? {
        try await validate()
        
        let engineID = Engine.ID(selectedEngine)
        let result = await withCheckedContinuation { continuation in
            client?.completions(engine: engineID,
                                prompt: prompt,
                                numberOfTokens: ...Int(maxTokens),
                                numberOfCompletions: numberOfCompletions) { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case let .success(completions):
            return completions.first?.choices.first?.text
        case let .failure(error):
            throw error
        }
    }
    
    func codex(from prompt: String) async throws -> String? {
        try await validate()
        
        let maxTokenInt = Int(maxTokens)
        let engineID = Engine.ID(selectedEngine)
        let result = await withCheckedContinuation { continuation in
            client?.completions(engine: engineID,
                                prompt: prompt,
                                sampling: .temperature(0.0),
                                numberOfTokens: ...maxTokenInt,
                                numberOfCompletions: numberOfCompletions,
                                echo: false,
                                stop: ["\\"],
                                presencePenalty: 0.0,
                                frequencyPenalty: 0.0,
                                bestOf: 1) { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case let .success(completions):
            let choices = completions.flatMap(\.choices)
            let lines = choices.map { choice in
                return choice.text
            }
            return lines.joined(separator: "\n")
        case let .failure(error):
            throw error
        }
    }
    
    func instruct(from prompt: String) async throws -> String? {
        try await validate()
        
        let maxTokenInt = Int(maxTokens)
        let engineID = Engine.ID(selectedEngine)
        let result = await withCheckedContinuation { continuation in
            client?.completions(engine: engineID,
                               prompt: prompt,
                               sampling: .temperature(0.0),
                               numberOfTokens: ...maxTokenInt,
                               numberOfCompletions: numberOfCompletions,
                               stop: ["\n"],
                               presencePenalty: 0.0,
                               frequencyPenalty: 0.0,
                               bestOf: 1) { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case let .success(completions):
            let choices = completions.flatMap(\.choices)
            let lines = choices.map { choice in
                return choice.text
            }
            return lines.joined(separator: "\n")
        case let .failure(error):
            throw error
        }
    }
    
    func filter(from prompt: String) async throws -> ContentLevel {
        try await validate()
        
        let maxTokenInt = Int(maxTokens)
        let engineID = Engine.ID(selectedEngine)
        let result = await withCheckedContinuation { continuation in
            client?.completions(engine: engineID,
                               prompt: "<|endoftext|>\(prompt)\n--\nLabel:",
                               sampling: .temperature(0.0),
                               numberOfTokens: ...maxTokenInt,
                               numberOfCompletions: numberOfCompletions,
                               echo: false,
                               stop: ["<|endoftext|>[prompt]\n--\nLabel:"],
                               presencePenalty: 0.0,
                               frequencyPenalty: 0.0,
                               bestOf: 1) { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case let .success(completions):
            let intValue = Int(completions.flatMap(\.choices).first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? Int.max
            return ContentLevel(from: intValue)
        case let .failure(error):
            throw error
        }
    }
    
    // MARK: - Helpers
    
    func validate() async throws {
        if !isAuthenticated { throw HerError.notAuthenticated }
    }
    
    func call(thisAsyncThrowingCode: @escaping () async throws -> Void) async {
        do {
            try await thisAsyncThrowingCode()
        } catch {
            isUIEnabled?.wrappedValue = true
            
            var errorMessage = ""
            if error is HerError {
                errorMessage = (error as? HerError)?.rawValue ?? "Error"
            } else {
                errorMessage = error.localizedDescription
            }
            
            alert = Alert(title: Text("Oops!")
                .font(.system(.body, design: .monospaced)),
                          message: Text(errorMessage)
                .font(.system(.caption, design: .monospaced)), dismissButton: .default(Text("OK").foregroundColor(.accentColor)))
        }
    }
    
    func callTask(thisAsyncThrowingCode: @escaping () async throws -> Void) {
        Task {
            await call(thisAsyncThrowingCode: thisAsyncThrowingCode)
        }
    }
}
