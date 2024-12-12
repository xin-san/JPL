import Foundation
import SQLite3

class VocabularySQLiteManager {
    static let shared = VocabularySQLiteManager()
    private var db: OpaquePointer?
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("vocabulary.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        createTables()
    }
    
    private func createTables() {
        // 创建词汇表
        let createTableSQL = """
            CREATE TABLE IF NOT EXISTS vocabulary (
                id TEXT PRIMARY KEY,
                japanese TEXT NOT NULL,
                reading TEXT NOT NULL,
                meaning TEXT NOT NULL,
                part_of_speech TEXT NOT NULL,
                category TEXT NOT NULL,
                last_reviewed INTEGER,
                next_review_date INTEGER,
                mastery_level INTEGER NOT NULL DEFAULT 0,
                review_count INTEGER NOT NULL DEFAULT 0,
                audio_url TEXT,
                is_downloaded INTEGER NOT NULL DEFAULT 0,
                sync_status TEXT NOT NULL DEFAULT 'needsUpload'
            );
            
            CREATE TABLE IF NOT EXISTS examples (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                vocabulary_id TEXT NOT NULL,
                japanese TEXT NOT NULL,
                reading TEXT NOT NULL,
                meaning TEXT NOT NULL,
                FOREIGN KEY(vocabulary_id) REFERENCES vocabulary(id)
            );
            """
        
        var errMsg: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, createTableSQL, nil, nil, &errMsg) != SQLITE_OK {
            let msg = String(cString: errMsg!)
            print("Error creating tables: \(msg)")
            sqlite3_free(errMsg)
        }
    }
    
    // MARK: - CRUD Operations
    
    func saveVocabularyItem(_ item: VocabularyItem) throws {
        let insertSQL = """
            INSERT OR REPLACE INTO vocabulary (
                id, japanese, reading, meaning, part_of_speech, category,
                last_reviewed, next_review_date, mastery_level, review_count,
                audio_url, is_downloaded, sync_status
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
            """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (item.id.uuidString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (item.japanese as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (item.reading as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (item.meaning as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (item.partOfSpeech as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (item.category.rawValue as NSString).utf8String, -1, nil)
            
            if let lastReviewed = item.lastReviewed {
                sqlite3_bind_int64(statement, 7, Int64(lastReviewed.timeIntervalSince1970))
            } else {
                sqlite3_bind_null(statement, 7)
            }
            
            if let nextReviewDate = item.nextReviewDate {
                sqlite3_bind_int64(statement, 8, Int64(nextReviewDate.timeIntervalSince1970))
            } else {
                sqlite3_bind_null(statement, 8)
            }
            
            sqlite3_bind_int(statement, 9, Int32(item.masteryLevel))
            sqlite3_bind_int(statement, 10, Int32(item.reviewCount))
            
            if let audioURL = item.audioURL {
                sqlite3_bind_text(statement, 11, (audioURL as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 11)
            }
            
            sqlite3_bind_int(statement, 12, item.isDownloaded ? 1 : 0)
            sqlite3_bind_text(statement, 13, (item.syncStatus.rawValue as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                throw SQLiteError.insertError
            }
        }
        
        sqlite3_finalize(statement)
        
        // 保存例句
        try saveExamples(for: item)
    }
    
    private func saveExamples(for item: VocabularyItem) throws {
        let deleteSQL = "DELETE FROM examples WHERE vocabulary_id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (item.id.uuidString as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) != SQLITE_DONE {
                throw SQLiteError.deleteError
            }
        }
        sqlite3_finalize(statement)
        
        let insertSQL = """
            INSERT INTO examples (vocabulary_id, japanese, reading, meaning)
            VALUES (?, ?, ?, ?);
            """
        
        for example in item.examples {
            if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, (item.id.uuidString as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (example.japanese as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (example.reading as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 4, (example.meaning as NSString).utf8String, -1, nil)
                
                if sqlite3_step(statement) != SQLITE_DONE {
                    throw SQLiteError.insertError
                }
            }
            sqlite3_finalize(statement)
        }
    }
    
    func fetchVocabularyItems() throws -> [VocabularyItem] {
        var items: [VocabularyItem] = []
        let querySQL = "SELECT * FROM vocabulary;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, querySQL, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let item = try extractVocabularyItem(from: statement)
                items.append(item)
            }
        }
        
        sqlite3_finalize(statement)
        
        // 获取每个词汇的例句
        for i in 0..<items.count {
            items[i].examples = try fetchExamples(for: items[i].id)
        }
        
        return items
    }
    
    private func extractVocabularyItem(from statement: OpaquePointer?) throws -> VocabularyItem {
        guard let idString = sqlite3_column_text(statement, 0) else {
            throw SQLiteError.readError
        }
        
        let id = UUID(uuidString: String(cString: idString))!
        let japanese = String(cString: sqlite3_column_text(statement, 1))
        let reading = String(cString: sqlite3_column_text(statement, 2))
        let meaning = String(cString: sqlite3_column_text(statement, 3))
        let partOfSpeech = String(cString: sqlite3_column_text(statement, 4))
        let categoryString = String(cString: sqlite3_column_text(statement, 5))
        
        let lastReviewed: Date? = {
            let timestamp = sqlite3_column_int64(statement, 6)
            return timestamp == 0 ? nil : Date(timeIntervalSince1970: TimeInterval(timestamp))
        }()
        
        let nextReviewDate: Date? = {
            let timestamp = sqlite3_column_int64(statement, 7)
            return timestamp == 0 ? nil : Date(timeIntervalSince1970: TimeInterval(timestamp))
        }()
        
        let masteryLevel = Int(sqlite3_column_int(statement, 8))
        let reviewCount = Int(sqlite3_column_int(statement, 9))
        
        let audioURL: String? = {
            guard let text = sqlite3_column_text(statement, 10) else { return nil }
            return String(cString: text)
        }()
        
        let isDownloaded = sqlite3_column_int(statement, 11) != 0
        let syncStatus = VocabularyItem.SyncStatus(rawValue: String(cString: sqlite3_column_text(statement, 12)))!
        
        return VocabularyItem(
            id: id,
            japanese: japanese,
            reading: reading,
            meaning: meaning,
            partOfSpeech: partOfSpeech,
            examples: [], // 稍后填充
            category: VocabularyItem.Category(rawValue: categoryString)!,
            lastReviewed: lastReviewed,
            nextReviewDate: nextReviewDate,
            masteryLevel: masteryLevel,
            reviewCount: reviewCount,
            audioURL: audioURL,
            isDownloaded: isDownloaded,
            syncStatus: syncStatus
        )
    }
    
    private func fetchExamples(for vocabularyId: UUID) throws -> [VocabularyItem.Example] {
        var examples: [VocabularyItem.Example] = []
        let querySQL = "SELECT japanese, reading, meaning FROM examples WHERE vocabulary_id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, querySQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (vocabularyId.uuidString as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let japanese = String(cString: sqlite3_column_text(statement, 0))
                let reading = String(cString: sqlite3_column_text(statement, 1))
                let meaning = String(cString: sqlite3_column_text(statement, 2))
                
                examples.append(VocabularyItem.Example(
                    japanese: japanese,
                    reading: reading,
                    meaning: meaning
                ))
            }
        }
        
        sqlite3_finalize(statement)
        return examples
    }
    
    func deleteVocabularyItem(_ id: UUID) throws {
        let deleteSQL = "DELETE FROM vocabulary WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (id.uuidString as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) != SQLITE_DONE {
                throw SQLiteError.deleteError
            }
        }
        
        sqlite3_finalize(statement)
        
        // 删除相关例句
        let deleteExamplesSQL = "DELETE FROM examples WHERE vocabulary_id = ?;"
        if sqlite3_prepare_v2(db, deleteExamplesSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (id.uuidString as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) != SQLITE_DONE {
                throw SQLiteError.deleteError
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    // MARK: - Batch Import
    func batchImportVocabulary(_ items: [VocabularyItem]) throws {
        // 开始事务
        if sqlite3_exec(db, "BEGIN TRANSACTION", nil, nil, nil) != SQLITE_OK {
            throw SQLiteError.transactionError
        }
        
        do {
            for item in items {
                try saveVocabularyItem(item)
            }
            
            // 提交事务
            if sqlite3_exec(db, "COMMIT", nil, nil, nil) != SQLITE_OK {
                throw SQLiteError.transactionError
            }
        } catch {
            // 如果出错，回滚事务
            sqlite3_exec(db, "ROLLBACK", nil, nil, nil)
            throw error
        }
    }
    
    // MARK: - Clear Data
    func clearAllVocabulary() throws {
        let deleteSQL = """
            DELETE FROM vocabulary;
            DELETE FROM examples;
            """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                throw SQLiteError.deleteError
            }
        }
        
        sqlite3_finalize(statement)
    }
}

enum SQLiteError: Error {
    case insertError
    case deleteError
    case readError
    case updateError
    case transactionError
    case prepareError
} 