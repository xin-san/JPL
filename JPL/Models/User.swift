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
    
    init(id: String,
         email: String,
         displayName: String? = nil,
         profileImageUrl: String? = nil,
         lastLoginDate: Date = Date(),
         learningLevel: String = "N5",
         studyStreak: Int = 0,
         completedLessons: [String] = []) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.profileImageUrl = profileImageUrl
        self.lastLoginDate = lastLoginDate
        self.learningLevel = learningLevel
        self.studyStreak = studyStreak
        self.completedLessons = completedLessons
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return """
        User(id: \(id),
             email: \(email),
             displayName: \(displayName ?? "nil"),
             profileImageUrl: \(profileImageUrl ?? "nil"),
             lastLoginDate: \(lastLoginDate),
             learningLevel: \(learningLevel),
             studyStreak: \(studyStreak),
             completedLessons: \(completedLessons))
        """
    }
} 