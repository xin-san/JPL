import Foundation
import Combine
import SwiftUI

@MainActor
class VocabularyViewModel: ObservableObject {
    @Published var vocabularyItems: [VocabularyItem] = []
    @Published var filteredItems: [VocabularyItem] = []
    @Published var todayReviewItems: [VocabularyItem] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let sqliteManager = VocabularySQLiteManager.shared
    
    @Published var searchText = "" {
        didSet {
            filterItems()
        }
    }
    
    @Published var selectedCategory: VocabularyItem.Category? {
        didSet {
            filterItems()
        }
    }
    
    init() {
        Task {
            await loadVocabularyItems()
        }
    }
    
    func loadVocabularyItems() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            vocabularyItems = try sqliteManager.fetchVocabularyItems()
            filterItems()
            updateTodayReviewItems()
        } catch {
            errorMessage = "加载词汇失败: \(error.localizedDescription)"
        }
    }
    
    private func filterItems() {
        var filtered = vocabularyItems
        
        // 应用分类筛选
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // 应用搜索筛选
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.japanese.localizedCaseInsensitiveContains(searchText) ||
                $0.reading.localizedCaseInsensitiveContains(searchText) ||
                $0.meaning.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredItems = filtered
    }
    
    private func updateTodayReviewItems() {
        todayReviewItems = getItemsDueForReview()
    }
    
    private func getItemsDueForReview() -> [VocabularyItem] {
        let now = Date()
        return vocabularyItems.filter { item in
            if let nextReview = item.nextReviewDate {
                return nextReview <= now
            }
            return false
        }
    }
    
    func addVocabulary(_ item: VocabularyItem) {
        do {
            try sqliteManager.saveVocabularyItem(item)
            vocabularyItems.append(item)
            filterItems()
            updateTodayReviewItems()
        } catch {
            errorMessage = "添加词汇失败: \(error.localizedDescription)"
        }
    }
    
    func updateVocabularyProgress(_ item: VocabularyItem, correct: Bool) {
        var updatedItem = item
        
        // 更新复习次数
        updatedItem.reviewCount += 1
        
        // 更新掌握度
        if correct {
            updatedItem.masteryLevel = min(5, updatedItem.masteryLevel + 1)
        } else {
            updatedItem.masteryLevel = max(0, updatedItem.masteryLevel - 1)
        }
        
        // 更新复习时间
        updatedItem.lastReviewed = Date()
        
        // 计算下次复习时间
        let interval: TimeInterval
        switch updatedItem.masteryLevel {
        case 0: interval = 1 * 24 * 3600  // 1天
        case 1: interval = 2 * 24 * 3600  // 2天
        case 2: interval = 4 * 24 * 3600  // 4天
        case 3: interval = 7 * 24 * 3600  // 1周
        case 4: interval = 14 * 24 * 3600 // 2周
        case 5: interval = 30 * 24 * 3600 // 1月
        default: interval = 1 * 24 * 3600
        }
        updatedItem.nextReviewDate = Date().addingTimeInterval(interval)
        
        do {
            try sqliteManager.saveVocabularyItem(updatedItem)
            if let index = vocabularyItems.firstIndex(where: { $0.id == updatedItem.id }) {
                vocabularyItems[index] = updatedItem
                filterItems()
                updateTodayReviewItems()
            }
        } catch {
            errorMessage = "更新词汇失败: \(error.localizedDescription)"
        }
    }
    
    func deleteVocabulary(_ item: VocabularyItem) {
        do {
            try sqliteManager.deleteVocabularyItem(item.id)
            vocabularyItems.removeAll { $0.id == item.id }
            filterItems()
            updateTodayReviewItems()
        } catch {
            errorMessage = "删除词汇失败: \(error.localizedDescription)"
        }
    }
}