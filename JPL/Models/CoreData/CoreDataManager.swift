import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer {
        PersistenceController.shared.container
    }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print("未保存的 Core Data 更改: \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Vocabulary CRUD Operations
    
    func createVocabulary(_ item: VocabularyItem) {
        let context = viewContext
        
        // 检查实体描述是否存在
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "VocabularyEntity", in: context) else {
            print("Error: Could not find entity description for VocabularyEntity")
            return
        }
        
        // 使用实体描述创建实体
        let entity = VocabularyEntity(entity: entityDescription, insertInto: context)
        
        do {
            updateVocabularyEntity(entity, with: item)
            try context.save()
            print("Successfully created vocabulary item")
        } catch {
            print("Error creating vocabulary: \(error)")
            context.rollback()
        }
    }
    
    func fetchVocabulary() -> [VocabularyItem] {
        let fetchRequest: NSFetchRequest<VocabularyEntity> = VocabularyEntity.fetchRequest()
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            return entities.map { convertToVocabularyItem($0) }
        } catch {
            print("获取词汇失败: \(error)")
            return []
        }
    }
    
    func updateVocabulary(_ item: VocabularyItem) {
        let fetchRequest: NSFetchRequest<VocabularyEntity> = VocabularyEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            if let entity = entities.first {
                updateVocabularyEntity(entity, with: item)
                try viewContext.save()
                print("Successfully updated vocabulary item")
            }
        } catch {
            print("更新词汇失败: \(error)")
            viewContext.rollback()
        }
    }
    
    func deleteVocabulary(_ item: VocabularyItem) {
        let fetchRequest: NSFetchRequest<VocabularyEntity> = VocabularyEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            if let entity = entities.first {
                viewContext.delete(entity)
                try viewContext.save()
                print("Successfully deleted vocabulary item")
            }
        } catch {
            print("删除词汇失败: \(error)")
            viewContext.rollback()
        }
    }
    
    func deleteAllVocabulary() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = VocabularyEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            print("Successfully deleted all vocabulary items")
        } catch {
            print("删除所有词汇失败: \(error)")
            viewContext.rollback()
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateVocabularyEntity(_ entity: VocabularyEntity, with item: VocabularyItem) {
        // 如果 id 为空，生成新的 UUID
        if entity.id == nil {
            entity.id = UUID()
        } else {
            entity.id = item.id
        }
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
            for case let example as VocabularyExampleEntity in existingExamples {
                viewContext.delete(example)
            }
        }
        
        // 添加新的例句
        for example in item.examples {
            guard let exampleEntityDescription = NSEntityDescription.entity(forEntityName: "VocabularyExampleEntity", in: viewContext) else {
                print("Error: Could not find entity description for VocabularyExampleEntity")
                continue
            }
            
            let exampleEntity = VocabularyExampleEntity(entity: exampleEntityDescription, insertInto: viewContext)
            exampleEntity.japanese = example.japanese
            exampleEntity.reading = example.reading
            exampleEntity.meaning = example.meaning
            exampleEntity.vocabulary = entity
        }
    }
    
    private func convertToVocabularyItem(_ entity: VocabularyEntity) -> VocabularyItem {
        let examples = (entity.examples?.allObjects as? [VocabularyExampleEntity])?.map {
            VocabularyItem.Example(
                japanese: $0.japanese ?? "",
                reading: $0.reading ?? "",
                meaning: $0.meaning ?? ""
            )
        } ?? []
        
        return VocabularyItem(
            id: entity.id ?? UUID(),
            japanese: entity.japanese ?? "",
            reading: entity.reading ?? "",
            meaning: entity.meaning ?? "",
            partOfSpeech: entity.partOfSpeech ?? "",
            examples: examples,
            category: VocabularyItem.Category(rawValue: entity.category ?? "") ?? .other,
            lastReviewed: entity.lastReviewed,
            nextReviewDate: entity.nextReviewDate,
            masteryLevel: Int(entity.masteryLevel),
            reviewCount: Int(entity.reviewCount),
            audioURL: entity.audioURL
        )
    }
} 