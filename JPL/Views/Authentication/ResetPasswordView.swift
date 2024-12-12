import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authService: AuthenticationService
    
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("重置密码")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                Text("请输入您的注册邮箱，我们将向您发送重置密码的链接")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("邮箱", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal, 30)
                
                Button(action: resetPassword) {
                    if authService.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("发送重置链接")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 30)
                .disabled(authService.isLoading)
                
                Spacer()
            }
            .navigationBarItems(leading: Button("返回") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(isSuccess ? "发送成功" : "发送失败"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("确定")) {
                        if isSuccess {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "请输入邮箱地址"
            showAlert = true
            return
        }
        
        Task {
            do {
                try await authService.resetPassword(email: email)
                isSuccess = true
                alertMessage = "重置密码链接已发送到您的邮箱，请查收"
                showAlert = true
            } catch {
                isSuccess = false
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
} 