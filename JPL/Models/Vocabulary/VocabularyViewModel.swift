import Foundation
import Combine
import CoreData

class VocabularyViewModel: ObservableObject {
    @Published var vocabularyItems: [VocabularyItem] = []
    @Published var selectedCategory: VocabularyItem.Category?
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .lastReviewed
    @Published var filterOption: FilterOption = .all
    
    private var cancellables = Set<AnyCancellable>()
    private let coreDataManager = CoreDataManager.shared
    
    enum SortOption {
        case alphabetical
        case lastReviewed
        case masteryLevel
        case nextReview
    }
    
    enum FilterOption {
        case all
        case needsReview
        case mastered
        case struggling
    }
    
    init() {
        setupBindings()
        fetchVocabulary()
    }
    
    private func setupBindings() {
        // 监听搜索文本变化
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    // 获取词汇列表
    func fetchVocabulary() {
        vocabularyItems = coreDataManager.fetchVocabulary()
    }
    
    // 添加新词汇
    func addVocabulary(_ item: VocabularyItem) {
        coreDataManager.createVocabulary(item)
        fetchVocabulary()
    }
    
    // 更新词汇
    func updateVocabulary(_ item: VocabularyItem) {
        coreDataManager.updateVocabulary(item)
        fetchVocabulary()
    }
    
    // 删除词汇
    func deleteVocabulary(_ item: VocabularyItem) {
        coreDataManager.deleteVocabulary(item)
        fetchVocabulary()
    }
    
    // 获取需要复习的词汇
    func getReviewItems() -> [VocabularyItem] {
        let now = Date()
        return vocabularyItems.filter { item in
            guard let nextReview = item.nextReviewDate else { return false }
            return nextReview <= now
        }
    }
    
    // 筛选和排序词汇
    func filteredVocabulary() -> [VocabularyItem] {
        var filtered = vocabularyItems
        
        // 应用分类筛选
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // 应用搜索筛选
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.japanese.contains(searchText) ||
                $0.reading.contains(searchText) ||
                $0.meaning.contains(searchText)
            }
        }
        
        // 应用状态筛选
        switch filterOption {
        case .needsReview:
            filtered = filtered.filter { item in
                guard let nextReview = item.nextReviewDate else { return false }
                return nextReview <= Date()
            }
        case .mastered:
            filtered = filtered.filter { $0.masteryLevel >= 4 }
        case .struggling:
            filtered = filtered.filter { $0.masteryLevel <= 2 }
        case .all:
            break
        }
        
        // 应用排序
        switch sortOption {
        case .alphabetical:
            filtered.sort { $0.reading < $1.reading }
        case .lastReviewed:
            filtered.sort { ($0.lastReviewed ?? .distantPast) > ($1.lastReviewed ?? .distantPast) }
        case .masteryLevel:
            filtered.sort { $0.masteryLevel > $1.masteryLevel }
        case .nextReview:
            filtered.sort { ($0.nextReviewDate ?? .distantFuture) < ($1.nextReviewDate ?? .distantFuture) }
        }
        
        return filtered
    }
    
    // 更新词汇掌握度
    func updateVocabularyMastery(_ item: VocabularyItem, correct: Bool) {
        var updatedItem = item
        updatedItem.updateMastery(correct: correct)
        updateVocabulary(updatedItem)
    }
}