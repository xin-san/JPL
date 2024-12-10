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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// 持久化控制器
class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        // 打印Bundle信息，用于调试
        print("Bundle path: \(Bundle.main.bundlePath)")
        if let modelURL = Bundle.main.url(forResource: "VocabularyData", withExtension: "momd") {
            print("Found model at: \(modelURL)")
        } else {
            print("Could not find VocabularyData.momd in bundle")
        }
        
        container = NSPersistentContainer(name: "VocabularyData")
        
        // 配置持久化存储描述
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        
        // 获取文档目录路径
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[0]
        let storeURL = docURL.appendingPathComponent("VocabularyData.sqlite")
        description.url = storeURL
        
        print("Store URL: \(storeURL)")
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Core Data 加载失败: \(error.localizedDescription)")
                print("Error details: \(error.userInfo)")
                
                // 如果是迁移错误，尝试删除并重新创建存储
                if error.domain == NSCocoaErrorDomain && 
                   (error.code == NSPersistentStoreIncompatibleVersionHashError ||
                    error.code == NSMigrationMissingSourceModelError) {
                    
                    print("Attempting to delete and recreate store...")
                    try? FileManager.default.removeItem(at: storeURL)
                    
                    // 重新尝试加载
                    self.container.loadPersistentStores { _, error in
                        if let error = error {
                            fatalError("Second attempt to load store failed: \(error)")
                        }
                    }
                } else {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // 设置错误处理
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // 打印实体描述信息
        if let entityDescription = NSEntityDescription.entity(forEntityName: "VocabularyEntity", in: container.viewContext) {
            print("Found entity description: \(entityDescription)")
        } else {
            print("Could not find entity description for VocabularyEntity")
        }
    }
    
    // 用于重置存储的方法
    func resetStore() {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[0]
        let storeURL = docURL.appendingPathComponent("VocabularyData.sqlite")
        
        do {
            try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
            try FileManager.default.removeItem(at: storeURL)
            print("Successfully reset store")
        } catch {
            print("Failed to reset store: \(error)")
        }
    }
}
