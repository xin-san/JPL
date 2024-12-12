import SwiftUI

struct VocabularyReviewView: View {
    @ObservedObject var viewModel: VocabularyViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showAnswer = false
    @State private var currentIndex = 0
    @State private var reviewComplete = false
    
    var body: some View {
        NavigationView {
            Group {
                if reviewComplete {
                    reviewCompletedView
                } else if !viewModel.todayReviewItems.isEmpty {
                    if currentIndex < viewModel.todayReviewItems.count {
                        reviewCardView(item: viewModel.todayReviewItems[currentIndex])
                    } else {
                        reviewCompletedView
                    }
                } else {
                    noWordsToReviewView
                }
            }
            .navigationTitle("单词复习")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func reviewCardView(item: VocabularyItem) -> some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 单词卡片
            VStack(spacing: 15) {
                Text(item.japanese)
                    .font(.system(size: 32, weight: .bold))
                
                if showAnswer {
                    Text(item.reading)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text(item.meaning)
                        .font(.title3)
                        .padding(.top, 5)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
            
            Spacer()
            
            if !showAnswer {
                // 显示答案按钮
                Button(action: { showAnswer = true }) {
                    Text("显示答案")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            } else {
                // 评价按钮
                HStack(spacing: 20) {
                    ratingButton("需要加强", isCorrect: false)
                    ratingButton("记住了", isCorrect: true)
                }
            }
        }
        .padding()
    }
    
    private func ratingButton(_ title: String, isCorrect: Bool) -> some View {
        Button(action: {
            rateCurrentItem(isCorrect)
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isCorrect ? Color.green : Color.red)
                .cornerRadius(10)
        }
    }
    
    private var reviewCompletedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("今日复习完成！")
                .font(.title)
            
            Text("继续保持，明天再来复习吧")
                .foregroundColor(.secondary)
            
            Button("返回") {
                dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private var noWordsToReviewView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("暂无需要复习的单词")
                .font(.title)
            
            Text("当前没有需要复习的单词")
                .foregroundColor(.secondary)
            
            Button("返回") {
                dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func rateCurrentItem(_ isCorrect: Bool) {
        guard currentIndex < viewModel.todayReviewItems.count else { return }
        let item = viewModel.todayReviewItems[currentIndex]
        viewModel.updateVocabularyProgress(item, correct: isCorrect)
        
        // 移动到下一个单词
        currentIndex += 1
        showAnswer = false
        
        // 检查是否完成所有复习
        if currentIndex >= viewModel.todayReviewItems.count {
            reviewComplete = true
        }
    }
} 