//
//  JPLApp.swift
//  JPL
//
//  Created by 大帅哥 on R 6/12/09.
//

import SwiftUI
import CoreData

@main
struct JPLApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var vocabularyViewModel = VocabularyViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(vocabularyViewModel)
                .task {
                    do {
                        // 强制重新导入（仅用于测试）
                        VocabularyImportService.shared.resetImportStatus()
                        try await VocabularyImportService.shared.importDefaultVocabulary()
                        await vocabularyViewModel.loadVocabularyItems()
                    } catch {
                        print("导入词汇失败: \(error.localizedDescription)")
                        print("错误详情: \(error)")
                    }
                }
        }
    }
}

// 持久化控制器
class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "JPL")
        
        // 配置持久化存储描述
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        
        // 获取文档目录路径
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[0]
        let storeURL = docURL.appendingPathComponent("JPL.sqlite")
        description.url = storeURL
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Core Data 加载失败: \(error)")
                
                // 如果是迁移错误，尝试删除并重新创建存储
                if error.domain == NSCocoaErrorDomain && 
                   (error.code == NSPersistentStoreIncompatibleVersionHashError ||
                    error.code == NSMigrationMissingSourceModelError) {
                    
                    try? FileManager.default.removeItem(at: storeURL)
                    
                    // 重新尝试加载
                    self.container.loadPersistentStores { _, error in
                        if let error = error {
                            fatalError("Second attempt to load store failed: \(error)")
                        }
                    }
                }
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
