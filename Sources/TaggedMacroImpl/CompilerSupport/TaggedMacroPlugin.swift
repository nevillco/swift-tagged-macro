import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main struct TaggedMacroPlugin: CompilerPlugin {

    let providingMacros: [Macro.Type] = [
        TaggedMacroImpl.self,
    ]

}
