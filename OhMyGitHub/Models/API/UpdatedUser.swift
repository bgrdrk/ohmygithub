import Foundation

struct UpdatedUser: Encodable {
    let name: String?
    let hireable: Bool?
    
    init(name: String? = nil, hireable: Bool? = nil) {
        self.name = name
        self.hireable = hireable
    }
}
