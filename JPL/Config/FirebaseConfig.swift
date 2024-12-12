import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseAnalytics

enum FirebaseConfig {
    static let googleServiceInfoPlistName = "GoogleService-Info"
    
    static func configure() {
        print("开始配置 Firebase...")
        
        // 检查配置文件是否存在
        guard let path = Bundle.main.path(forResource: googleServiceInfoPlistName, ofType: "plist") else {
            print("错误: 找不到 GoogleService-Info.plist 文件")
            fatalError("找不到 GoogleService-Info.plist 文件，请确保已添加到项目中")
        }
        
        print("找到配置文件路径: \(path)")
        
        // 尝试读取配置
        guard let options = FirebaseOptions(contentsOfFile: path) else {
            print("错误: 无法读取 Firebase 配置选项")
            fatalError("无法读取 Firebase 配置选项")
        }
        
        print("成功读取 Firebase 配置")
        print("Bundle ID: \(options.bundleID)")
        print("API Key: \(options.apiKey)")
        print("Project ID: \(options.projectID)")
        
        // 初始化 Firebase
        FirebaseApp.configure(options: options)
        print("Firebase 初始化完成")
        
        // 配置 Analytics
        Analytics.setAnalyticsCollectionEnabled(true)
        print("Analytics 配置完成")
        
        // 配置 Firestore
        let settings = Firestore.firestore().settings
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        Firestore.firestore().settings = settings
        print("Firestore 配置完成")
        
        // 验证 Auth 配置
        if Auth.auth().isSignIn(withEmailLink: "") {
            print("警告: Email link sign-in 已启用")
        }
        
        print("Firebase 配置全部完成")
    }
} 