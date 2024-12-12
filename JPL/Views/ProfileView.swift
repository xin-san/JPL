import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authService: AuthenticationService
    @State private var showingLogoutAlert = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                if let user = authService.currentUser {
                    Section("个人信息") {
                        HStack {
                            Text("头像")
                            Spacer()
                            if let url = user.profileImageUrl {
                                AsyncImage(url: URL(string: url)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
                                }
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        HStack {
                            Text("昵称")
                            Spacer()
                            Text(user.displayName ?? "未设置")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("邮箱")
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Section("学习信息") {
                        HStack {
                            Text("当前等级")
                            Spacer()
                            Text(user.learningLevel)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("学习天数")
                            Spacer()
                            Text("\(user.studyStreak)天")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("已完成课程")
                            Spacer()
                            Text("\(user.completedLessons.count)个")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingLogoutAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("退出登录")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("个人中心")
            .alert("确认退出", isPresented: $showingLogoutAlert) {
                Button("取消", role: .cancel) { }
                Button("退出", role: .destructive) {
                    Task {
                        do {
                            try await authService.signOut()
                        } catch {
                            errorMessage = error.localizedDescription
                            showingErrorAlert = true
                        }
                    }
                }
            } message: {
                Text("确定要退出登录吗？")
            }
            .alert("退出失败", isPresented: $showingErrorAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
