import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "JPL")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data 加载失败: \(error.localizedDescription)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Vocabulary CRUD Operations
    
    func createVocabulary(_ item: VocabularyItem) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "VocabularyEntity", into: context) as! VocabularyEntity
        updateVocabularyEntity(entity, with: item)
        saveContext()
    }
    
    func updateVocabulary(_ item: VocabularyItem) {
        let fetchRequest: NSFetchRequest<VocabularyEntity> = VocabularyEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            if let entity = try context.fetch(fetchRequest).first {
                updateVocabularyEntity(entity, with: item)
                saveContext()
            }
        } catch {
            print("更新词汇失败: \(error.localizedDescription)")
        }
    }
    
    func deleteVocabulary(_ item: VocabularyItem) {
        let fetchRequest: NSFetchRequest<VocabularyEntity> = VocabularyEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            if let entity = try context.fetch(fetchRequest).first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            print("删除词汇失败: \(error.localizedDescription)")
        }
    }
    
    func fetchVocabulary() -> [VocabularyItem] {
        let fetchRequest: NSFetchRequest<VocabularyEntity> = VocabularyEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.filter { $0.id != nil }.map { entity in
                VocabularyItem(
                    id: entity.id!,
                    japanese: entity.japanese ?? "",
                    reading: entity.reading ?? "",
                    meaning: entity.meaning ?? "",
                    partOfSpeech: entity.partOfSpeech ?? "",
                    examples: convertToExamples(from: entity.examples),
                    category: VocabularyItem.Category(rawValue: entity.category ?? "") ?? .basic,
                    lastReviewed: entity.lastReviewed,
                    nextReviewDate: entity.nextReviewDate,
                    masteryLevel: Int(entity.masteryLevel),
                    reviewCount: Int(entity.reviewCount),
                    audioURL: entity.audioURL
                )
            }
        } catch {
            print("获取词汇失败: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateVocabularyEntity(_ entity: VocabularyEntity, with item: VocabularyItem) {
        entity.id = item.id
        entity.japanese = item.japanese
        entity.reading = item.reading
        entity.meaning = item.meaning
        entity.partOfSpeech = item.partOfSpeech
        entity.category = item.category.rawValue
        entity.lastReviewed = item.lastReviewed
        entity.nextReviewDate = item.nextReviewDate
        entity.masteryLevel = Int16(item.masteryLevel)
        entity.reviewCount = Int16(item.reviewCount)
        entity.audioURL = item.audioURL
        
        // 删除旧的例句
        if let existingExamples = entity.examples {
            existingExamples.forEach { example in
                if let example = example as? NSManagedObject {
                    context.delete(example)
                }
            }
        }
        
        // 添加新的例句
        let examples = NSMutableSet()
        for example in item.examples {
            let exampleEntity = NSEntityDescription.insertNewObject(forEntityName: "VocabularyExampleEntity", into: context) as! VocabularyExampleEntity
            exampleEntity.japanese = example.japanese
            exampleEntity.reading = example.reading
            exampleEntity.meaning = example.meaning
            exampleEntity.vocabulary = entity
            examples.add(exampleEntity)
        }
        entity.examples = examples
    }
    
    private func convertToExamples(from examples: NSSet?) -> [VocabularyItem.Example] {
        guard let examples = examples else { return [] }
        
        return examples.compactMap { example in
            guard let example = example as? VocabularyExampleEntity else { return nil }
            return VocabularyItem.Example(
                japanese: example.japanese ?? "",
                reading: example.reading ?? "",
                meaning: example.meaning ?? ""
            )
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("保存 Core Data 失败: \(error.localizedDescription)")
            }
        }
    }
} 