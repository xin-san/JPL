import SwiftUI

struct VocabularyView: View {
    @StateObject private var viewModel = VocabularyViewModel()
    @State private var showingAddSheet = false
    @State private var selectedItem: VocabularyItem?
    @State private var searchText = ""
    @State private var selectedCategory: VocabularyItem.Category?
    @State private var showingReviewSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                // 搜索和筛选栏
                VStack {
                    SearchBar(text: $searchText)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            FilterButton(title: "全部",
                                       isSelected: selectedCategory == nil) {
                                selectedCategory = nil
                            }
                            
                            ForEach(VocabularyItem.Category.allCases, id: \.self) { category in
                                FilterButton(title: category.rawValue,
                                           isSelected: selectedCategory == category) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color(.systemBackground))
                .shadow(radius: 1)
                
                // 词汇列表
                List {
                    ForEach(filteredVocabulary) { item in
                        VocabularyItemRow(item: item)
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                }
            }
            .navigationTitle("词汇")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingReviewSheet = true }) {
                        Image(systemName: "book.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddVocabularyView(viewModel: viewModel)
            }
            .sheet(item: $selectedItem) { item in
                VocabularyDetailView(viewModel: viewModel, item: item)
            }
            .sheet(isPresented: $showingReviewSheet) {
                VocabularyReviewView(viewModel: viewModel)
            }
        }
    }
    
    private var filteredVocabulary: [VocabularyItem] {
        viewModel.vocabularyItems.filter { item in
            let categoryMatch = selectedCategory == nil || item.category == selectedCategory
            let searchMatch = searchText.isEmpty ||
                item.japanese.localizedCaseInsensitiveContains(searchText) ||
                item.reading.localizedCaseInsensitiveContains(searchText) ||
                item.meaning.localizedCaseInsensitiveContains(searchText)
            return categoryMatch && searchMatch
        }
    }
}

// MARK: - 辅助视图

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("搜索词汇", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}