import Foundation

// 用于解码 JSON 数据的结构
struct N5VocabularyData: Codable {
    let version: String
    let level: String
    let categories: [String: Category]
    
    struct Category: Codable {
        let name: String
        let description: String
        let items: [VocabularyItem]
    }
    
    struct VocabularyItem: Codable {
        let japanese: String
        let reading: String
        let meaning: String
        let partOfSpeech: String
        let examples: [Example]
        let conjugation: Conjugation?
        
        struct Example: Codable {
            let japanese: String
            let reading: String
            let meaning: String
        }
        
        struct Conjugation: Codable {
            let masu: String?
            let te: String?
            let ta: String?
            let nai: String?
            let past: String?
            let negative: String?
        }
    }
}

class VocabularyImportService {
    static let shared = VocabularyImportService()
    private let sqliteManager = VocabularySQLiteManager.shared
    
    private init() {}
    
    func importDefaultVocabulary() async throws {
        print("开始导入词汇...")
        
        // 检查是否已经导入
        let defaults = UserDefaults.standard
        let currentVersion = "1.0"
        let importedVersion = defaults.string(forKey: "ImportedVocabularyVersion")
        
        print("当前版本: \(currentVersion), 已导入版本: \(importedVersion ?? "无")")
        
        // 如果已导入当前版本，则跳过
        guard importedVersion != currentVersion else {
            print("已经导入过当前版本，跳过导入")
            return
        }
        
        // 从 JSON 文件加载数据
        guard let url = Bundle.main.url(forResource: "n5_vocabulary", withExtension: "json") else {
            print("未找到 n5_vocabulary.json 文件")
            throw ImportError.fileNotFound
        }
        
        print("找到词汇文件: \(url.path)")
        
        let data = try Data(contentsOf: url)
        print("成功读取文件数据，大小: \(data.count) bytes")
        
        // 解码 JSON 数据
        let decoder = JSONDecoder()
        let vocabularyData = try decoder.decode(N5VocabularyData.self, from: data)
        print("成功解码 JSON 数据，包含 \(vocabularyData.categories.count) 个类别")
        
        // 转换为 VocabularyItem 模型
        var vocabularyItems: [VocabularyItem] = []
        
        for (categoryKey, category) in vocabularyData.categories {
            print("处理类别: \(category.name) (\(categoryKey))")
            for item in category.items {
                let examples = item.examples.map { example in
                    VocabularyItem.Example(
                        japanese: example.japanese,
                        reading: example.reading,
                        meaning: example.meaning
                    )
                }
                
                let vocabularyItem = VocabularyItem(
                    id: UUID(),
                    japanese: item.japanese,
                    reading: item.reading,
                    meaning: item.meaning,
                    partOfSpeech: item.partOfSpeech,
                    examples: examples,
                    category: .n5,  // 根据实际类别设置
                    lastReviewed: nil,
                    nextReviewDate: nil,
                    masteryLevel: 0,
                    reviewCount: 0,
                    audioURL: nil,
                    isDownloaded: false,
                    syncStatus: .synced
                )
                
                vocabularyItems.append(vocabularyItem)
            }
        }
        
        print("准备导入 \(vocabularyItems.count) 个词汇")
        
        // 批量导入到 SQLite
        try sqliteManager.batchImportVocabulary(vocabularyItems)
        print("成功导入所有词汇")
        
        // 更新导入版本
        defaults.set(currentVersion, forKey: "ImportedVocabularyVersion")
        print("已更新导入版本为: \(currentVersion)")
    }
    
    // 添加重置方法
    func resetImportStatus() {
        UserDefaults.standard.removeObject(forKey: "ImportedVocabularyVersion")
        print("已重置导入状态")
    }
    
    enum ImportError: Error {
        case fileNotFound
        case decodingError
        case importError
    }
} 