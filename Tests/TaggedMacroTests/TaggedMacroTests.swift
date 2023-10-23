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
            struct Person {

                #tagged(UUID.self, "ID")
                let id: ID

                #tagged(String.self, "FirstName")
                let firstName: FirstName
                #tagged(String.self, "LastName", access: .private)
                private let lastName: LastName

                #tagged(Int.self, "YearsOld", access: nil)
                let yearsOld: YearsOld

            }
            """
        } expansion: {
            """
            struct Person {

                enum ID_Tag {
                }
                typealias ID = Tagged<ID_Tag, UUID>
                let id: ID

                enum FirstName_Tag {
                }
                typealias FirstName = Tagged<FirstName_Tag, String>
                let firstName: FirstName
                private enum LastName_Tag {
                }
                private typealias LastName = Tagged<LastName_Tag, String>
                private let lastName: LastName

                enum YearsOld_Tag {
                }
                typealias YearsOld = Tagged<YearsOld_Tag, Int>
                let yearsOld: YearsOld

            }
            """
        }
    }

}
