import TaggedMacroImpl

@freestanding(declaration, names: arbitrary)
public macro tagged<T>(
    _ taggedType: T.Type,
    _ typeName: String,
    access accessLevel: AccessLevelModifier = .internal
) = #externalMacro(
    module: "TaggedMacroImpl",
    type: "TaggedMacroImpl"
)
