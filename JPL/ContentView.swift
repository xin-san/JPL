//
//  ContentView.swift
//  JPL
//
//  Created by 大帅哥 on R 6/12/09.
//

import SwiftUI

// MARK: - Models
struct Kana: Identifiable {
    let id = UUID()
    let character: String
    let romanization: String
    let sound: String
    let examples: [KanaExample]
}

struct KanaExample: Identifiable {
    let id = UUID()
    let word: String
    let reading: String
    let meaning: String
}

// MARK: - Data
class KanaData {
    // 平假名基本音
    static let hiragana: [Kana] = [
        // あ行
        Kana(character: "あ", romanization: "a", sound: "a",
             examples: [KanaExample(word: "あめ", reading: "ame", meaning: "雨"),
                       KanaExample(word: "あか", reading: "aka", meaning: "红色")]),
        Kana(character: "い", romanization: "i", sound: "i",
             examples: [KanaExample(word: "いぬ", reading: "inu", meaning: "狗"),
                       KanaExample(word: "いし", reading: "ishi", meaning: "石头")]),
        Kana(character: "う", romanization: "u", sound: "u",
             examples: [KanaExample(word: "う����", reading: "umi", meaning: "海"),
                       KanaExample(word: "うた", reading: "uta", meaning: "歌")]),
        Kana(character: "え", romanization: "e", sound: "e",
             examples: [KanaExample(word: "えき", reading: "eki", meaning: "车站"),
                       KanaExample(word: "えん", reading: "en", meaning: "圆")]),
        Kana(character: "お", romanization: "o", sound: "o",
             examples: [KanaExample(word: "おと", reading: "oto", meaning: "声音"),
                       KanaExample(word: "おか", reading: "oka", meaning: "丘陵")]),
        
        // か行
        Kana(character: "か", romanization: "ka", sound: "ka",
             examples: [KanaExample(word: "かみ", reading: "kami", meaning: "纸"),
                       KanaExample(word: "かさ", reading: "kasa", meaning: "伞")]),
        Kana(character: "き", romanization: "ki", sound: "ki",
             examples: [KanaExample(word: "きく", reading: "kiku", meaning: "菊花"),
                       KanaExample(word: "きて", reading: "kite", meaning: "来")]),
        Kana(character: "く", romanization: "ku", sound: "ku",
             examples: [KanaExample(word: "くも", reading: "kumo", meaning: "云"),
                       KanaExample(word: "くつ", reading: "kutsu", meaning: "鞋")]),
        Kana(character: "け", romanization: "ke", sound: "ke",
             examples: [KanaExample(word: "けむり", reading: "kemuri", meaning: "烟"),
                       KanaExample(word: "けさ", reading: "kesa", meaning: "今早")]),
        Kana(character: "こ", romanization: "ko", sound: "ko",
             examples: [KanaExample(word: "こめ", reading: "kome", meaning: "米"),
                       KanaExample(word: "ここ", reading: "koko", meaning: "这里")]),
        
        // さ行
        Kana(character: "さ", romanization: "sa", sound: "sa",
             examples: [KanaExample(word: "さくら", reading: "sakura", meaning: "樱花"),
                       KanaExample(word: "さる", reading: "saru", meaning: "猴子")]),
        Kana(character: "し", romanization: "shi", sound: "shi",
             examples: [KanaExample(word: "しま", reading: "shima", meaning: "岛"),
                       KanaExample(word: "しろ", reading: "shiro", meaning: "白色")]),
        Kana(character: "す", romanization: "su", sound: "su",
             examples: [KanaExample(word: "すし", reading: "sushi", meaning: "寿司"),
                       KanaExample(word: "すな", reading: "suna", meaning: "沙")]),
        Kana(character: "せ", romanization: "se", sound: "se",
             examples: [KanaExample(word: "せなか", reading: "senaka", meaning: "背部"),
                       KanaExample(word: "せき", reading: "seki", meaning: "咳嗽")]),
        Kana(character: "そ", romanization: "so", sound: "so",
             examples: [KanaExample(word: "そら", reading: "sora", meaning: "天空"),
                       KanaExample(word: "そと", reading: "soto", meaning: "外面")]),
        
        // た行
        Kana(character: "た", romanization: "ta", sound: "ta",
             examples: [KanaExample(word: "たこ", reading: "tako", meaning: "章鱼"),
                       KanaExample(word: "たび", reading: "tabi", meaning: "旅行")]),
        Kana(character: "ち", romanization: "chi", sound: "chi",
             examples: [KanaExample(word: "ちず", reading: "chizu", meaning: "地图"),
                       KanaExample(word: "ちち", reading: "chichi", meaning: "父亲")]),
        Kana(character: "つ", romanization: "tsu", sound: "tsu",
             examples: [KanaExample(word: "つき", reading: "tsuki", meaning: "月"),
                       KanaExample(word: "つめ", reading: "tsume", meaning: "指甲")]),
        Kana(character: "て", romanization: "te", sound: "te",
             examples: [KanaExample(word: "てら", reading: "tera", meaning: "寺庙"),
                       KanaExample(word: "てん", reading: "ten", meaning: "天")]),
        Kana(character: "と", romanization: "to", sound: "to",
             examples: [KanaExample(word: "とり", reading: "tori", meaning: "鸟"),
                       KanaExample(word: "とけい", reading: "tokei", meaning: "钟表")]),
        
        // な行
        Kana(character: "な", romanization: "na", sound: "na",
             examples: [KanaExample(word: "なつ", reading: "natsu", meaning: "夏天"),
                       KanaExample(word: "なか", reading: "naka", meaning: "中间")]),
        Kana(character: "に", romanization: "ni", sound: "ni",
             examples: [KanaExample(word: "にく", reading: "niku", meaning: "肉"),
                       KanaExample(word: "にわ", reading: "niwa", meaning: "花园")]),
        Kana(character: "ぬ", romanization: "nu", sound: "nu",
             examples: [KanaExample(word: "ぬま", reading: "numa", meaning: "沼泽"),
                       KanaExample(word: "ぬの", reading: "nuno", meaning: "���")]),
        Kana(character: "ね", romanization: "ne", sound: "ne",
             examples: [KanaExample(word: "ねこ", reading: "neko", meaning: "猫"),
                       KanaExample(word: "ねつ", reading: "netsu", meaning: "发烧")]),
        Kana(character: "の", romanization: "no", sound: "no",
             examples: [KanaExample(word: "のみ", reading: "nomi", meaning: "蚤"),
                       KanaExample(word: "のり", reading: "nori", meaning: "海苔")]),
        
        // は行
        Kana(character: "は", romanization: "ha", sound: "ha",
             examples: [KanaExample(word: "はな", reading: "hana", meaning: "花"),
                       KanaExample(word: "はし", reading: "hashi", meaning: "筷子")]),
        Kana(character: "ひ", romanization: "hi", sound: "hi",
             examples: [KanaExample(word: "ひと", reading: "hito", meaning: "人"),
                       KanaExample(word: "ひる", reading: "hiru", meaning: "中午")]),
        Kana(character: "ふ", romanization: "fu", sound: "fu",
             examples: [KanaExample(word: "ふね", reading: "fune", meaning: "船"),
                       KanaExample(word: "ふゆ", reading: "fuyu", meaning: "冬天")]),
        Kana(character: "へ", romanization: "he", sound: "he",
             examples: [KanaExample(word: "へや", reading: "heya", meaning: "房间"),
                       KanaExample(word: "へび", reading: "hebi", meaning: "蛇")]),
        Kana(character: "ほ", romanization: "ho", sound: "ho",
             examples: [KanaExample(word: "ほし", reading: "hoshi", meaning: "星星"),
                       KanaExample(word: "ほん", reading: "hon", meaning: "书")]),
        
        // ま行
        Kana(character: "ま", romanization: "ma", sound: "ma",
             examples: [KanaExample(word: "まど", reading: "mado", meaning: "窗户"),
                       KanaExample(word: "まち", reading: "machi", meaning: "城市")]),
        Kana(character: "み", romanization: "mi", sound: "mi",
             examples: [KanaExample(word: "みず", reading: "mizu", meaning: "水"),
                       KanaExample(word: "みせ", reading: "mise", meaning: "商店")]),
        Kana(character: "む", romanization: "mu", sound: "mu",
             examples: [KanaExample(word: "むし", reading: "mushi", meaning: "虫子"),
                       KanaExample(word: "むら", reading: "mura", meaning: "村庄")]),
        Kana(character: "め", romanization: "me", sound: "me",
             examples: [KanaExample(word: "めがね", reading: "megane", meaning: "眼镜"),
                       KanaExample(word: "め", reading: "me", meaning: "眼睛")]),
        Kana(character: "も", romanization: "mo", sound: "mo",
             examples: [KanaExample(word: "もり", reading: "mori", meaning: "森林"),
                       KanaExample(word: "もち", reading: "mochi", meaning: "年糕")]),
        
        // や行
        Kana(character: "や", romanization: "ya", sound: "ya",
             examples: [KanaExample(word: "やま", reading: "yama", meaning: "山"),
                       KanaExample(word: "やさい", reading: "yasai", meaning: "蔬菜")]),
        Kana(character: "ゆ", romanization: "yu", sound: "yu",
             examples: [KanaExample(word: "ゆき", reading: "yuki", meaning: "雪"),
                       KanaExample(word: "ゆび", reading: "yubi", meaning: "手指")]),
        Kana(character: "よ", romanization: "yo", sound: "yo",
             examples: [KanaExample(word: "よる", reading: "yoru", meaning: "夜晚"),
                       KanaExample(word: "よむ", reading: "yomu", meaning: "读")]),
        
        // ら行
        Kana(character: "ら", romanization: "ra", sound: "ra",
             examples: [KanaExample(word: "らく", reading: "raku", meaning: "轻松"),
                       KanaExample(word: "らいねん", reading: "rainen", meaning: "明年")]),
        Kana(character: "り", romanization: "ri", sound: "ri",
             examples: [KanaExample(word: "りんご", reading: "ringo", meaning: "苹果"),
                       KanaExample(word: "りょうり", reading: "ryouri", meaning: "料理")]),
        Kana(character: "る", romanization: "ru", sound: "ru",
             examples: [KanaExample(word: "るす", reading: "rusu", meaning: "不在家"),
                       KanaExample(word: "るい", reading: "rui", meaning: "类")]),
        Kana(character: "れ", romanization: "re", sound: "re",
             examples: [KanaExample(word: "れきし", reading: "rekishi", meaning: "历史"),
                       KanaExample(word: "れい", reading: "rei", meaning: "零")]),
        Kana(character: "ろ", romanization: "ro", sound: "ro",
             examples: [KanaExample(word: "ろうか", reading: "rouka", meaning: "走廊"),
                       KanaExample(word: "ろく", reading: "roku", meaning: "六")]),
        
        // わ行
        Kana(character: "わ", romanization: "wa", sound: "wa",
             examples: [KanaExample(word: "わたし", reading: "watashi", meaning: "我"),
                       KanaExample(word: "わらい", reading: "warai", meaning: "笑")]),
        Kana(character: "を", romanization: "wo", sound: "wo",
             examples: [KanaExample(word: "を", reading: "wo", meaning: "（助词）"),
                       KanaExample(word: "かばんを", reading: "kaban wo", meaning: "包包（助词）")]),
        Kana(character: "ん", romanization: "n", sound: "n",
             examples: [KanaExample(word: "さんぽ", reading: "sanpo", meaning: "步"),
                       KanaExample(word: "でんわ", reading: "denwa", meaning: "电话")]),
        
        // 浊音
        // が行
        Kana(character: "が", romanization: "ga", sound: "ga",
             examples: [KanaExample(word: "がっこう", reading: "gakkou", meaning: "学校"),
                       KanaExample(word: "がんばる", reading: "ganbaru", meaning: "加油")]),
        Kana(character: "ぎ", romanization: "gi", sound: "gi",
             examples: [KanaExample(word: "ぎんこう", reading: "ginkou", meaning: "银行"),
                       KanaExample(word: "かぎ", reading: "kagi", meaning: "钥匙")]),
        Kana(character: "ぐ", romanization: "gu", sound: "gu",
             examples: [KanaExample(word: "ぐんたい", reading: "guntai", meaning: "军队"),
                       KanaExample(word: "もぐら", reading: "mogura", meaning: "鼹鼠")]),
        Kana(character: "げ", romanization: "ge", sound: "ge",
             examples: [KanaExample(word: "げんき", reading: "genki", meaning: "精神"),
                       KanaExample(word: "ひげ", reading: "hige", meaning: "胡子")]),
        Kana(character: "ご", romanization: "go", sound: "go",
             examples: [KanaExample(word: "ごはん", reading: "gohan", meaning: "饭"),
                       KanaExample(word: "ごめん", reading: "gomen", meaning: "对不起")]),
        
        // ざ行
        Kana(character: "ざ", romanization: "za", sound: "za",
             examples: [KanaExample(word: "ざっし", reading: "zasshi", meaning: "杂志"),
                       KanaExample(word: "ちざ", reading: "chiza", meaning: "座位")]),
        Kana(character: "じ", romanization: "ji", sound: "ji",
             examples: [KanaExample(word: "じかん", reading: "jikan", meaning: "时间"),
                       KanaExample(word: "もじ", reading: "moji", meaning: "文字")]),
        Kana(character: "ず", romanization: "zu", sound: "zu",
             examples: [KanaExample(word: "ずかん", reading: "zukan", meaning: "图鉴"),
                       KanaExample(word: "みず", reading: "mizu", meaning: "水")]),
        Kana(character: "ぜ", romanization: "ze", sound: "ze",
             examples: [KanaExample(word: "ぜんぶ", reading: "zenbu", meaning: "全部"),
                       KanaExample(word: "かぜ", reading: "kaze", meaning: "风")]),
        Kana(character: "ぞ", romanization: "zo", sound: "zo",
             examples: [KanaExample(word: "ぞう", reading: "zou", meaning: "象"),
                       KanaExample(word: "みぞ", reading: "mizo", meaning: "沟")]),
        
        // だ行
        Kana(character: "だ", romanization: "da", sound: "da",
             examples: [KanaExample(word: "だいがく", reading: "daigaku", meaning: "大学"),
                       KanaExample(word: "ちゃだ", reading: "chada", meaning: "茶")]),
        Kana(character: "ぢ", romanization: "ji", sound: "ji",
             examples: [KanaExample(word: "はなぢ", reading: "hanaji", meaning: "鼻血"),
                       KanaExample(word: "ちぢむ", reading: "chijimu", meaning: "收缩")]),
        Kana(character: "づ", romanization: "zu", sound: "zu",
             examples: [KanaExample(word: "つづく", reading: "tsuzuku", meaning: "继续"),
                       KanaExample(word: "みづうみ", reading: "mizuumi", meaning: "湖")]),
        Kana(character: "で", romanization: "de", sound: "de",
             examples: [KanaExample(word: "でんわ", reading: "denwa", meaning: "电话"),
                       KanaExample(word: "うで", reading: "ude", meaning: "手臂")]),
        Kana(character: "ど", romanization: "do", sound: "do",
             examples: [KanaExample(word: "どうぶつ", reading: "doubutsu", meaning: "动物"),
                       KanaExample(word: "まど", reading: "mado", meaning: "窗户")]),
        
        // ば行
        Kana(character: "ば", romanization: "ba", sound: "ba",
             examples: [KanaExample(word: "ばんごはん", reading: "bangohan", meaning: "晚饭"),
                       KanaExample(word: "たばこ", reading: "tabako", meaning: "香烟")]),
        Kana(character: "び", romanization: "bi", sound: "bi",
             examples: [KanaExample(word: "びょういん", reading: "byouin", meaning: "医院"),
                       KanaExample(word: "えび", reading: "ebi", meaning: "虾")]),
        Kana(character: "ぶ", romanization: "bu", sound: "bu",
             examples: [KanaExample(word: "ぶんぽう", reading: "bunpou", meaning: "语法"),
                       KanaExample(word: "ぶぶる", reading: "naburu", meaning: "戏弄")]),
        Kana(character: "べ", romanization: "be", sound: "be",
             examples: [KanaExample(word: "べんきょう", reading: "benkyou", meaning: "学习"),
                       KanaExample(word: "なべ", reading: "nabe", meaning: "锅")]),
        Kana(character: "ぼ", romanization: "bo", sound: "bo",
             examples: [KanaExample(word: "ぼうし", reading: "boushi", meaning: "帽子"),
                       KanaExample(word: "そぼ", reading: "sobo", meaning: "祖母")]),
        
        // ぱ行（半浊音）
        Kana(character: "ぱ", romanization: "pa", sound: "pa",
             examples: [KanaExample(word: "ぱん", reading: "pan", meaning: "面包"),
                       KanaExample(word: "ぱちぱち", reading: "pachipachi", meaning: "啪嗒啪嗒")]),
        Kana(character: "ぴ", romanization: "pi", sound: "pi",
             examples: [KanaExample(word: "ぴかぴか", reading: "pikapika", meaning: "闪闪发光"),
                       KanaExample(word: "はっぴ", reading: "happi", meaning: "法被")]),
        Kana(character: "ぷ", romanization: "pu", sound: "pu",
             examples: [KanaExample(word: "ぷーる", reading: "puuru", meaning: "游泳池"),
                       KanaExample(word: "ぷりん", reading: "purin", meaning: "布丁")]),
        Kana(character: "ぺ", romanization: "pe", sound: "pe",
             examples: [KanaExample(word: "ぺん", reading: "pen", meaning: "笔"),
                       KanaExample(word: "ぺらぺら", reading: "perapera", meaning: "流利")]),
        Kana(character: "ぽ", romanization: "po", sound: "po",
             examples: [KanaExample(word: "ぽけっと", reading: "poketto", meaning: "口袋"),
                       KanaExample(word: "ぽい", reading: "poi", meaning: "扔掉")])
    ]
    
    // 片假名
    static let katakana: [Kana] = [
        // ア行
        Kana(character: "ア", romanization: "a", sound: "a",
             examples: [KanaExample(word: "アイス", reading: "aisu", meaning: "冰淇淋"),
                       KanaExample(word: "アニメ", reading: "anime", meaning: "动画")]),
        Kana(character: "イ", romanization: "i", sound: "i",
             examples: [KanaExample(word: "インク", reading: "inku", meaning: "墨水"),
                       KanaExample(word: "イメージ", reading: "imeeji", meaning: "形象")]),
        Kana(character: "ウ", romanization: "u", sound: "u",
             examples: [KanaExample(word: "ウール", reading: "uuru", meaning: "羊毛"),
                       KanaExample(word: "ウィンドウ", reading: "windou", meaning: "窗口")]),
        Kana(character: "エ", romanization: "e", sound: "e",
             examples: [KanaExample(word: "エレベーター", reading: "erebeetaa", meaning: "电梯"),
                       KanaExample(word: "エネルギー", reading: "enerugii", meaning: "能量")]),
        Kana(character: "オ", romanization: "o", sound: "o",
             examples: [KanaExample(word: "オレンジ", reading: "orenji", meaning: "橙子"),
                       KanaExample(word: "オフィス", reading: "ofisu", meaning: "办公室")]),
        
        // カ行
        Kana(character: "カ", romanization: "ka", sound: "ka",
             examples: [KanaExample(word: "カメラ", reading: "kamera", meaning: "相机"),
                       KanaExample(word: "カレー", reading: "karee", meaning: "咖喱")]),
        Kana(character: "キ", romanization: "ki", sound: "ki",
             examples: [KanaExample(word: "キーボード", reading: "kiiboodo", meaning: "键盘"),
                       KanaExample(word: "キャンプ", reading: "kyanpu", meaning: "露营")]),
        Kana(character: "ク", romanization: "ku", sound: "ku",
             examples: [KanaExample(word: "クラス", reading: "kurasu", meaning: "班级"),
                       KanaExample(word: "クリスマス", reading: "kurisumasu", meaning: "圣诞节")]),
        Kana(character: "ケ", romanization: "ke", sound: "ke",
             examples: [KanaExample(word: "ケーキ", reading: "keeki", meaning: "蛋糕"),
                       KanaExample(word: "ケース", reading: "keesu", meaning: "盒子")]),
        Kana(character: "コ", romanization: "ko", sound: "ko",
             examples: [KanaExample(word: "コーヒー", reading: "koohii", meaning: "咖啡"),
                       KanaExample(word: "コピー", reading: "kopii", meaning: "复印")]),
        
        // サ行
        Kana(character: "サ", romanization: "sa", sound: "sa",
             examples: [KanaExample(word: "サイズ", reading: "saizu", meaning: "尺寸"),
                       KanaExample(word: "サラダ", reading: "sarada", meaning: "沙拉")]),
        Kana(character: "シ", romanization: "shi", sound: "shi",
             examples: [KanaExample(word: "シャツ", reading: "shatsu", meaning: "衬衫"),
                       KanaExample(word: "システム", reading: "shisutemu", meaning: "系统")]),
        Kana(character: "ス", romanization: "su", sound: "su",
             examples: [KanaExample(word: "スマホ", reading: "sumaho", meaning: "智能手机"),
                       KanaExample(word: "スポーツ", reading: "supootsu", meaning: "运动")]),
        Kana(character: "セ", romanization: "se", sound: "se",
             examples: [KanaExample(word: "セーター", reading: "seetaa", meaning: "毛衣"),
                       KanaExample(word: "センター", reading: "sentaa", meaning: "中心")]),
        Kana(character: "ソ", romanization: "so", sound: "so",
             examples: [KanaExample(word: "ソファー", reading: "sofaa", meaning: "沙发"),
                       KanaExample(word: "ソフト", reading: "sofuto", meaning: "软件")]),
        
        // タ行
        Kana(character: "タ", romanization: "ta", sound: "ta",
             examples: [KanaExample(word: "タクシー", reading: "takushii", meaning: "出租车"),
                       KanaExample(word: "タイプ", reading: "taipu", meaning: "类型")]),
        Kana(character: "チ", romanization: "chi", sound: "chi",
             examples: [KanaExample(word: "チケット", reading: "chiketto", meaning: "票"),
                       KanaExample(word: "チーズ", reading: "chiizu", meaning: "奶酪")]),
        Kana(character: "ツ", romanization: "tsu", sound: "tsu",
             examples: [KanaExample(word: "ツアー", reading: "tsuaa", meaning: "旅行团"),
                       KanaExample(word: "ツール", reading: "tsuuru", meaning: "工具")]),
        Kana(character: "テ", romanization: "te", sound: "te",
             examples: [KanaExample(word: "テレビ", reading: "terebi", meaning: "电视"),
                       KanaExample(word: "テーブル", reading: "teeburu", meaning: "桌子")]),
        Kana(character: "ト", romanization: "to", sound: "to",
             examples: [KanaExample(word: "トマト", reading: "tomato", meaning: "番茄"),
                       KanaExample(word: "トイレ", reading: "toire", meaning: "厕所")]),
        
        // ナ行
        Kana(character: "ナ", romanization: "na", sound: "na",
             examples: [KanaExample(word: "ナイフ", reading: "naifu", meaning: "小刀"),
                       KanaExample(word: "ナンバー", reading: "nanbaa", meaning: "号码")]),
        Kana(character: "ニ", romanization: "ni", sound: "ni",
             examples: [KanaExample(word: "ニュース", reading: "nyuusu", meaning: "新闻"),
                       KanaExample(word: "ニックネーム", reading: "nikkuneemu", meaning: "昵称")]),
        Kana(character: "ヌ", romanization: "nu", sound: "nu",
             examples: [KanaExample(word: "ヌードル", reading: "nuudoru", meaning: "面条"),
                       KanaExample(word: "メヌー", reading: "menyuu", meaning: "菜单")]),
        Kana(character: "ネ", romanization: "ne", sound: "ne",
             examples: [KanaExample(word: "ネクタイ", reading: "nekutai", meaning: "领带"),
                       KanaExample(word: "ネット", reading: "netto", meaning: "网络")]),
        Kana(character: "ノ", romanization: "no", sound: "no",
             examples: [KanaExample(word: "ノート", reading: "nooto", meaning: "笔记本"),
                       KanaExample(word: "ノルウェー", reading: "noruuee", meaning: "挪威")]),
        
        // ハ行
        Kana(character: "ハ", romanization: "ha", sound: "ha",
             examples: [KanaExample(word: "ハンバーガー", reading: "hanbaagaa", meaning: "汉堡"),
                       KanaExample(word: "ハロー", reading: "haroo", meaning: "你好")]),
        Kana(character: "ヒ", romanization: "hi", sound: "hi",
             examples: [KanaExample(word: "ヒーター", reading: "hiitaa", meaning: "暖气"),
                       KanaExample(word: "ヒント", reading: "hinto", meaning: "提示")]),
        Kana(character: "フ", romanization: "fu", sound: "fu",
             examples: [KanaExample(word: "フライパン", reading: "furaipan", meaning: "平底锅"),
                       KanaExample(word: "フォーク", reading: "fooku", meaning: "叉")]),
        Kana(character: "ヘ", romanization: "he", sound: "he",
             examples: [KanaExample(word: "ヘリコプター", reading: "herikoputaa", meaning: "直升机"),
                       KanaExample(word: "ページ", reading: "peeji", meaning: "页")]),
        Kana(character: "ホ", romanization: "ho", sound: "ho",
             examples: [KanaExample(word: "ホテル", reading: "hoteru", meaning: "酒店"),
                       KanaExample(word: "ホーム", reading: "hoomu", meaning: "首页")]),
        
        // マ行
        Kana(character: "マ", romanization: "ma", sound: "ma",
             examples: [KanaExample(word: "マウス", reading: "mausu", meaning: "鼠标"),
                       KanaExample(word: "マスク", reading: "masuku", meaning: "口罩")]),
        Kana(character: "ミ", romanization: "mi", sound: "mi",
             examples: [KanaExample(word: "ミルク", reading: "miruku", meaning: "牛奶"),
                       KanaExample(word: "ミュージック", reading: "myuujikku", meaning: "音乐")]),
        Kana(character: "ム", romanization: "mu", sound: "mu",
             examples: [KanaExample(word: "ムービー", reading: "muubii", meaning: "电影"),
                       KanaExample(word: "ムード", reading: "muudo", meaning: "氛围")]),
        Kana(character: "メ", romanization: "me", sound: "me",
             examples: [KanaExample(word: "メール", reading: "meeru", meaning: "邮件"),
                       KanaExample(word: "メニュー", reading: "menyuu", meaning: "菜单")]),
        Kana(character: "モ", romanization: "mo", sound: "mo",
             examples: [KanaExample(word: "モニター", reading: "monitaa", meaning: "显示器"),
                       KanaExample(word: "モデル", reading: "moderu", meaning: "模特")]),
        
        // ヤ行
        Kana(character: "ヤ", romanization: "ya", sound: "ya",
             examples: [KanaExample(word: "ヤクルト", reading: "yakuruto", meaning: "养乐多"),
                       KanaExample(word: "ヤフー", reading: "yahuu", meaning: "雅虎")]),
        Kana(character: "ユ", romanization: "yu", sound: "yu",
             examples: [KanaExample(word: "ユーザー", reading: "yuuzaa", meaning: "用户"),
                       KanaExample(word: "ユニーク", reading: "yuniiku", meaning: "独特")]),
        Kana(character: "ヨ", romanization: "yo", sound: "yo",
             examples: [KanaExample(word: "ヨーグルト", reading: "yooguruto", meaning: "酸奶"),
                       KanaExample(word: "ヨーロッパ", reading: "yooroppa", meaning: "欧洲")]),
        
        // ラ行
        Kana(character: "ラ", romanization: "ra", sound: "ra",
             examples: [KanaExample(word: "ラジオ", reading: "rajio", meaning: "收音机"),
                       KanaExample(word: "ラーメン", reading: "raamen", meaning: "拉面")]),
        Kana(character: "リ", romanization: "ri", sound: "ri",
             examples: [KanaExample(word: "リモコン", reading: "rimokon", meaning: "遥控器"),
                       KanaExample(word: "リンク", reading: "rinku", meaning: "链接")]),
        Kana(character: "ル", romanization: "ru", sound: "ru",
             examples: [KanaExample(word: "ルール", reading: "ruuru", meaning: "规则"),
                       KanaExample(word: "ルーム", reading: "ruumu", meaning: "房间")]),
        Kana(character: "レ", romanization: "re", sound: "re",
             examples: [KanaExample(word: "レストラン", reading: "resutoran", meaning: "餐厅"),
                       KanaExample(word: "レモン", reading: "remon", meaning: "柠檬")]),
        Kana(character: "ロ", romanization: "ro", sound: "ro",
             examples: [KanaExample(word: "ロボット", reading: "robotto", meaning: "机器人"),
                       KanaExample(word: "ローマ", reading: "rooma", meaning: "罗马")]),
        
        // ワ行
        Kana(character: "ワ", romanization: "wa", sound: "wa",
             examples: [KanaExample(word: "ワイン", reading: "wain", meaning: "红酒"),
                       KanaExample(word: "ワープロ", reading: "waapuro", meaning: "文字处理器")]),
        Kana(character: "ヲ", romanization: "wo", sound: "wo",
             examples: [KanaExample(word: "ヲタク", reading: "wotaku", meaning: "御宅族"),
                       KanaExample(word: "ヲシテ", reading: "woshite", meaning: "（古语）为什么")]),
        Kana(character: "ン", romanization: "n", sound: "n",
             examples: [KanaExample(word: "パン", reading: "pan", meaning: "面包"),
                       KanaExample(word: "ボタン", reading: "botan", meaning: "按钮")]),
        
        // 浊音
        // ガ行
        Kana(character: "ガ", romanization: "ga", sound: "ga",
             examples: [KanaExample(word: "ガラス", reading: "garasu", meaning: "玻璃"),
                       KanaExample(word: "ガイド", reading: "gaido", meaning: "导游")]),
        Kana(character: "ギ", romanization: "gi", sound: "gi",
             examples: [KanaExample(word: "ギター", reading: "gitaa", meaning: "吉他"),
                       KanaExample(word: "ギフト", reading: "gifuto", meaning: "礼物")]),
        Kana(character: "グ", romanization: "gu", sound: "gu",
             examples: [KanaExample(word: "グラス", reading: "gurasu", meaning: "玻璃杯"),
                       KanaExample(word: "グループ", reading: "guruupu", meaning: "组")]),
        Kana(character: "ゲ", romanization: "ge", sound: "ge",
             examples: [KanaExample(word: "ゲーム", reading: "geemu", meaning: "游戏"),
                       KanaExample(word: "ゲスト", reading: "gesuto", meaning: "客人")]),
        Kana(character: "ゴ", romanization: "go", sound: "go",
             examples: [KanaExample(word: "ゴール", reading: "gooru", meaning: "目标"),
                       KanaExample(word: "ゴルフ", reading: "gorufu", meaning: "高尔夫")]),
        
        // ザ行
        Kana(character: "ザ", romanization: "za", sound: "za",
             examples: [KanaExample(word: "ザ・ビートルズ", reading: "za biitoruzu", meaning: "披头士乐队"),
                       KanaExample(word: "ピザ", reading: "piza", meaning: "披萨")]),
        Kana(character: "ジ", romanization: "ji", sound: "ji",
             examples: [KanaExample(word: "ジュース", reading: "juusu", meaning: "果汁"),
                       KanaExample(word: "ジーンズ", reading: "jiinzu", meaning: "牛仔裤")]),
        Kana(character: "ズ", romanization: "zu", sound: "zu",
             examples: [KanaExample(word: "ズボン", reading: "zubon", meaning: "裤子"),
                       KanaExample(word: "クイズ", reading: "kuizu", meaning: "测验")]),
        Kana(character: "ゼ", romanization: "ze", sound: "ze",
             examples: [KanaExample(word: "ゼロ", reading: "zero", meaning: "零"),
                       KanaExample(word: "マヨネーゼ", reading: "mayoneeze", meaning: "蛋黄酱")]),
        Kana(character: "ゾ", romanization: "zo", sound: "zo",
             examples: [KanaExample(word: "ゾーン", reading: "zoon", meaning: "区域"),
                       KanaExample(word: "ゾウ", reading: "zou", meaning: "象")]),
        
        // ダ行
        Kana(character: "ダ", romanization: "da", sound: "da",
             examples: [KanaExample(word: "ダンス", reading: "dansu", meaning: "舞蹈"),
                       KanaExample(word: "ダイヤ", reading: "daiya", meaning: "钻石")]),
        Kana(character: "ヂ", romanization: "ji", sound: "ji",
             examples: [KanaExample(word: "ヂェット", reading: "jetto", meaning: "喷气式"),
                       KanaExample(word: "カヂ", reading: "kaji", meaning: "火事")]),
        Kana(character: "ヅ", romanization: "zu", sound: "zu",
             examples: [KanaExample(word: "ヅカ", reading: "zuka", meaning: "冢"),
                       KanaExample(word: "カヅ", reading: "kazu", meaning: "数")]),
        Kana(character: "デ", romanization: "de", sound: "de",
             examples: [KanaExample(word: "デパート", reading: "depaato", meaning: "百货商店"),
                       KanaExample(word: "デザイン", reading: "dezain", meaning: "设计")]),
        Kana(character: "ド", romanization: "do", sound: "do",
             examples: [KanaExample(word: "ドア", reading: "doa", meaning: "门"),
                       KanaExample(word: "ドライブ", reading: "doraibu", meaning: "驾驶")]),
        
        // バ行
        Kana(character: "バ", romanization: "ba", sound: "ba",
             examples: [KanaExample(word: "バス", reading: "basu", meaning: "公共汽车"),
                       KanaExample(word: "バナナ", reading: "banana", meaning: "香蕉")]),
        Kana(character: "ビ", romanization: "bi", sound: "bi",
             examples: [KanaExample(word: "ビール", reading: "biiru", meaning: "啤酒"),
                       KanaExample(word: "ビデオ", reading: "bideo", meaning: "视频")]),
        Kana(character: "ブ", romanization: "bu", sound: "bu",
             examples: [KanaExample(word: "ブラシ", reading: "burashi", meaning: "刷子"),
                       KanaExample(word: "ブログ", reading: "burogu", meaning: "博客")]),
        Kana(character: "ベ", romanization: "be", sound: "be",
             examples: [KanaExample(word: "ベッド", reading: "beddo", meaning: "床"),
                       KanaExample(word: "ベル", reading: "beru", meaning: "铃")]),
        Kana(character: "ボ", romanization: "bo", sound: "bo",
             examples: [KanaExample(word: "ボール", reading: "booru", meaning: "球"),
                       KanaExample(word: "ボタン", reading: "botan", meaning: "按钮")]),
        
        // パ行（半浊音）
        Kana(character: "パ", romanization: "pa", sound: "pa",
             examples: [KanaExample(word: "パソコン", reading: "pasokon", meaning: "个人电脑"),
                       KanaExample(word: "パーティー", reading: "paatii", meaning: "派对")]),
        Kana(character: "ピ", romanization: "pi", sound: "pi",
             examples: [KanaExample(word: "ピアノ", reading: "piano", meaning: "钢琴"),
                       KanaExample(word: "ピザ", reading: "piza", meaning: "披萨")]),
        Kana(character: "プ", romanization: "pu", sound: "pu",
             examples: [KanaExample(word: "プール", reading: "puuru", meaning: "游泳池"),
                       KanaExample(word: "プレゼント", reading: "purezento", meaning: "礼物")]),
        Kana(character: "ペ", romanization: "pe", sound: "pe",
             examples: [KanaExample(word: "ペン", reading: "pen", meaning: "笔"),
                       KanaExample(word: "ペット", reading: "petto", meaning: "宠物")]),
        Kana(character: "ポ", romanization: "po", sound: "po",
             examples: [KanaExample(word: "ポスト", reading: "posuto", meaning: "邮箱"),
                       KanaExample(word: "ポケット", reading: "poketto", meaning: "口袋")])
    ]
}

// MARK: - Views
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            KanaLearningView()
                .tabItem {
                    Image(systemName: "textformat")
                    Text("假名")
                }
                .tag(0)
            
            VocabularyView()
                .tabItem {
                    Image(systemName: "book")
                    Text("单词")
                }
                .tag(1)
            
            GrammarView()
                .tabItem {
                    Image(systemName: "text.alignleft")
                    Text("语法")
                }
                .tag(2)
            
            ConversationView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("会话")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("我的")
                }
                .tag(4)
        }
    }
}

struct KanaLearningView: View {
    enum KanaType: String, CaseIterable {
        case hiragana = "平假名"
        case katakana = "片假名"
    }
    
    enum DakuonType: String, CaseIterable {
        case none = "清音"
        case dakuon = "浊音"
        case handakuon = "半浊音"
    }
    
    @State private var selectedKanaType: KanaType = .hiragana
    @State private var selectedDakuonType: DakuonType = .none
    @State private var showingQuiz = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 假名类型选择器
                    Picker("假名类型", selection: $selectedKanaType) {
                        ForEach(KanaType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // 音类型选择器
                    Picker("音类型", selection: $selectedDakuonType) {
                        ForEach(DakuonType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // 假名网格
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 10) {
                        let list = selectedKanaType == .hiragana ? KanaData.hiragana : KanaData.katakana
                        let targetRows = getTargetRows(for: selectedKanaType, dakuonType: selectedDakuonType)
                        
                        ForEach(getKanaRows(for: selectedKanaType, dakuonType: selectedDakuonType), id: \.id) { kana in
                            if !kana.character.isEmpty {
                                NavigationLink(destination: KanaDetailView(kana: kana)) {
                                    KanaCard(kana: kana)
                                }
                            } else {
                                KanaCard(kana: kana)
                            }
                        }
                    }
                    .padding()
                }
                
                Button(action: {
                    showingQuiz = true
                }) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                        Text("开始练习")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.bottom)
            }
            .navigationTitle("假名学习")
            .sheet(isPresented: $showingQuiz) {
                KanaQuizView(kanaType: selectedKanaType)
            }
        }
    }
    
    private func getTargetRows(for type: KanaType, dakuonType: DakuonType) -> [String] {
        switch dakuonType {
        case .none:
            return type == .hiragana ?
                ["あ", "か", "さ", "た", "な", "は", "ま", "や", "ら", "わ"] :
                ["ア", "カ", "サ", "タ", "ナ", "ハ", "マ", "ヤ", "ラ", "ワ"]
        case .dakuon:
            return type == .hiragana ?
                ["が", "ざ", "だ", "ば"] :
                ["ガ", "ザ", "ダ", "バ"]
        case .handakuon:
            return type == .hiragana ?
                ["ぱ"] :
                ["パ"]
        }
    }
    
    private func getKanaRows(for type: KanaType, dakuonType: DakuonType) -> [Kana] {
        let list = type == .hiragana ? KanaData.hiragana : KanaData.katakana
        let targetRows = getTargetRows(for: type, dakuonType: dakuonType)
        var result: [Kana] = []
        
        for row in targetRows {
            if dakuonType == .none {
                if (row == "や" || row == "ヤ") {
                    // や行的位置：や、　、ゆ、　、よ
                    if let ya = list.first(where: { $0.character == row }) { result.append(ya) }
                    result.append(Kana(character: "", romanization: "", sound: "", examples: []))
                    if let yu = list.first(where: { $0.character == (type == .hiragana ? "ゆ" : "ユ") }) { result.append(yu) }
                    result.append(Kana(character: "", romanization: "", sound: "", examples: []))
                    if let yo = list.first(where: { $0.character == (type == .hiragana ? "よ" : "ヨ") }) { result.append(yo) }
                } else if (row == "わ" || row == "ワ") {
                    // わ行的位置：わ、　、　、を、ん
                    if let wa = list.first(where: { $0.character == row }) { result.append(wa) }
                    result.append(Kana(character: "", romanization: "", sound: "", examples: []))
                    result.append(Kana(character: "", romanization: "", sound: "", examples: []))
                    if let wo = list.first(where: { $0.character == (type == .hiragana ? "を" : "ヲ") }) { result.append(wo) }
                    if let n = list.first(where: { $0.character == (type == .hiragana ? "ん" : "ン") }) { result.append(n) }
                } else {
                    // 正常的5字行
                    let rowChars = type == .hiragana ? 
                        getHiraganaRowChars(row: row) :
                        getKatakanaRowChars(row: row)
                    let rowKana = list.filter { kana in rowChars.contains(kana.character) }
                    result.append(contentsOf: rowKana)
                }
            } else {
                // 浊音和半浊音
                let rowChars = type == .hiragana ? 
                    getDakuonHiraganaRowChars(row: row) :
                    getDakuonKatakanaRowChars(row: row)
                let rowKana = list.filter { kana in rowChars.contains(kana.character) }
                result.append(contentsOf: rowKana)
            }
        }
        return result
    }
    
    private func getHiraganaRowChars(row: String) -> [String] {
        switch row {
        case "あ": return ["あ", "い", "う", "え", "お"]
        case "か": return ["か", "き", "く", "け", "こ"]
        case "さ": return ["さ", "し", "す", "せ", "そ"]
        case "た": return ["た", "ち", "つ", "て", "と"]
        case "な": return ["な", "に", "ぬ", "ね", "の"]
        case "は": return ["は", "ひ", "ふ", "へ", "ほ"]
        case "ま": return ["ま", "��", "む", "め", "も"]
        case "ら": return ["ら", "り", "る", "れ", "ろ"]
        default: return []
        }
    }
    
    private func getKatakanaRowChars(row: String) -> [String] {
        switch row {
        case "ア": return ["ア", "イ", "ウ", "エ", "オ"]
        case "カ": return ["カ", "キ", "ク", "ケ", "コ"]
        case "サ": return ["サ", "シ", "ス", "セ", "ソ"]
        case "タ": return ["タ", "チ", "ツ", "テ", "ト"]
        case "ナ": return ["ナ", "ニ", "ヌ", "ネ", "ノ"]
        case "ハ": return ["ハ", "ヒ", "フ", "ヘ", "ホ"]
        case "マ": return ["マ", "ミ", "ム", "メ", "モ"]
        case "ラ": return ["ラ", "リ", "ル", "レ", "ロ"]
        default: return []
        }
    }
    
    private func getDakuonHiraganaRowChars(row: String) -> [String] {
        switch row {
        case "が": return ["が", "ぎ", "ぐ", "げ", "ご"]
        case "ざ": return ["ざ", "じ", "ず", "ぜ", "ぞ"]
        case "だ": return ["だ", "ぢ", "づ", "で", "ど"]
        case "ば": return ["ば", "び", "ぶ", "べ", "ぼ"]
        case "ぱ": return ["ぱ", "ぴ", "ぷ", "ぺ", "ぽ"]
        default: return []
        }
    }
    
    private func getDakuonKatakanaRowChars(row: String) -> [String] {
        switch row {
        case "ガ": return ["ガ", "ギ", "グ", "ゲ", "ゴ"]
        case "ザ": return ["ザ", "ジ", "ズ", "ゼ", "ゾ"]
        case "ダ": return ["ダ", "ヂ", "ヅ", "デ", "ド"]
        case "バ": return ["バ", "ビ", "ブ", "ベ", "ボ"]
        case "パ": return ["パ", "ピ", "プ", "ペ", "ポ"]
        default: return []
        }
    }
}

struct KanaCard: View {
    let kana: Kana
    
    var body: some View {
        VStack(spacing: 4) {
            Text(kana.character)
                .font(.system(size: 36, weight: .bold))
            Text(kana.romanization)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 60, height: 60)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

struct KanaDetailView: View {
    let kana: Kana
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text(kana.character)
                    .font(.system(size: 120, weight: .bold))
                    .padding()
                
                VStack(spacing: 10) {
                    Text("发音：\(kana.romanization)")
                        .font(.title2)
                    
                    Button(action: {
                        // TODO: 播放发音
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("例词")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    ForEach(kana.examples) { example in
                        VStack(alignment: .leading) {
                            Text(example.word)
                                .font(.title3)
                            Text("\(example.reading) - \(example.meaning)")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .padding()
        }
        .navigationTitle("\(kana.character) - \(kana.romanization)")
    }
}

struct KanaQuizView: View {
    let kanaType: KanaLearningView.KanaType
    @Environment(\.presentationMode) var presentationMode
    @State private var currentQuestion = 0
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("测验功能开发中...")
            }
            .navigationTitle("假名测验")
            .navigationBarItems(trailing: Button("关闭") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct VocabularyView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("单词学习")
            }
            .navigationTitle("单词学习")
        }
    }
}

struct GrammarView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("语法学习")
            }
            .navigationTitle("语法学习")
        }
    }
}

struct ConversationView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("会话练习")
            }
            .navigationTitle("会话练习")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("学习进度")
            }
            .navigationTitle("我的")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
