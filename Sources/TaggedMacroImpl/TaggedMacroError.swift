import SwiftDiagnostics
import SwiftSyntax

// MARK: - TaggedMacroError
public struct TaggedMacroError: Error {

    public let message: String

    public enum Kind: String {
        case notAVariable
        case customTypeNameNotFound
        case rawTypeNameNotFound
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

    static let notAVariable = Self(
        message: "@Wrapped can only be attached to variables.",
        kind: .notAVariable
    )

    static let customTypeNameNotFound = Self(
        message: "@Wrapped requires you provide a name for the type that will be generated, such as `: ID` or `: FirstName`.",
        kind: .customTypeNameNotFound
    )

    static let rawTypeNameNotFound = Self.init(
        message: "Raw type not found. This should be passed as an argument to @Wrapped, such as `@Wrapped(UUID.self).",
        kind: .rawTypeNameNotFound
    )

}
