@freestanding(declaration, names: arbitrary)
public macro tagged<T>(_ taggedType: T.Type, _ typeName: String) = #externalMacro(
    module: "TaggedMacroImpl",
    type: "TaggedMacroImpl"
)
