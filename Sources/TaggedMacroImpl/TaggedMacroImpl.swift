import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct TaggedMacroImpl: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDeclaration = declaration
            .as(VariableDeclSyntax.self) else {
            throw TaggedMacroError
                .notAVariable.diagnostic(node: node)
        }
        guard let customTypeName = variableDeclaration
            .tokens(viewMode: .fixedUp)
            .compactMap({ variableToken in
                switch variableToken.tokenKind {
                case let .identifier(typeName): return typeName
                default: return nil
                }
            }).last else {
            throw TaggedMacroError.customTypeNameNotFound.diagnostic(node: node)
        }

        guard let rawTypeName = node
            .tokens(viewMode: .fixedUp)
            .compactMap({ variableToken in
                switch variableToken.tokenKind {
                case let .identifier(typeName)
                    where typeName != "Tagged": return typeName
                default: return nil
                }
            }).first else {
            throw TaggedMacroError.rawTypeNameNotFound.diagnostic(node: node)
        }

        let declarationAccessLevel = variableDeclaration.accessLevelModifier
        let accessLevelString = declarationAccessLevel.map { "\($0) " } ?? ""

        return [
"""
\(raw: accessLevelString)enum \(raw: customTypeName)_Tag { }
\(raw: accessLevelString)typealias \(raw: customTypeName) = Tagged<\(raw: customTypeName)_Tag, \(raw: rawTypeName)>
"""
        ]
    }

}
