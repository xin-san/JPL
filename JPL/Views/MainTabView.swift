import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            KanaLearningView()
                .tabItem {
                    Label("假名", systemImage: "a.circle")
                }
            
            VocabularyView()
                .tabItem {
                    Label("词汇", systemImage: "book")
                }
            
            GrammarView()
                .tabItem {
                    Label("语法", systemImage: "text.book.closed")
                }
            
            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person")
                }
            
            CoreDataTestView()
                .tabItem {
                    Label("测试", systemImage: "hammer.fill")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
} 