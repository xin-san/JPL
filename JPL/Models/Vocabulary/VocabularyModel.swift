import Foundation

struct VocabularyItem: Identifiable, Codable {
    let id: UUID
    var japanese: String          // 日语单词
    var reading: String          // 读音
    var meaning: String          // 中文含义
    var partOfSpeech: String    // 词性
    var examples: [Example]      // 例句
    var category: Category       // 词汇分类
    var lastReviewed: Date?     // 上次复习时间
    var nextReviewDate: Date?   // 下次复习时间
    var masteryLevel: Int       // 掌握程度 (0-5)
    var reviewCount: Int        // 复习次数
    var audioURL: String?       // 发音音频URL
    
    struct Example: Codable {
        var japanese: String    // 日语例句
        var reading: String     // 例句读音
        var meaning: String     // 中文翻译
    }
    
    enum Category: String, Codable, CaseIterable {
        case basic = "基础词汇"
        case daily = "日常用语"
        case business = "商务用语"
        case academic = "学术用语"
        case jlpt5 = "JLPT N5"
        case jlpt4 = "JLPT N4"
        case jlpt3 = "JLPT N3"
        case other = "其他"
    }
    
    // 计算下次复习时间
    mutating func calculateNextReview() {
        let intervals = [1, 3, 7, 14, 30, 90] // 间隔天数
        let interval = masteryLevel < intervals.count ? intervals[masteryLevel] : intervals.last!
        nextReviewDate = Date().addingTimeInterval(Double(interval * 24 * 60 * 60))
    }
    
    // 更新掌握度
    mutating func updateMastery(correct: Bool) {
        if correct {
            masteryLevel = min(masteryLevel + 1, 5)
        } else {
            masteryLevel = max(masteryLevel - 1, 0)
        }
        reviewCount += 1
        lastReviewed = Date()
        calculateNextReview()
    }
}