import SwiftUI

struct VocabularyItemRow: View {
    let item: VocabularyItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(item.japanese)
                    .font(.headline)
                Spacer()
                ProgressView(value: Double(item.masteryLevel), total: 5.0)
                    .frame(width: 60)
            }
            
            Text(item.reading)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(item.meaning)
                .font(.body)
            
            HStack {
                Text(item.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
                
                if let nextReview = item.nextReviewDate, nextReview <= Date() {
                    Text("需要复习")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .foregroundColor(.orange)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 4)
    }
} 