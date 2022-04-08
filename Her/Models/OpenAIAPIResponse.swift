// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let openAIAPIResponse = try OpenAIAPIResponse(json)

import Foundation

// MARK: - OpenAIAPIResponse
struct OpenAIAPIResponse: Codable {
    let id, object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

// MARK: OpenAIAPIResponse convenience initializers and mutators

extension OpenAIAPIResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OpenAIAPIResponse.self, from: data)
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
        id: String? = nil,
        object: String? = nil,
        created: Int? = nil,
        model: String? = nil,
        choices: [Choice]? = nil
    ) -> OpenAIAPIResponse {
        return OpenAIAPIResponse(
            id: id ?? self.id,
            object: object ?? self.object,
            created: created ?? self.created,
            model: model ?? self.model,
            choices: choices ?? self.choices
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Choice
struct Choice: Codable {
    let text: String
    let index: Int
    let logprobs: JSONNull?
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case text, index, logprobs
        case finishReason = "finish_reason"
    }
}

// MARK: Choice convenience initializers and mutators

extension Choice {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Choice.self, from: data)
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
        text: String? = nil,
        index: Int? = nil,
        logprobs: JSONNull?? = nil,
        finishReason: String? = nil
    ) -> Choice {
        return Choice(
            text: text ?? self.text,
            index: index ?? self.index,
            logprobs: logprobs ?? self.logprobs,
            finishReason: finishReason ?? self.finishReason
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

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

