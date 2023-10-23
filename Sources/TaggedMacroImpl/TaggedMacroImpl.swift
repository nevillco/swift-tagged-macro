import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct TaggedMacroImpl: DeclarationMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let argumentList = node.argumentList

        guard [2, 3].contains(argumentList.count) else {
            throw TaggedMacroError.incorrectArgumentListCount.diagnostic(node: node)
        }

        guard let rawTypeArgument = argumentList.first?.expression
            .as(MemberAccessExprSyntax.self)?.base?
            .as(DeclReferenceExprSyntax.self)?.baseName.text
        else {
            throw TaggedMacroError.invalidRawTypeArgument.diagnostic(node: node)
        }

        let middleIndex = argumentList.index(after: argumentList.startIndex)
        guard let nameArgumentSegment = argumentList[middleIndex].expression
            .as(StringLiteralExprSyntax.self)?.segments.first,
            case .stringSegment(let nameArgumentSyntax) = nameArgumentSegment,
            case let nameArgument = nameArgumentSyntax.content.text
        else {
            throw TaggedMacroError.invalidNameArgument.diagnostic(node: node)
        }

        let accessString: String
        if argumentList.count == 3 {
            guard let accessArgument = argumentList.last?.expression
                .as(MemberAccessExprSyntax.self)?.declName.baseName.text,
                let access = AccessLevelModifier(rawValue: accessArgument)
            else {
                throw TaggedMacroError.invalidAccessLevel.diagnostic(node: node)
            }
            accessString = "\(access.keyword) "
        } else {
            accessString = ""
        }


        return [
        """
        \(raw: accessString)enum \(raw: nameArgument)_Tag { }
        \(raw: accessString)typealias \(raw: nameArgument) = Tagged<\(raw: nameArgument)_Tag, \(raw: rawTypeArgument)>
        """
        ]
    }

}
