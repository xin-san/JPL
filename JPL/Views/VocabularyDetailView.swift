import SwiftUI

struct VocabularyDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: VocabularyViewModel
    let item: VocabularyItem
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    Text("日语: \(item.japanese)")
                    Text("读音: \(item.reading)")
                    Text("含义: \(item.meaning)")
                    Text("词性: \(item.partOfSpeech)")
                    Text("分类: \(item.category.rawValue)")
                }
                
                Section(header: Text("学习进度")) {
                    Text("掌握度: \(item.masteryLevel)/5")
                    Text("复习次数: \(item.reviewCount)")
                    if let lastReviewed = item.lastReviewed {
                        Text("上次复习: \(lastReviewed.formatted())")
                    }
                    if let nextReview = item.nextReviewDate {
                        Text("下次复习: \(nextReview.formatted())")
                    }
                }
                
                Section {
                    Button("正确") {
                        viewModel.updateVocabularyProgress(item, correct: true)
                        dismiss()
                    }
                    .foregroundColor(.green)
                    
                    Button("错误") {
                        viewModel.updateVocabularyProgress(item, correct: false)
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                Section {
                    Button("删除") {
                        viewModel.deleteVocabulary(item)
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("词汇详情")
            .navigationBarItems(trailing: Button("完成") { dismiss() })
        }
    }
} 