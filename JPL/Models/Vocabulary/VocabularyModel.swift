import Foundation

struct VocabularyItem: Identifiable, Codable {
    let id: UUID
    var japanese: String
    var reading: String
    var meaning: String
    var partOfSpeech: String
    var examples: [Example]
    var category: Category
    var lastReviewed: Date?
    var nextReviewDate: Date?
    var masteryLevel: Int
    var reviewCount: Int
    var audioURL: String?
    var isDownloaded: Bool
    var syncStatus: SyncStatus
    
    struct Example: Codable {
        var japanese: String
        var reading: String
        var meaning: String
    }
    
    enum Category: String, Codable, CaseIterable {
        case basic = "基础词汇"
        case n5 = "N5"
        case n4 = "N4"
        case n3 = "N3"
        case n2 = "N2"
        case n1 = "N1"
        case daily = "日常用语"
        case business = "商务用语"
    }
    
    enum SyncStatus: String, Codable {
        case synced
        case needsUpload
        case needsDownload
        case conflict
    }
    
    init(id: UUID = UUID(),
         japanese: String,
         reading: String,
         meaning: String,
         partOfSpeech: String,
         examples: [Example] = [],
         category: Category,
         lastReviewed: Date? = nil,
         nextReviewDate: Date? = nil,
         masteryLevel: Int = 0,
         reviewCount: Int = 0,
         audioURL: String? = nil,
         isDownloaded: Bool = false,
         syncStatus: SyncStatus = .needsUpload) {
        self.id = id
        self.japanese = japanese
        self.reading = reading
        self.meaning = meaning
        self.partOfSpeech = partOfSpeech
        self.examples = examples
        self.category = category
        self.lastReviewed = lastReviewed
        self.nextReviewDate = nextReviewDate
        self.masteryLevel = masteryLevel
        self.reviewCount = reviewCount
        self.audioURL = audioURL
        self.isDownloaded = isDownloaded
        self.syncStatus = syncStatus
    }
}

// MARK: - API Models
struct APIVocabularyResponse: Codable {
    let items: [VocabularyItem]
    let totalCount: Int
    let page: Int
    let pageSize: Int
}

struct APIVocabularyRequest: Codable {
    let item: VocabularyItem
    let userId: String
    let timestamp: Date
}

// MARK: - Sample Data
extension VocabularyItem {
    static let sampleData: [VocabularyItem] = [
        VocabularyItem(
            japanese: "こんにちは",
            reading: "konnichiwa",
            meaning: "你好",
            partOfSpeech: "感叹词",
            examples: [
                Example(
                    japanese: "こんにちは、山田さん。",
                    reading: "konnichiwa, yamada san.",
                    meaning: "你好，山田先生。"
                )
            ],
            category: .basic,
            masteryLevel: 0
        ),
        VocabularyItem(
            japanese: "ありがとう",
            reading: "arigatou",
            meaning: "谢谢",
            partOfSpeech: "感叹词",
            examples: [
                Example(
                    japanese: "どうもありがとう。",
                    reading: "doumo arigatou.",
                    meaning: "非常感谢。"
                )
            ],
            category: .basic,
            masteryLevel: 0
        ),
        VocabularyItem(
            japanese: "さようなら",
            reading: "sayounara",
            meaning: "再见",
            partOfSpeech: "感叹词",
            examples: [
                Example(
                    japanese: "さようなら、また会いましょう。",
                    reading: "sayounara, mata aimashou.",
                    meaning: "再见，我们再见面吧。"
                )
            ],
            category: .basic,
            masteryLevel: 0
        ),
        VocabularyItem(
            japanese: "おはよう",
            reading: "ohayou",
            meaning: "早上好",
            partOfSpeech: "感叹词",
            examples: [
                Example(
                    japanese: "おはようございます。",
                    reading: "ohayou gozaimasu.",
                    meaning: "早上好（礼貌语）。"
                )
            ],
            category: .basic,
            masteryLevel: 0
        ),
        VocabularyItem(
            japanese: "勉強",
            reading: "benkyou",
            meaning: "学习",
            partOfSpeech: "名词/动词",
            examples: [
                Example(
                    japanese: "日本語を勉強しています。",
                    reading: "nihongo wo benkyou shiteimasu.",
                    meaning: "我在学习日语。"
                )
            ],
            category: .n5,
            masteryLevel: 0
        )
    ]
}