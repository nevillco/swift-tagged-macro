import MacroTesting
@testable import TaggedMacroImpl
import XCTest

final class TaggedMacroTests: XCTestCase {

    override func invokeTest() {
        withMacroTesting(
            isRecording: false,
            macros: [
                "tagged": TaggedMacroImpl.self
            ]
        ) {
            super.invokeTest()
        }
    }

    func testSuccess() {
        assertMacro {
            """
            public struct Example {
                #tagged(UUID.self, "ID")
            }
            """
        } expansion: {
            """
            public struct Example {
                enum ID_Tag { }
                typealias ID = Tagged<ID_Tag, UUID>
            }
            """
        }
    }

}
