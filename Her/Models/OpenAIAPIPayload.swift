// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let openAIAPIPayload = try OpenAIAPIPayload(json)

import Foundation

// MARK: - OpenAIAPIPayload
struct OpenAIAPIPayload: Codable {
    let prompt: String
    let temperature: Double
    let maxTokens, topP: Int
    let frequencyPenalty: Double
    let presencePenalty: Int

    enum CodingKeys: String, CodingKey {
        case prompt, temperature
        case maxTokens = "max_tokens"
        case topP = "top_p"
        case frequencyPenalty = "frequency_penalty"
        case presencePenalty = "presence_penalty"
    }
}

// MARK: OpenAIAPIPayload convenience initializers and mutators

extension OpenAIAPIPayload {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OpenAIAPIPayload.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        prompt: String? = nil,
        temperature: Double? = nil,
        maxTokens: Int? = nil,
        topP: Int? = nil,
        frequencyPenalty: Double? = nil,
        presencePenalty: Int? = nil
    ) -> OpenAIAPIPayload {
        return OpenAIAPIPayload(
            prompt: prompt ?? self.prompt,
            temperature: temperature ?? self.temperature,
            maxTokens: maxTokens ?? self.maxTokens,
            topP: topP ?? self.topP,
            frequencyPenalty: frequencyPenalty ?? self.frequencyPenalty,
            presencePenalty: presencePenalty ?? self.presencePenalty
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
