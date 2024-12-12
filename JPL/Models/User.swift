import Foundation

struct User: Codable {
    let id: String
    var email: String
    var displayName: String?
    var profileImageUrl: String?
    var lastLoginDate: Date
    var learningLevel: String // N5, N4, etc.
    var studyStreak: Int
    var completedLessons: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName
        case profileImageUrl
        case lastLoginDate
        case learningLevel
        case studyStreak
        case completedLessons
    }
} 