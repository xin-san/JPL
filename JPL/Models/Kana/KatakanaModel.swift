import Foundation
import SwiftUI

// 片假名数据管理
class KatakanaDataManager: ObservableObject {
    @Published var katakanaList: [KanaCharacter] = []
    
    init() {
        setupKatakana()
    }
    
    private func setupKatakana() {
        katakanaList = [
            // ア行
            KanaCharacter(character: "ア", romaji: "a", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "イ", romaji: "i", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ウ", romaji: "u", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "エ", romaji: "e", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "オ", romaji: "o", strokeCount: 3, type: .katakana),
            
            // カ行
            KanaCharacter(character: "カ", romaji: "ka", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "キ", romaji: "ki", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ク", romaji: "ku", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ケ", romaji: "ke", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "コ", romaji: "ko", strokeCount: 2, type: .katakana),
            
            // サ行
            KanaCharacter(character: "サ", romaji: "sa", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "シ", romaji: "shi", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ス", romaji: "su", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "セ", romaji: "se", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ソ", romaji: "so", strokeCount: 2, type: .katakana),
            
            // タ行
            KanaCharacter(character: "タ", romaji: "ta", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "チ", romaji: "chi", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ツ", romaji: "tsu", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "テ", romaji: "te", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ト", romaji: "to", strokeCount: 2, type: .katakana),
            
            // ナ行
            KanaCharacter(character: "ナ", romaji: "na", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ニ", romaji: "ni", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ヌ", romaji: "nu", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ネ", romaji: "ne", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ノ", romaji: "no", strokeCount: 1, type: .katakana),
            
            // ハ行
            KanaCharacter(character: "ハ", romaji: "ha", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ヒ", romaji: "hi", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "フ", romaji: "fu", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ヘ", romaji: "he", strokeCount: 1, type: .katakana),
            KanaCharacter(character: "ホ", romaji: "ho", strokeCount: 3, type: .katakana),
            
            // マ行
            KanaCharacter(character: "マ", romaji: "ma", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ミ", romaji: "mi", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ム", romaji: "mu", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "メ", romaji: "me", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "モ", romaji: "mo", strokeCount: 3, type: .katakana),
            
            // ヤ行
            KanaCharacter(character: "ヤ", romaji: "ya", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ユ", romaji: "yu", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ヨ", romaji: "yo", strokeCount: 2, type: .katakana),
            
            // ラ行
            KanaCharacter(character: "ラ", romaji: "ra", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "リ", romaji: "ri", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ル", romaji: "ru", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "レ", romaji: "re", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ロ", romaji: "ro", strokeCount: 3, type: .katakana),
            
            // ワ行
            KanaCharacter(character: "ワ", romaji: "wa", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ヲ", romaji: "wo", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ン", romaji: "n", strokeCount: 2, type: .katakana),
            
            // 浊音（ガ行）
            KanaCharacter(character: "ガ", romaji: "ga", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ギ", romaji: "gi", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "グ", romaji: "gu", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ゲ", romaji: "ge", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ゴ", romaji: "go", strokeCount: 3, type: .katakana),
            
            // 浊音（ザ行）
            KanaCharacter(character: "ザ", romaji: "za", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ジ", romaji: "ji", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ズ", romaji: "zu", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ゼ", romaji: "ze", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ゾ", romaji: "zo", strokeCount: 3, type: .katakana),
            
            // 浊音（ダ行）
            KanaCharacter(character: "ダ", romaji: "da", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ヂ", romaji: "ji", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ヅ", romaji: "zu", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "デ", romaji: "de", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ド", romaji: "do", strokeCount: 3, type: .katakana),
            
            // 浊音（バ行）
            KanaCharacter(character: "バ", romaji: "ba", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ビ", romaji: "bi", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ブ", romaji: "bu", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ベ", romaji: "be", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ボ", romaji: "bo", strokeCount: 4, type: .katakana),
            
            // 半浊音（パ行）
            KanaCharacter(character: "パ", romaji: "pa", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ピ", romaji: "pi", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "プ", romaji: "pu", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ペ", romaji: "pe", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ポ", romaji: "po", strokeCount: 4, type: .katakana),
            
            // 拗音（キャ行）
            KanaCharacter(character: "キャ", romaji: "kya", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "キュ", romaji: "kyu", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "キョ", romaji: "kyo", strokeCount: 4, type: .katakana),
            
            // 拗音（シャ行）
            KanaCharacter(character: "シャ", romaji: "sha", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "シュ", romaji: "shu", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ショ", romaji: "sho", strokeCount: 4, type: .katakana),
            
            // 拗音（チャ行）
            KanaCharacter(character: "チャ", romaji: "cha", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "チュ", romaji: "chu", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "チョ", romaji: "cho", strokeCount: 4, type: .katakana),
            
            // 拗音（ニャ行）
            KanaCharacter(character: "ニャ", romaji: "nya", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ニュ", romaji: "nyu", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ニョ", romaji: "nyo", strokeCount: 3, type: .katakana),
            
            // 拗音（ヒャ行）
            KanaCharacter(character: "ヒャ", romaji: "hya", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ヒュ", romaji: "hyu", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ヒョ", romaji: "hyo", strokeCount: 3, type: .katakana),
            
            // 拗音（ミャ行）
            KanaCharacter(character: "ミャ", romaji: "mya", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ミュ", romaji: "myu", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ミョ", romaji: "myo", strokeCount: 4, type: .katakana),
            
            // 拗音（リャ行）
            KanaCharacter(character: "リャ", romaji: "rya", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "リュ", romaji: "ryu", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "リョ", romaji: "ryo", strokeCount: 3, type: .katakana),
            
            // 拗音浊音（ギャ行）
            KanaCharacter(character: "ギャ", romaji: "gya", strokeCount: 6, type: .katakana),
            KanaCharacter(character: "ギュ", romaji: "gyu", strokeCount: 6, type: .katakana),
            KanaCharacter(character: "ギョ", romaji: "gyo", strokeCount: 5, type: .katakana),
            
            // 拗音浊音（ジャ行）
            KanaCharacter(character: "ジャ", romaji: "ja", strokeCount: 6, type: .katakana),
            KanaCharacter(character: "ジュ", romaji: "ju", strokeCount: 6, type: .katakana),
            KanaCharacter(character: "ジョ", romaji: "jo", strokeCount: 5, type: .katakana),
            
            // 拗音浊音（ビャ行）
            KanaCharacter(character: "ビャ", romaji: "bya", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ビュ", romaji: "byu", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ビョ", romaji: "byo", strokeCount: 4, type: .katakana),
            
            // 拗音半浊音（ピャ行）
            KanaCharacter(character: "ピャ", romaji: "pya", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ピュ", romaji: "pyu", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ピョ", romaji: "pyo", strokeCount: 4, type: .katakana),
            
            // 小写假名
            KanaCharacter(character: "ッ", romaji: "xtu", strokeCount: 1, type: .katakana),
            KanaCharacter(character: "ァ", romaji: "xa", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ィ", romaji: "xi", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ゥ", romaji: "xu", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ェ", romaji: "xe", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ォ", romaji: "xo", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ャ", romaji: "xya", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ュ", romaji: "xyu", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ョ", romaji: "xyo", strokeCount: 2, type: .katakana),
            KanaCharacter(character: "ヮ", romaji: "xwa", strokeCount: 2, type: .katakana),
            
            // 外来语音（ヴ行）
            KanaCharacter(character: "ヴ", romaji: "vu", strokeCount: 3, type: .katakana),
            KanaCharacter(character: "ヴァ", romaji: "va", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ヴィ", romaji: "vi", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ヴェ", romaji: "ve", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ヴォ", romaji: "vo", strokeCount: 5, type: .katakana),
            
            // 外来语音（ファ行）
            KanaCharacter(character: "ファ", romaji: "fa", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "フィ", romaji: "fi", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "フェ", romaji: "fe", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "フォ", romaji: "fo", strokeCount: 4, type: .katakana),
            
            // 外来语音（ウィ/ウェ/ウォ）
            KanaCharacter(character: "ウィ", romaji: "wi", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ウェ", romaji: "we", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ウォ", romaji: "wo", strokeCount: 4, type: .katakana),
            
            // 外来语音（ツァ行）
            KanaCharacter(character: "ツァ", romaji: "tsa", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ツィ", romaji: "tsi", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ツェ", romaji: "tse", strokeCount: 5, type: .katakana),
            KanaCharacter(character: "ツォ", romaji: "tso", strokeCount: 5, type: .katakana),
            
            // 外来语音（ティ/ディ）
            KanaCharacter(character: "ティ", romaji: "ti", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ディ", romaji: "di", strokeCount: 5, type: .katakana),
            
            // 外来语音（デュ）
            KanaCharacter(character: "デュ", romaji: "du", strokeCount: 5, type: .katakana),
            
            // 外来语音（トゥ/ドゥ）
            KanaCharacter(character: "トゥ", romaji: "tu", strokeCount: 4, type: .katakana),
            KanaCharacter(character: "ドゥ", romaji: "du", strokeCount: 5, type: .katakana)
        ]
    }
    
    func markAsLearned(_ character: KanaCharacter) {
        if let index = katakanaList.firstIndex(where: { $0.id == character.id }) {
            katakanaList[index].isLearned = true
            katakanaList[index].lastReviewDate = Date()
        }
    }
} 