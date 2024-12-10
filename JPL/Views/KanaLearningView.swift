import SwiftUI
import Foundation

// 假名类型枚举
enum KanaType: String {
    case hiragana = "平假名"
    case katakana = "片假名"
}

// 假名字符模型
struct KanaCharacter: Identifiable {
    let id = UUID()
    let character: String
    let romaji: String
    let strokeCount: Int
    let type: KanaType
    var isLearned: Bool = false
    var lastReviewDate: Date?
    
    init(character: String, romaji: String, strokeCount: Int, type: KanaType) {
        self.character = character
        self.romaji = romaji
        self.strokeCount = strokeCount
        self.type = type
    }
}

struct KanaLearningView: View {
    @StateObject private var hiraganaManager = HiraganaDataManager()
    @StateObject private var katakanaManager = KatakanaDataManager()
    @State private var selectedType: KanaType = .hiragana
    @State private var selectedSection: KanaSection = .gojuon
    
    enum KanaSection: String, CaseIterable {
        case gojuon = "五十音"
        case dakuon = "浊音"
        case handakuon = "半浊音"
        case youon = "拗音"
        case special = "特殊假名"
        case gairaion = "外来语音"
    }
    
    // 获取当前假名类型的行标题
    var currentRowTitles: [String] {
        if selectedType == .hiragana {
            switch selectedSection {
            case .youon:
                return ["きゃ", "しゃ", "ちゃ", "にゃ", "ひゃ", "みゃ", "りゃ", "ぎゃ", "じゃ", "びゃ", "ぴゃ"]
            case .special:
                return ["っ", "ぁ", "ぃ", "ぅ", "ぇ", "ぉ", "ゃ", "ゅ", "ょ", "ゎ"]
            case .gairaion:
                return ["ゔ", "ゔぁ", "ゔぃ", "ゔぇ", "ゔぉ"]
            default:
                return ["あ", "か", "さ", "た", "な", "は", "ま", "や", "ら", "わ"]
            }
        } else {
            switch selectedSection {
            case .youon:
                return ["キャ", "シャ", "チャ", "ニャ", "ヒャ", "ミャ", "リャ", "ギャ", "ジャ", "ビャ", "ピャ"]
            case .special:
                return ["ッ", "ァ", "ィ", "ゥ", "ェ", "ォ", "ャ", "ュ", "ョ", "ヮ"]
            case .gairaion:
                let gairaionList = [
                    "ヴ", "ヴァ", "ヴィ", "ヴェ", "ヴォ",
                    "ファ", "フィ", "フェ", "フォ",
                    "ウィ", "ウェ", "ウォ",
                    "ツァ", "ツィ", "ツェ", "ツォ",
                    "ティ", "ディ", "トゥ", "ドゥ"
                ]
                return gairaionList
            default:
                return ["ア", "カ", "サ", "タ", "ナ", "ハ", "マ", "ヤ", "ラ", "ワ"]
            }
        }
    }
    
    let columnSounds = ["a", "i", "u", "e", "o"]
    let youonSounds = ["ya", "yu", "yo"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // 假名类型选择器
                Picker("假名类型", selection: $selectedType) {
                    Text("平假名").tag(KanaType.hiragana)
                    Text("片假名").tag(KanaType.katakana)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // 假名分类选择器
                Picker("假名分类", selection: $selectedSection) {
                    ForEach(KanaSection.allCases, id: \.self) { section in
                        Text(section.rawValue).tag(section)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 15) {
                        // 列标题
                        if selectedSection != .special && selectedSection != .gairaion {
                            HStack {
                                Text("　") // 空白占位
                                    .frame(width: 40)
                                if selectedSection == .youon {
                                    ForEach(youonSounds, id: \.self) { sound in
                                        Text(sound)
                                            .frame(width: 50)
                                            .foregroundColor(.gray)
                                    }
                                } else {
                                    ForEach(columnSounds, id: \.self) { sound in
                                        Text(sound)
                                            .frame(width: 50)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        
                        // 假名表格
                        ForEach(getKanaRows(), id: \.0) { row in
                            HStack(spacing: 5) {
                                // 行标题
                                Text(row.0)
                                    .frame(width: 40)
                                    .foregroundColor(.gray)
                                
                                // 假名单元格
                                ForEach(row.1, id: \.id) { kana in
                                    if kana.character.isEmpty {
                                        Text("　")
                                            .frame(width: 50, height: 50)
                                    } else {
                                        KanaCardView(kana: kana)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("假名学习")
        }
    }
    
    // 获取当前显示的假名行
    func getKanaRows() -> [(String, [KanaCharacter])] {
        let list = selectedType == .hiragana ? hiraganaManager.hiraganaList : katakanaManager.katakanaList
        var rows: [(String, [KanaCharacter])] = []
        
        switch selectedSection {
        case .gojuon:
            // 基本五十音图
            for rowTitle in currentRowTitles {
                var rowKana: [KanaCharacter] = []
                
                if rowTitle == "や" || rowTitle == "ヤ" {
                    // や行特殊处理
                    rowKana = [
                        list.first { $0.romaji == "ya" } ?? emptyKana(),
                        emptyKana(),
                        list.first { $0.romaji == "yu" } ?? emptyKana(),
                        emptyKana(),
                        list.first { $0.romaji == "yo" } ?? emptyKana()
                    ]
                } else if rowTitle == "わ" || rowTitle == "ワ" {
                    // わ行特殊处理
                    rowKana = [
                        list.first { $0.romaji == "wa" } ?? emptyKana(),
                        emptyKana(),
                        emptyKana(),
                        emptyKana(),
                        list.first { $0.romaji == "wo" } ?? emptyKana()
                    ]
                    rows.append((rowTitle, rowKana))
                    // ん/ン 单独一行
                    rows.append((selectedType == .hiragana ? "ん" : "ン", 
                        [list.first { $0.romaji == "n" } ?? emptyKana(),
                         emptyKana(), emptyKana(), emptyKana(), emptyKana()]))
                    continue
                } else if rowTitle == "は" || rowTitle == "ハ" {
                    // は行特殊处理
                    rowKana = [
                        list.first { $0.romaji == "ha" } ?? emptyKana(),
                        list.first { $0.romaji == "hi" } ?? emptyKana(),
                        list.first { $0.romaji == "fu" } ?? emptyKana(),
                        list.first { $0.romaji == "he" } ?? emptyKana(),
                        list.first { $0.romaji == "ho" } ?? emptyKana()
                    ]
                } else {
                    // 普通行处理
                    let prefix = getPrefix(for: rowTitle)
                    rowKana = columnSounds.map { sound in
                        if prefix.isEmpty {
                            // あ行特殊处理
                            return list.first { $0.romaji == sound } ?? emptyKana()
                        } else if prefix == "s" && sound == "i" {
                            // し/シ特殊处理
                            return list.first { $0.romaji == "shi" } ?? emptyKana()
                        } else if prefix == "t" && sound == "i" {
                            // ち/チ特殊处理
                            return list.first { $0.romaji == "chi" } ?? emptyKana()
                        } else if prefix == "t" && sound == "u" {
                            // つ/ツ特殊处理
                            return list.first { $0.romaji == "tsu" } ?? emptyKana()
                        } else {
                            return list.first { $0.romaji == "\(prefix)\(sound)" } ?? emptyKana()
                        }
                    }
                }
                rows.append((rowTitle, rowKana))
            }
            
        case .dakuon:
            // 浊音
            let dakuonRows = selectedType == .hiragana ? ["が", "ざ", "だ", "ば"] : ["ガ", "ザ", "ダ", "バ"]
            let prefixes = ["g", "z", "d", "b"]
            
            for (rowTitle, prefix) in zip(dakuonRows, prefixes) {
                let rowKana = columnSounds.map { sound in
                    list.first { $0.romaji == "\(prefix)\(sound)" } ?? emptyKana()
                }
                rows.append((rowTitle, rowKana))
            }
            
        case .handakuon:
            // 半浊音
            let rowTitle = selectedType == .hiragana ? "ぱ" : "パ"
            let rowKana = columnSounds.map { sound in
                list.first { $0.romaji == "p\(sound)" } ?? emptyKana()
            }
            rows.append((rowTitle, rowKana))
            
        case .youon:
            // 拗音处理
            for rowTitle in currentRowTitles {
                var rowKana: [KanaCharacter] = []
                let baseRomaji = getYouonPrefix(for: rowTitle)
                
                rowKana = youonSounds.map { sound in
                    list.first { $0.romaji == "\(baseRomaji)\(sound)" } ?? emptyKana()
                }
                rows.append((rowTitle, rowKana))
            }
            
        case .special:
            // 特殊假名处理
            for rowTitle in currentRowTitles {
                let kana = list.first { $0.character == rowTitle } ?? emptyKana()
                rows.append((rowTitle, [kana]))
            }
            
        case .gairaion:
            // 外来语音处理
            for rowTitle in currentRowTitles {
                let kana = list.first { $0.character == rowTitle } ?? emptyKana()
                rows.append((rowTitle, [kana]))
            }
        }
        
        return rows
    }
    
    // 获取行的罗马音前缀
    private func getPrefix(for rowTitle: String) -> String {
        switch rowTitle {
        case "あ", "ア": return ""
        case "か", "カ": return "k"
        case "さ", "サ": return "s"
        case "た", "タ": return "t"
        case "な", "ナ": return "n"
        case "は", "ハ": return "h"
        case "ま", "マ": return "m"
        case "や", "ヤ": return "y"
        case "ら", "ラ": return "r"
        case "わ", "ワ": return "w"
        default: return ""
        }
    }
    
    // 获取拗音的罗马音前缀
    private func getYouonPrefix(for rowTitle: String) -> String {
        switch rowTitle {
        case "きゃ", "キャ": return "k"
        case "しゃ", "シャ": return "sh"
        case "ちゃ", "チャ": return "ch"
        case "にゃ", "ニャ": return "ny"
        case "ひゃ", "ヒャ": return "hy"
        case "みゃ", "ミャ": return "my"
        case "りゃ", "リャ": return "ry"
        case "ぎゃ", "ギャ": return "gy"
        case "じゃ", "ジャ": return "j"
        case "びゃ", "ビャ": return "by"
        case "ぴゃ", "ピャ": return "py"
        default: return ""
        }
    }
    
    // 创建空的假名占位符
    func emptyKana() -> KanaCharacter {
        KanaCharacter(character: "", romaji: "", strokeCount: 0, type: selectedType)
    }
}

struct KanaCardView: View {
    let kana: KanaCharacter
    
    var body: some View {
        VStack(spacing: 2) {
            if !kana.character.isEmpty {
                Text(kana.character)
                    .font(.title2)
                Text(kana.romaji)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(kana.isLearned ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct KanaLearningView_Previews: PreviewProvider {
    static var previews: some View {
        KanaLearningView()
    }
}
