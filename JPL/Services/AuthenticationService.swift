import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var error: Error?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            let userData = try await fetchUserData(userId: result.user.uid)
            DispatchQueue.main.async {
                self.currentUser = userData
                self.isAuthenticated = true
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func signUp(email: String, password: String, displayName: String) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let newUser = User(
                id: result.user.uid,
                email: email,
                displayName: displayName,
                profileImageUrl: nil,
                lastLoginDate: Date(),
                learningLevel: "N5",
                studyStreak: 0,
                completedLessons: []
            )
            try await saveUserData(user: newUser)
            DispatchQueue.main.async {
                self.currentUser = newUser
                self.isAuthenticated = true
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
                self.isAuthenticated = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    private func fetchUserData(userId: String) async throws -> User {
        let document = try await db.collection("users").document(userId).getDocument()
        return try document.data(as: User.self)
    }
    
    private func saveUserData(user: User) async throws {
        try await db.collection("users").document(user.id).setData(from: user)
    }
} 