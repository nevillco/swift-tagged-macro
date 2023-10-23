import MacroTesting
@testable import TaggedMacroImpl
import XCTest

final class TaggedMacroTests: XCTestCase {

    override func invokeTest() {
        withMacroTesting(
            isRecording: false,
            macros: [
                "Tagged": TaggedMacroImpl.self
            ]
        ) {
            super.invokeTest()
        }
    }

    func testSuccess() {
        assertMacro {
            """
            public struct Example {
                @Tagged(UUID.self) let id: ID
                @Tagged(UUID.self) public let publicID: PublicID
            }
            """
        } expansion: {
            """
            public struct Example {
                let id: ID

                enum ID_Tag {
                }
                typealias ID = Tagged<ID_Tag, UUID>
                public let publicID: PublicID

                public enum PublicID_Tag {
                }
                public typealias PublicID = Tagged<PublicID_Tag, UUID>
            }
            """
        }
    }

}
