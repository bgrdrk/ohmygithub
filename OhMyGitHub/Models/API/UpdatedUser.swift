import Foundation

struct UpdatedUser: Encodable {
    let name: String?
    let email: String?
    let company: String?
    let location: String?
    let blog: String?
    let hireable: Bool?
    let bio: String?
    let twitterUsername: String?
    
    init(name: String? = nil,
         email: String? = nil,
         company: String? = nil,
         location: String? = nil,
         blog: String? = nil,
         hireable: Bool? = nil,
         bio: String? = nil,
         twitterUsername: String? = nil)
    {
        self.name = name
        self.email = email
        self.company = company
        self.location = location
        self.blog = blog
        self.hireable = hireable
        self.bio = bio
        self.twitterUsername = twitterUsername
    }
}
