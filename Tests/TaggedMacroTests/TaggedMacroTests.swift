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

    func testSuccess_UUID_Internal() {
        assertMacro {
            """
            struct Example {
                @Tagged(UUID.self) let id: ID
            }
            """
        } expansion: {
            """
            struct Example {
                let id: ID

                enum ID_Tag {
                }
                typealias ID = Tagged<ID_Tag, UUID>
            }
            """
        }
    }

}
