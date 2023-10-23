import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct TaggedMacroImpl: DeclarationMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let argumentList = node.argumentList

        guard argumentList.count == 2 else {
            throw TaggedMacroError.incorrectArgumentListCount.diagnostic(node: node)
        }

        guard let rawTypeArgument = node.argumentList.first?.expression
            .as(MemberAccessExprSyntax.self)?.base?
            .as(DeclReferenceExprSyntax.self)?.baseName.text
        else {
            throw TaggedMacroError.invalidRawTypeArgument.diagnostic(node: node)
        }

        guard let nameArgumentSegment = node.argumentList.last?.expression
            .as(StringLiteralExprSyntax.self)?.segments.first,
            case .stringSegment(let nameArgumentSyntax) = nameArgumentSegment,
            case let nameArgument = nameArgumentSyntax.content.text
        else {
            throw TaggedMacroError.invalidNameArgument.diagnostic(node: node)
        }


        return [
        """
        enum \(raw: nameArgument)_Tag { }
        typealias \(raw: nameArgument) = Tagged<\(raw: nameArgument)_Tag, \(raw: rawTypeArgument)>
        """
        ]
    }

}
