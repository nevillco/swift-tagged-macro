import Foundation
import TaggedMacro
import Tagged

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
