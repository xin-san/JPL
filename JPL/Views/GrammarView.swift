import SwiftUI

struct GrammarView: View {
    @State private var selectedLevel = "N5"
    let levels = ["N5", "N4", "N3", "N2", "N1"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("等级", selection: $selectedLevel) {
                    ForEach(levels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                List {
                    // 这里后续添加语法点列表
                    Text("语法学习开发中...")
                }
            }
            .navigationTitle("语法学习")
        }
    }
}

struct GrammarView_Previews: PreviewProvider {
    static var previews: some View {
        GrammarView()
    }
}
