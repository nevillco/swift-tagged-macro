import SwiftSyntax

// MARK: - AccessLevelModifier
public enum AccessLevelModifier: String, CaseIterable {

    case `private`
    case `fileprivate`
    case `internal`
    case `public`
    case `open`

    var keyword: Keyword {
        switch self {
        case .private: return .private
        case .fileprivate: return .fileprivate
        case .internal: return .internal
        case .public: return .public
        case .open: return .open
        }
    }

}
