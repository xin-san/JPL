import SwiftUI
import AVFoundation

struct VocabularyView: View {
    @StateObject private var viewModel = VocabularyViewModel()
    @State private var showingAddSheet = false
    @State private var showingFilterSheet = false
    @State private var selectedItem: VocabularyItem?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部工具栏
                HStack {
                    Button(action: { showingFilterSheet = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Menu {
                        Picker("排序方式", selection: $viewModel.sortOption) {
                            Text("按字母").tag(VocabularyViewModel.SortOption.alphabetical)
                            Text("最近复习").tag(VocabularyViewModel.SortOption.lastReviewed)
                            Text("掌握程度").tag(VocabularyViewModel.SortOption.masteryLevel)
                            Text("复习时间").tag(VocabularyViewModel.SortOption.nextReview)
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                // 分类选择器
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(VocabularyItem.Category.allCases, id: \.self) { category in
                            CategoryButton(
                                title: category.rawValue,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                viewModel.selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // 搜索栏
                SearchBar(text: $viewModel.searchText)
                    .padding(.vertical, 8)
                
                // 词汇列表
                List {
                    ForEach(viewModel.filteredVocabulary()) { item in
                        VocabularyRow(item: item)
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let item = viewModel.filteredVocabulary()[index]
                            viewModel.deleteVocabulary(item)
                        }
                    }
                }
            }
            .navigationTitle("词汇学习")
            .navigationBarItems(
                trailing: Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddSheet) {
                AddVocabularyView(viewModel: viewModel)
            }
            .sheet(item: $selectedItem) { item in
                VocabularyDetailView(item: item, viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterView(filterOption: $viewModel.filterOption)
            }
        }
    }
}

// 分类按钮组件
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// 搜索栏组件
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("搜索词汇", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}

// 词汇列表行组件
struct VocabularyRow: View {
    let item: VocabularyItem
    @State private var isPlaying = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.japanese)
                        .font(.headline)
                    Text(item.reading)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                if item.audioURL != nil {
                    Button(action: playAudio) {
                        Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Text(item.meaning)
                .font(.body)
            
            HStack {
                Text(item.partOfSpeech)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
                
                // 掌握度指示器
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < item.masteryLevel ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func playAudio() {
        // TODO: 实现音频播放功能
        isPlaying.toggle()
    }
}

// 筛选视图
struct FilterView: View {
    @Binding var filterOption: VocabularyViewModel.FilterOption
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach([
                    (VocabularyViewModel.FilterOption.all, "全部词汇"),
                    (.needsReview, "需要复习"),
                    (.mastered, "已掌握"),
                    (.struggling, "需要加强")
                ], id: \.0) { option, title in
                    Button(action: {
                        filterOption = option
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(title)
                            Spacer()
                            if filterOption == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("筛选")
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// 添加词汇视图
struct AddVocabularyView: View {
    @ObservedObject var viewModel: VocabularyViewModel
    @Environment(\.presentationMode) var presentationMode
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
                }
                
                Section(header: Text("分类")) {
                    Picker("选择分类", selection: $category) {
                        ForEach(VocabularyItem.Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
            }
            .navigationTitle("添加词汇")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
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
                        masteryLevel: 0,
                        reviewCount: 0
                    )
                    viewModel.addVocabulary(newItem)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(japanese.isEmpty || reading.isEmpty || meaning.isEmpty)
            )
        }
    }
}

// 词汇详情视图
struct VocabularyDetailView: View {
    let item: VocabularyItem
    @ObservedObject var viewModel: VocabularyViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("基本信息")) {
                    DetailRow(title: "日语", content: item.japanese)
                    DetailRow(title: "读音", content: item.reading)
                    DetailRow(title: "含义", content: item.meaning)
                    DetailRow(title: "词性", content: item.partOfSpeech)
                }
                
                if !item.examples.isEmpty {
                    Section(header: Text("例句")) {
                        ForEach(item.examples, id: \.japanese) { example in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(example.japanese)
                                    .font(.body)
                                Text(example.reading)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(example.meaning)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Section(header: Text("学习状态")) {
                    DetailRow(title: "掌握程度", content: String(repeating: "⭐️", count: item.masteryLevel))
                    if let lastReviewed = item.lastReviewed {
                        DetailRow(title: "上次复习", content: lastReviewed.formatted())
                    }
                    DetailRow(title: "复习次数", content: "\(item.reviewCount)次")
                }
            }
            .navigationTitle("词汇详情")
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct DetailRow: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(content)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}