import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import UIKit

enum AuthError: LocalizedError {
    case emptyFields
    case passwordMismatch
    case weakPassword
    case wrongPassword
    case emailAlreadyInUse
    case invalidEmail
    case networkError
    case googleSignInFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "请填写所有必填项"
        case .passwordMismatch:
            return "两次输入的密码不一致"
        case .weakPassword:
            return "密码强度不够，请使用至少6位字符"
        case .wrongPassword:
            return "密码错误，请重新输入"
        case .emailAlreadyInUse:
            return "该邮箱已被注册"
        case .invalidEmail:
            return "邮箱格式不正确"
        case .networkError:
            return "网络连接错误，请检查网络设置"
        case .googleSignInFailed:
            return "Google 登录失败"
        case .unknown(let error):
            return "发生错误: \(error.localizedDescription)"
        }
    }
}

class AuthenticationService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var error: Error?
    @Published var isLoading = false
    private var stateListener: AuthStateDidChangeListenerHandle?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        stateListener = auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user {
                Task { @MainActor in
                    do {
                        let userData = try await self.fetchUserData(userId: user.uid)
                        self.currentUser = userData
                        self.isAuthenticated = true
                    } catch {
                        print("获取用户数据失败: \(error.localizedDescription)")
                        do {
                            try await self.signOut()
                        } catch {
                            print("退出登录失败: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                Task { @MainActor in
                    self.currentUser = nil
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    func signInWithGoogle() async throws {
        await MainActor.run { isLoading = true }
        defer { Task { @MainActor in isLoading = false } }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("错误：无法获取 Firebase clientID")
            throw AuthError.googleSignInFailed
        }
        
        print("Firebase clientID: \(clientID)")
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let rootViewController: UIViewController? = await MainActor.run {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                return nil
            }
            return rootViewController
        }
        
        guard let rootViewController = rootViewController else {
            print("错误：无法获取根视图控制器")
            throw AuthError.googleSignInFailed
        }
        
        do {
            print("开始 Google 登录流程")
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                print("错误：无法获取 Google idToken")
                throw AuthError.googleSignInFailed
            }
            
            print("成功获取 Google idToken")
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            print("开始 Firebase 身份验证")
            let authResult = try await auth.signIn(with: credential)
            print("Firebase 身份验证成功: \(authResult.user.uid)")
            
            let userData = try await fetchUserData(userId: authResult.user.uid)
            try await updateLastLoginDate(for: authResult.user.uid)
            
            await MainActor.run {
                self.currentUser = userData
                self.isAuthenticated = true
                print("登录状态更新完成：已认证")
            }
        } catch {
            print("Google 登录失败，详细错误: \(error.localizedDescription)")
            if let error = error as? GIDSignInError {
                switch error.code {
                case .canceled:
                    print("用户取消登录")
                    throw AuthError.unknown(error)
                case .unknown:
                    print("未知的 Google 登录错误")
                    throw AuthError.googleSignInFailed
                default:
                    print("其他 Google 登录错误: \(error.localizedDescription)")
                    throw AuthError.googleSignInFailed
                }
            } else if let error = error as? AuthErrorCode {
                switch error {
                case .networkError:
                    print("网络错误")
                    throw AuthError.networkError
                default:
                    print("Firebase 认证错误: \(error.localizedDescription)")
                    throw AuthError.googleSignInFailed
                }
            } else {
                print("未知错误: \(error)")
                throw AuthError.unknown(error)
            }
        }
    }
    
    private func userExists(userId: String) async throws -> Bool {
        print("检查用户是否存在: \(userId)")
        let document = try await db.collection("users").document(userId).getDocument()
        return document.exists
    }
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        guard !email.isEmpty && !password.isEmpty else {
            throw AuthError.emptyFields
        }
        
        do {
            print("开始登录: \(email)")
            let result = try await auth.signIn(withEmail: email, password: password)
            let userData = try await fetchUserData(userId: result.user.uid)
            try await updateLastLoginDate(for: result.user.uid)
            
            print("登录成功: \(result.user.uid)")
            DispatchQueue.main.async {
                self.currentUser = userData
                self.isAuthenticated = true
            }
        } catch {
            print("登录失败: \(error.localizedDescription)")
            let authError = error as NSError
            switch authError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                throw AuthError.wrongPassword
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError
            default:
                throw AuthError.unknown(error)
            }
        }
    }
    
    func signUp(email: String, password: String, displayName: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            print("开始注册: \(email)")
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
            
            print("创建用户成功，开始保存用户数据")
            try await saveUserData(user: newUser)
            
            print("注册成功: \(result.user.uid)")
            DispatchQueue.main.async {
                self.currentUser = newUser
                self.isAuthenticated = true
            }
        } catch {
            print("注册失败: \(error.localizedDescription)")
            let authError = error as NSError
            switch authError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw AuthError.emailAlreadyInUse
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail
            case AuthErrorCode.weakPassword.rawValue:
                throw AuthError.weakPassword
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError
            default:
                throw AuthError.unknown(error)
            }
        }
    }
    
    @MainActor
    func signOut() async throws {
        print("开始退出登录")
        do {
            // 退出 Firebase 认证
            try Auth.auth().signOut()
            
            // 退出 Google 登录
            GIDSignIn.sharedInstance.signOut()
            
            // 清除用户数据
            self.currentUser = nil
            self.isAuthenticated = false
            
            print("退出登录��功")
        } catch {
            print("退出登录失败: \(error.localizedDescription)")
            throw AuthError.unknown(error)
        }
    }
    
    func resetPassword(email: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            print("开始发送密码重置邮件: \(email)")
            try await auth.sendPasswordReset(withEmail: email)
            print("密码重置邮件发送成功")
        } catch {
            print("发送密码重置邮件失败: \(error.localizedDescription)")
            let authError = error as NSError
            switch authError.code {
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError
            default:
                throw AuthError.unknown(error)
            }
        }
    }
    
    private func fetchUserData(userId: String) async throws -> User {
        print("开始获取用户数据: \(userId)")
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            
            guard document.exists else {
                print("用户数据不存在，创建新用户")
                let newUser = User(
                    id: userId,
                    email: auth.currentUser?.email ?? "",
                    displayName: auth.currentUser?.displayName ?? "用户",
                    profileImageUrl: auth.currentUser?.photoURL?.absoluteString,
                    lastLoginDate: Date(),
                    learningLevel: "N5",
                    studyStreak: 0,
                    completedLessons: []
                )
                try await saveUserData(user: newUser)
                return newUser
            }
            
            guard let data = document.data() else {
                throw AuthError.unknown(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法获取用户数据"]))
            }
            
            print("获取到原始数据: \(data)")
            
            // 构建用户数据字典
            var userData: [String: Any] = [:]
            
            // 必需字段
            userData["id"] = data["id"] as? String ?? userId
            userData["email"] = data["email"] as? String ?? auth.currentUser?.email ?? ""
            userData["learningLevel"] = data["learningLevel"] as? String ?? "N5"
            userData["studyStreak"] = data["studyStreak"] as? Int ?? 0
            userData["completedLessons"] = data["completedLessons"] as? [String] ?? []
            
            // 可选字段
            if let displayName = data["displayName"] as? String {
                userData["displayName"] = displayName
            }
            if let profileImageUrl = data["profileImageUrl"] as? String {
                userData["profileImageUrl"] = profileImageUrl
            }
            
            // 处理时间戳
            if let timestamp = data["lastLoginDate"] as? Timestamp {
                userData["lastLoginDate"] = timestamp.dateValue().timeIntervalSince1970
            } else {
                userData["lastLoginDate"] = Date().timeIntervalSince1970
            }
            
            print("处理后的用户数据: \(userData)")
            
            let jsonData = try JSONSerialization.data(withJSONObject: userData)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let user = try decoder.decode(User.self, from: jsonData)
            print("用户数据解码成功: \(user)")
            return user
            
        } catch {
            print("获取用户数据失败: \(error.localizedDescription)")
            print("详细错误: \(error)")
            throw error
        }
    }
    
    private func saveUserData(user: User) async throws {
        print("开始保存用户数据: \(user.id)")
        var dict: [String: Any] = [
            "id": user.id,
            "email": user.email,
            "learningLevel": user.learningLevel,
            "studyStreak": user.studyStreak,
            "completedLessons": user.completedLessons,
            "lastLoginDate": FieldValue.serverTimestamp()
        ]
        
        if let displayName = user.displayName {
            dict["displayName"] = displayName as String
        }
        if let profileImageUrl = user.profileImageUrl {
            dict["profileImageUrl"] = profileImageUrl as String
        }
        
        try await db.collection("users").document(user.id).setData(dict, merge: true)
        print("用户数据保存成功")
    }
    
    private func updateLastLoginDate(for userId: String) async throws {
        print("更新最后登录时间: \(userId)")
        try await db.collection("users").document(userId).updateData([
            "lastLoginDate": FieldValue.serverTimestamp()
        ])
    }
    
    deinit {
        if let listener = stateListener {
            auth.removeStateDidChangeListener(listener)
        }
    }
} 