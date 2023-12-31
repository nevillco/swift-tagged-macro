import SwiftDiagnostics
import SwiftSyntax

// MARK: - TaggedMacroError
public struct TaggedMacroError: Error {

    public let message: String

    public enum Kind: String {
        case incorrectArgumentListCount
        case invalidRawTypeArgument
        case invalidNameArgument
        case invalidAccessLevel
    }
    public let kind: Kind

    public init(
        message: String,
        kind: Kind
    ) {
        self.message = message
        self.kind = kind
    }

}

// MARK: - TaggedMacroError - DiagnosticMessage
extension TaggedMacroError: DiagnosticMessage {

    public var diagnosticID: SwiftDiagnostics.MessageID {
        .init(
            domain: "TaggedMacroError",
            id: kind.rawValue
        )
    }

    public var severity: SwiftDiagnostics.DiagnosticSeverity {
        .error
    }

}

// MARK: - TaggedMacroError - Public
public extension TaggedMacroError {

    func diagnostic(node: SyntaxProtocol) -> DiagnosticsError {
        .init(diagnostics: [
            .init(node: node, message: self),
        ])
    }

}

// MARK: - TaggedMacroError - Internal
extension TaggedMacroError {

    static let incorrectArgumentListCount = Self.init(
        message: "#tagged expects 2 or 3 arguments: the raw type to be wrapped, the new type name, and optionally the new type’s access level.",
        kind: .incorrectArgumentListCount
    )

    static let invalidRawTypeArgument = Self.init(
        message: "Invalid raw type: please provide a valid type name as the first argument.",
        kind: .invalidRawTypeArgument
    )

    static let invalidNameArgument = Self.init(
        message: "Invalid name: please provide a String value for the name of your tagged type as the second argument.",
        kind: .invalidNameArgument
    )

    static let invalidAccessLevel = Self.init(
        message: "Invalid access level provided for #tagged type.",
        kind: .invalidAccessLevel
    )

}
