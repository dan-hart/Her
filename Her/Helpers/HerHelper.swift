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
    
    // MARK: - App Storage
    @AppStorage("selectedEngine") public var selectedEngine: String = Engine.ID.ada.description
    @AppStorage("maxTokens") public var maxTokens: Double = 100.0
    @AppStorage("numberOfCompletions") public var numberOfCompletions = 1
    
    // MARK: - Publishable data
    @Published public var randomString = ""
    @Published public var isAuthenticated = false
    
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

    init() { }
    
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
    func complete(from prompt: String) async throws -> String? {
        try await validate()

        let result = await withCheckedContinuation { continuation in
            client?.completions(engine: Engine.ID(selectedEngine),
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
    
    // MARK: - Helpers

    func validate() async throws {
        if !isAuthenticated { throw HerError.notAuthenticated }
    }

    func call(thisAsyncThrowingCode: @escaping () async throws -> Void) async {
        do {
            try await thisAsyncThrowingCode()
        } catch {
            var errorMessage = ""
            if error is HerError {
                errorMessage = (error as? HerError)?.rawValue ?? "Error"
            } else {
                errorMessage = error.localizedDescription
            }

            alert = Alert(title: Text("Oops!").font(.system(.body, design: .monospaced)), message: Text(errorMessage).font(.system(.caption, design: .monospaced)))
        }
    }

    func callTask(thisAsyncThrowingCode: @escaping () async throws -> Void) {
        Task {
            await call(thisAsyncThrowingCode: thisAsyncThrowingCode)
        }
    }
}
