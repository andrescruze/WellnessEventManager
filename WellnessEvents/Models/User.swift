import Foundation

enum UserRole: String, Codable {
    case attendee
    case organizer

    var displayName: String {
        switch self {
        case .attendee: return "Attendee"
        case .organizer: return "Organizer"
        }
    }
}

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var password: String
    var role: UserRole
    var bio: String
    var joinDate: Date

    init(
        id: String = UUID().uuidString,
        name: String,
        email: String,
        password: String,
        role: UserRole,
        bio: String = "",
        joinDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.bio = bio
        self.joinDate = joinDate
    }
}
