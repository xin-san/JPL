import SwiftUI

struct AddVocabularyView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: VocabularyViewModel
    
    @State private var japanese = ""
    @State private var reading = ""
    @State private var meaning = ""
    @State private var partOfSpeech = ""
    @State private var category: VocabularyItem.Category = .basic
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("日语", text: $japanese)
                    TextField("读音", text: $reading)
                    TextField("含义", text: $meaning)
                    TextField("词性", text: $partOfSpeech)
                    Picker("分类", selection: $category) {
                        ForEach(VocabularyItem.Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
            }
            .navigationTitle("添加词汇")
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("保存") {
                    let newItem = VocabularyItem(
                        id: UUID(),
                        japanese: japanese,
                        reading: reading,
                        meaning: meaning,
                        partOfSpeech: partOfSpeech,
                        examples: [],
                        category: category,
                        lastReviewed: nil,
                        nextReviewDate: nil,
                        masteryLevel: 0,
                        reviewCount: 0,
                        audioURL: nil
                    )
                    viewModel.addVocabulary(newItem)
                    dismiss()
                }
            )
        }
    }
} 