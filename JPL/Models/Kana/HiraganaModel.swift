import Foundation
import SwiftUI

// 平假名数据管理
class HiraganaDataManager: ObservableObject {
    @Published var hiraganaList: [KanaCharacter] = []
    
    init() {
        setupHiragana()
    }
    
    private func setupHiragana() {
        hiraganaList = [
            // あ行
            KanaCharacter(character: "あ", romaji: "a", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "い", romaji: "i", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "う", romaji: "u", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "え", romaji: "e", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "お", romaji: "o", strokeCount: 3, type: .hiragana),
            
            // か行
            KanaCharacter(character: "か", romaji: "ka", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "き", romaji: "ki", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "く", romaji: "ku", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "け", romaji: "ke", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "こ", romaji: "ko", strokeCount: 2, type: .hiragana),
            
            // さ行
            KanaCharacter(character: "さ", romaji: "sa", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "し", romaji: "shi", strokeCount: 1, type: .hiragana),
            KanaCharacter(character: "す", romaji: "su", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "せ", romaji: "se", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "そ", romaji: "so", strokeCount: 1, type: .hiragana),
            
            // た行
            KanaCharacter(character: "た", romaji: "ta", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "ち", romaji: "chi", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "つ", romaji: "tsu", strokeCount: 1, type: .hiragana),
            KanaCharacter(character: "て", romaji: "te", strokeCount: 1, type: .hiragana),
            KanaCharacter(character: "と", romaji: "to", strokeCount: 2, type: .hiragana),
            
            // な行
            KanaCharacter(character: "な", romaji: "na", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "に", romaji: "ni", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "ぬ", romaji: "nu", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ね", romaji: "ne", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "の", romaji: "no", strokeCount: 1, type: .hiragana),
            
            // は行
            KanaCharacter(character: "は", romaji: "ha", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "ひ", romaji: "hi", strokeCount: 1, type: .hiragana),
            KanaCharacter(character: "ふ", romaji: "fu", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "へ", romaji: "he", strokeCount: 1, type: .hiragana),
            KanaCharacter(character: "ほ", romaji: "ho", strokeCount: 4, type: .hiragana),
            
            // ま行
            KanaCharacter(character: "ま", romaji: "ma", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "み", romaji: "mi", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "む", romaji: "mu", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "め", romaji: "me", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "も", romaji: "mo", strokeCount: 3, type: .hiragana),
            
            // や行
            KanaCharacter(character: "や", romaji: "ya", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "ゆ", romaji: "yu", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "よ", romaji: "yo", strokeCount: 2, type: .hiragana),
            
            // ら行
            KanaCharacter(character: "ら", romaji: "ra", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "り", romaji: "ri", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "る", romaji: "ru", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "れ", romaji: "re", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ろ", romaji: "ro", strokeCount: 1, type: .hiragana),
            
            // わ行
            KanaCharacter(character: "わ", romaji: "wa", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "を", romaji: "wo", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "ん", romaji: "n", strokeCount: 1, type: .hiragana),
            
            // 浊音（が行）
            KanaCharacter(character: "が", romaji: "ga", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "ぎ", romaji: "gi", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ぐ", romaji: "gu", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "げ", romaji: "ge", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "ご", romaji: "go", strokeCount: 3, type: .hiragana),
            
            // 浊音（ざ行）
            KanaCharacter(character: "ざ", romaji: "za", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "じ", romaji: "ji", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ず", romaji: "zu", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "ぜ", romaji: "ze", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "ぞ", romaji: "zo", strokeCount: 2, type: .hiragana),
            
            // 浊音（だ行）
            KanaCharacter(character: "だ", romaji: "da", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "ぢ", romaji: "ji", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "づ", romaji: "zu", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "で", romaji: "de", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ど", romaji: "do", strokeCount: 3, type: .hiragana),
            
            // 浊音（ば行）
            KanaCharacter(character: "ば", romaji: "ba", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "び", romaji: "bi", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ぶ", romaji: "bu", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "べ", romaji: "be", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ぼ", romaji: "bo", strokeCount: 5, type: .hiragana),
            
            // 半浊音（ぱ行）
            KanaCharacter(character: "ぱ", romaji: "pa", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "ぴ", romaji: "pi", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ぷ", romaji: "pu", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ぺ", romaji: "pe", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ぽ", romaji: "po", strokeCount: 5, type: .hiragana),
            
            // 拗音（きゃ行）
            KanaCharacter(character: "きゃ", romaji: "kya", strokeCount: 7, type: .hiragana),
            KanaCharacter(character: "きゅ", romaji: "kyu", strokeCount: 7, type: .hiragana),
            KanaCharacter(character: "きょ", romaji: "kyo", strokeCount: 6, type: .hiragana),
            
            // 拗音（しゃ行）
            KanaCharacter(character: "しゃ", romaji: "sha", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "しゅ", romaji: "shu", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "しょ", romaji: "sho", strokeCount: 3, type: .hiragana),
            
            // 拗音（ちゃ行）
            KanaCharacter(character: "ちゃ", romaji: "cha", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ちゅ", romaji: "chu", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ちょ", romaji: "cho", strokeCount: 4, type: .hiragana),
            
            // 拗音（にゃ行）
            KanaCharacter(character: "にゃ", romaji: "nya", strokeCount: 6, type: .hiragana),
            KanaCharacter(character: "にゅ", romaji: "nyu", strokeCount: 6, type: .hiragana),
            KanaCharacter(character: "にょ", romaji: "nyo", strokeCount: 5, type: .hiragana),
            
            // 拗音（ひゃ行）
            KanaCharacter(character: "ひゃ", romaji: "hya", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "ひゅ", romaji: "hyu", strokeCount: 4, type: .hiragana),
            KanaCharacter(character: "ひょ", romaji: "hyo", strokeCount: 3, type: .hiragana),
            
            // 拗音（みゃ行）
            KanaCharacter(character: "みゃ", romaji: "mya", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "みゅ", romaji: "myu", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "みょ", romaji: "myo", strokeCount: 4, type: .hiragana),
            
            // 拗音（りゃ行）
            KanaCharacter(character: "りゃ", romaji: "rya", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "りゅ", romaji: "ryu", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "りょ", romaji: "ryo", strokeCount: 4, type: .hiragana),
            
            // 拗音浊音（ぎゃ行）
            KanaCharacter(character: "ぎゃ", romaji: "gya", strokeCount: 8, type: .hiragana),
            KanaCharacter(character: "ぎゅ", romaji: "gyu", strokeCount: 8, type: .hiragana),
            KanaCharacter(character: "ぎょ", romaji: "gyo", strokeCount: 7, type: .hiragana),
            
            // 拗音浊音（じゃ行）
            KanaCharacter(character: "じゃ", romaji: "ja", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "じゅ", romaji: "ju", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "じょ", romaji: "jo", strokeCount: 4, type: .hiragana),
            
            // 拗音浊音（びゃ行）
            KanaCharacter(character: "びゃ", romaji: "bya", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "びゅ", romaji: "byu", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "びょ", romaji: "byo", strokeCount: 4, type: .hiragana),
            
            // 拗音半浊音（ぴゃ行）
            KanaCharacter(character: "ぴゃ", romaji: "pya", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ぴゅ", romaji: "pyu", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ぴょ", romaji: "pyo", strokeCount: 4, type: .hiragana),
            
            // 小写假名
            KanaCharacter(character: "っ", romaji: "xtu", strokeCount: 1, type: .hiragana),
            KanaCharacter(character: "ぁ", romaji: "xa", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ぃ", romaji: "xi", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ぅ", romaji: "xu", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ぇ", romaji: "xe", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ぉ", romaji: "xo", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ゃ", romaji: "xya", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ゅ", romaji: "xyu", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ょ", romaji: "xyo", strokeCount: 2, type: .hiragana),
            KanaCharacter(character: "ゎ", romaji: "xwa", strokeCount: 2, type: .hiragana),
            
            // 外来语音（ヴ行）
            KanaCharacter(character: "ゔ", romaji: "vu", strokeCount: 3, type: .hiragana),
            KanaCharacter(character: "ゔぁ", romaji: "va", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ゔぃ", romaji: "vi", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ゔぇ", romaji: "ve", strokeCount: 5, type: .hiragana),
            KanaCharacter(character: "ゔぉ", romaji: "vo", strokeCount: 5, type: .hiragana)
        ]
    }
    
    func markAsLearned(_ character: KanaCharacter) {
        if let index = hiraganaList.firstIndex(where: { $0.id == character.id }) {
            hiraganaList[index].isLearned = true
            hiraganaList[index].lastReviewDate = Date()
        }
    }
} 