import SwiftUI

struct CoreDataTestView: View {
    @StateObject private var viewModel = VocabularyViewModel()
    @State private var testWord = ""
    @State private var testReading = ""
    @State private var testMeaning = ""
    @State private var testMessage = ""
    @State private var showingMessage = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("快速添加测试")) {
                    TextField("日语单词", text: $testWord)
                    TextField("读音", text: $testReading)
                    TextField("含义", text: $testMeaning)
                    
                    Button("添加测试词汇") {
                        addTestVocabulary()
                    }
                    .disabled(testWord.isEmpty || testReading.isEmpty || testMeaning.isEmpty)
                }
                
                Section(header: Text("测试功能")) {
                    Button("添加示例数据") {
                        addSampleData()
                    }
                    
                    Button("更新第一个词汇的掌握度") {
                        updateFirstVocabularyMastery()
                    }
                    
                    Button("删除最后一个词汇") {
                        deleteLastVocabulary()
                    }
                    
                    Button("删除所有数据") {
                        deleteAllData()
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("当前数据 (\(viewModel.vocabularyItems.count)个词汇)")) {
                    ForEach(viewModel.vocabularyItems) { item in
                        VStack(alignment: .leading) {
                            Text(item.japanese)
                                .font(.headline)
                            Text(item.reading)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(item.meaning)
                                .font(.body)
                            HStack {
                                Text("掌握度: \(item.masteryLevel)/5")
                                Spacer()
                                Text("复习次数: \(item.reviewCount)")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("CoreData 测试")
            .alert("提示", isPresented: $showingMessage) {
                Button("确定", role: .cancel) {}
            } message: {
                Text(testMessage)
            }
            .onAppear {
                viewModel.fetchVocabulary()
            }
        }
    }
    
    private func addTestVocabulary() {
        let newItem = VocabularyItem(
            id: UUID(),
            japanese: testWord,
            reading: testReading,
            meaning: testMeaning,
            partOfSpeech: "未知",
            examples: [],
            category: .basic,
            lastReviewed: nil,
            nextReviewDate: nil,
            masteryLevel: 0,
            reviewCount: 0,
            audioURL: nil
        )
        
        viewModel.addVocabulary(newItem)
        
        // 清空输入
        testWord = ""
        testReading = ""
        testMeaning = ""
        
        showMessage("添加成功！")
    }
    
    private func addSampleData() {
        let sampleData = [
            ("こんにちは", "konnichiwa", "你好"),
            ("ありがとう", "arigatou", "谢谢"),
            ("さようなら", "sayounara", "再见"),
            ("おはよう", "ohayou", "早上好"),
            ("こんばんは", "konbanwa", "晚上好")
        ]
        
        for (japanese, reading, meaning) in sampleData {
            let item = VocabularyItem(
                id: UUID(),
                japanese: japanese,
                reading: reading,
                meaning: meaning,
                partOfSpeech: "感叹词",
                examples: [],
                category: .basic,
                lastReviewed: nil,
                nextReviewDate: nil,
                masteryLevel: 0,
                reviewCount: 0,
                audioURL: nil
            )
            viewModel.addVocabulary(item)
        }
        
        showMessage("已添加5个示例词汇！")
    }
    
    private func updateFirstVocabularyMastery() {
        guard let firstItem = viewModel.vocabularyItems.first else {
            showMessage("没有可更新的词汇！")
            return
        }
        
        viewModel.updateVocabularyMastery(firstItem, correct: true)
        showMessage("已更新第一个词汇的掌握度！")
    }
    
    private func deleteLastVocabulary() {
        guard let lastItem = viewModel.vocabularyItems.last else {
            showMessage("没有可删除的词汇！")
            return
        }
        
        viewModel.deleteVocabulary(lastItem)
        showMessage("已删除最后一个词汇！")
    }
    
    private func deleteAllData() {
        CoreDataManager.shared.deleteAllVocabulary()
        viewModel.fetchVocabulary()
        showMessage("已删除所有数据！")
    }
    
    private func showMessage(_ message: String) {
        testMessage = message
        showingMessage = true
    }
}

struct CoreDataTestView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataTestView()
    }
} 