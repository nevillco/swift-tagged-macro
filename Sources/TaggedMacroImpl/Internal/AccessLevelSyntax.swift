import SwiftSyntax

// MARK: - AccessLevelSyntax
public protocol AccessLevelSyntax {

    var modifiers: DeclModifierListSyntax { get }

}

// MARK: - AccessLevelSyntax - Internal
extension AccessLevelSyntax {

    var accessLevelModifier: AccessLevelModifier? {
        modifiers.lazy
            .compactMap { AccessLevelModifier(rawValue: $0.name.text) }
            .first
    }

}

// MARK: - AccessLevelSyntax - Conformances
extension StructDeclSyntax: AccessLevelSyntax { }
extension ClassDeclSyntax: AccessLevelSyntax { }
extension EnumDeclSyntax: AccessLevelSyntax { }
extension ExtensionDeclSyntax: AccessLevelSyntax { }
extension ActorDeclSyntax: AccessLevelSyntax { }
extension FunctionDeclSyntax: AccessLevelSyntax { }
extension VariableDeclSyntax: AccessLevelSyntax { }

// MARK: - DeclGroupSyntax
extension DeclGroupSyntax {

    var declAccessLevel: AccessLevelModifier? {
        get { (self as? AccessLevelSyntax)?.accessLevelModifier }
    }

}
