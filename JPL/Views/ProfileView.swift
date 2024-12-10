import SwiftUI

struct ProfileView: View {
    @State private var username = "用户名"
    @State private var learningDays = 0
    @State private var masteredKana = 0
    @State private var masteredWords = 0
    
    var body: some View {
        NavigationView {
            List {
                Section("个人信息") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(username)
                                .font(.title2)
                            Text("学习天数: \(learningDays)天")
                                .font(.caption)
                        }
                    }
                }
                
                Section("学习统计") {
                    HStack {
                        VStack {
                            Text("\(masteredKana)")
                                .font(.title2)
                            Text("已掌握假名")
                                .font(.caption)
                        }
                        Spacer()
                        VStack {
                            Text("\(masteredWords)")
                                .font(.title2)
                            Text("已掌握词汇")
                                .font(.caption)
                        }
                    }
                    .padding()
                }
                
                Section("设置") {
                    NavigationLink("学习提醒") {
                        Text("提醒设置")
                    }
                    NavigationLink("学习目标") {
                        Text("目标设置")
                    }
                    NavigationLink("关于") {
                        Text("关于应用")
                    }
                }
            }
            .navigationTitle("个人中心")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
